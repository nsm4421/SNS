import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sns/features/auth/data/datasource/remote/remote_auth.datasource_impl.dart';
import 'package:sns/features/auth/data/model/request/sign_up_request.model.dart';
import 'package:sns/features/poll/data/datasource/remote/remote_poll.datasource_impl.dart';
import 'package:sns/features/poll/data/model/reuqest/create_topic_request.model.dart';
import 'package:sns/features/poll/data/model/topic.model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:sns/core/env/env.dart';

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
    pollDataSource = RemotePollDataSourceImpl(client);

    // 회원가입
    await authDataSource.signUp(
      SignUpRequestModel(email: email, username: username, password: password),
    );
    if (client.auth.currentSession == null) {
      await client.auth.signInWithPassword(email: email, password: password);
    }
  });

  group('RemotePollDataSource', () {
    late String topicId;
    late String optionId;

    test('RPC함수를 사용해 Topic 생성하기', () async {
      final dto = CreateTopicRequestModel(
        title: '통합 테스트 주제 $suffix',
        description: '설명입니다',
        options: const ['선택지1', '선택지2', '선택지3'],
      );

      topicId = (await pollDataSource.createTopic(dto))!;
      expect(topicId, isNotNull);
    });

    test('fetch topics 함수 테스트', () async {
      final topics = await pollDataSource.fetchTopics(limit: 20, offset: 0);
      expect(topics, isNotEmpty);
    });

    test('생성한 Topic 조회하고 투표시 vote count증가하고, 취소하면 감소', () async {
      TopicModel topic = await pollDataSource.findTopicById(topicId);
      optionId = topic.options.first.id;

      expect(topic.options, isNotEmpty);
      expect(topic.options.first.voteCount, 0); // 처음엔 투표 수가 0
      expect(optionId, isNotNull);

      // 투표한 후에 다시 조회한면 vote count 증가
      final voteId = await pollDataSource.upsertVoteByOptionId(optionId);
      topic = await pollDataSource.findTopicById(topicId);
      expect(topic.options.first.voteCount, equals(1));

      // 투표를 취소한 후 다시 조회하면 vote count 감소
      await pollDataSource.deleteVoteById(voteId);
      topic = await pollDataSource.findTopicById(topicId);
      expect(topic.options.first.voteCount, equals(0));
    });
  });

  tearDownAll(() async {
    await authDataSource.signOut();
  });
}
