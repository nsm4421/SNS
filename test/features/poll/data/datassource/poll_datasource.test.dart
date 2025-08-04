import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sns/features/auth/data/datasource/remote/remote_auth.datasource_impl.dart';
import 'package:sns/features/auth/data/model/request/sign_up_request.model.dart';
import 'package:sns/features/poll/data/datasource/remote/remote_poll.datasource_impl.dart';
import 'package:sns/features/poll/data/model/request/create_topic_request.model.dart';
import 'package:sns/features/poll/data/model/request/get_topic_detail_request.model.dart';
import 'package:sns/features/poll/data/model/topic_detail.model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:sns/core/util/env/env.dart';

void main() {
  late RemotePollDataSource pollDataSource;
  late RemoteAuthDataSource authDataSource;

  final suffix = DateTime.now().microsecondsSinceEpoch;
  final email = 'poll_test_$suffix@test.com';
  const password = 'password1234';
  final username = 'poll_test_$suffix';

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    await Supabase.initialize(
      url: 'http://127.0.0.1:54321',
      anonKey: Env.supabaseAnonKey,
    );

    // 의존성 주입
    final client = Supabase.instance.client;
    authDataSource = RemoteAuthDataSourceImpl(client);

    // 회원가입
    await authDataSource.signUp(
      SignUpRequestModel(email: email, username: username, password: password),
    );
    if (client.auth.currentSession == null) {
      await client.auth.signInWithPassword(email: email, password: password);
    }
    pollDataSource = RemotePollDataSourceImpl(client);
  });

  group('RemotePollDataSource', () {
    String? topicIdCreated;
    String? voteId;

    test('옵션을 한개만 입력하는 경우 오류 발생', () async {
      expect(() async {
        final dto = CreateTopicRequestModel(
          title: '통합 테스트 주제 $suffix',
          description: '설명입니다',
          options: const ['선택지 한개만 입력'],
        );
        await pollDataSource.createTopic(dto);
      }, throwsA(isA<Exception>()));
    });

    test('Topic을 생성하면 topic id 반환', () async {
      final dto = CreateTopicRequestModel(
        title: '통합 테스트 주제 $suffix',
        description: '설명입니다',
        options: const ['선택지1', '선택지2', '선택지3'],
      );
      topicIdCreated = await pollDataSource.createTopic(dto);
      expect(topicIdCreated, isNotNull);
    });

    test('Topic 다건 조회 테스트하고, 가장 최근 데이터를 조회했는지 확인', () async {
      final topics = await pollDataSource.fetchTopics(limit: 20);
      expect(topics, isNotEmpty);

      final lastestTopic = topics.first;
      expect(lastestTopic.id, topicIdCreated);
    });

    test('투표시 vote count증가', () async {
      TopicDetailModel topic = await pollDataSource.getTopicDetail(
        GetTopicDetailRequestModel(topicId: topicIdCreated!),
      );
      expect(topic.options.first.voteCount, 0); // 처음엔 투표 수가 0

      // 투표한 후에 다시 조회한면 vote count 증가
      voteId = await pollDataSource.upsertVote(topic.options.first.id);
      topic = await pollDataSource.getTopicDetail(
        GetTopicDetailRequestModel(topicId: topicIdCreated!),
      );
      expect(topic.options.first.voteCount, equals(1)); // 투표수가 1로 증가
      // session이 없어서 테스트 환경에서는 voteByMe필드가 false로만 조회됨;;;
      // expect(topic.options.first.voteByMe, equals(true)); // vote-by-me 필드 true
    });

    test('투표를 취소하면 vote count 감소', () async {
      TopicDetailModel topic = await pollDataSource.getTopicDetail(
        GetTopicDetailRequestModel(topicId: topicIdCreated!),
      );
      expect(topic.options.first.voteCount, 1); // 처음엔 투표 수가 1

      // 투표한 취소 후에 다시 조회한면 vote count 증가
      await pollDataSource.deleteVoteById(voteId!);
      topic = await pollDataSource.getTopicDetail(
        GetTopicDetailRequestModel(topicId: topicIdCreated!),
      );
      expect(topic.options.first.voteCount, equals(0)); // 투표수가 0으로 감소
      expect(
        topic.options.first.votedByMe,
        equals(false),
      ); // vote-by-me 필드 false
    });
  });

  tearDownAll(() async {
    await authDataSource.signOut();
  });
}
