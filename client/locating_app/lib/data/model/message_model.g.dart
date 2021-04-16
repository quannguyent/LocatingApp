// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) {
  return MessageModel(
    conversationId: json['conversation_id'] as String ?? '',
    senderId: json['sender_id'] as String ?? '',
    count: json['count'] as int ?? 0,
    createdAt: (json['created_at'] as num)?.toDouble() ?? 0,
    reply: json['reply'] as String ?? '',
  );
}

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'conversation_id': instance.conversationId,
      'sender_id': instance.senderId,
      'count': instance.count,
      'created_at': instance.createdAt,
      'reply': instance.reply,
    };
