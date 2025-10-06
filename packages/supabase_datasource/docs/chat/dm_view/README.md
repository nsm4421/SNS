create or replace view public.v_my_dm_rooms as
select
    r.id                                         as room_id,
    -- 대화 상대방
    case when auth.uid() = r.user1_id then r.user2_id 
    else r.user1_id end                          as counterpart_id,
    p.username                                   as counterpart_username,
    p.avatar_url                                 as counterpart_avatar_url,
    -- 읽음 상태
    rs.unread_count,
    rs.last_read_message_id,
    rs.last_read_at,
    -- 최신 메세지
    lm.id                                         as last_message_id,
    lm.sender_id                                  as last_message_sender_id,
    lm.msg_type::text                             as last_message_type,
    lm.content                                    as last_message_content,
    lm.created_at                                 as last_message_created_at,
    -- 작성,수정시간
    coalesce(r.last_message_at, r.created_at)     as sort_ts,
    r.created_at,
    r.updated_at
from public.dm_rooms r
-- 내 읽음 상태(없으면 null)
left join public.dm_room_read_state rs
on rs.room_id = r.id and rs.user_id = auth.uid()

-- 상대 프로필(프로필 테이블 없으면 이 JOIN 삭제)
left join public.profiles p
on p.user_id = (case when auth.uid() = r.user1_id then r.user2_id else r.user1_id end)

-- 각 방의 마지막 메시지 1건
left join lateral (
    select m.*
    from public.dm_messages m
    where m.room_id = r.id and m.deleted_at is null
    order by m.created_at desc, m.id desc
    limit 1
) lm on true
where (auth.uid() = r.user1_id) or (auth.uid() = r.user2_id);

create or replace view public.v_my_dm_messages as
select
    m.id                                      as message_id,
    m.room_id,
    m.sender_id,
    (m.sender_id = auth.uid())                as is_mine,
    m.msg_type::text                          as msg_type,
    m.content,
    m.metadata,
    m.created_at,
    m.deleted_at,
    -- 내가 읽은 기준선(마지막 읽은 메시지의 created_at)과 비교
    (m.created_at <= coalesce(my_cutoff.cutoff, to_timestamp(0)))   as is_read_for_me,
    -- 상대가 읽은 기준선과 비교 (상대가 없으면 false)
    (m.created_at <= coalesce(other_cutoff.cutoff, to_timestamp(0))) as is_read_for_other
from public.dm_messages m
join public.dm_rooms r
on r.id = m.room_id
-- 내 읽음 기준선: 내 last_read_message_id의 created_at
left join lateral (
    select m2.created_at as cutoff
    from public.dm_room_read_state s
    join public.dm_messages m2 on m2.id = s.last_read_message_id
    where s.room_id = r.id and s.user_id = auth.uid()
) my_cutoff on true
-- 상대방 읽음 기준선: 상대 last_read_message_id의 created_at
left join lateral (
    select m2.created_at as cutoff
    from public.dm_room_read_state s
    join public.dm_messages m2 on m2.id = s.last_read_message_id
    where s.room_id = r.id
        and s.user_id = (case when auth.uid() = r.user1_id then r.user2_id else r.user1_id end)
) other_cutoff on true
-- 내 방의 메시지만
where (auth.uid() = r.user1_id) or (auth.uid() = r.user2_id);

