json.id                   match.id
json.target_creator_id    match.target_creator_id
json.target_compatible_id match.target_compatible_id
json.user_creator_id      match.user_creator_id
json.user_compatible_id   match.user_compatible_id
json.conversation_id      match.conversation_id
json.last_message         match.conversation.messages.last.body
json.unread_messages      match.opposite_user_unread_messages_count(current_user)
