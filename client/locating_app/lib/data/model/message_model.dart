import 'package:json_annotation/json_annotation.dart';
part 'message_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MessageModel {
  @JsonKey(name: "conversation_id", defaultValue: "")
  String conversationId;

  @JsonKey(name: "sender_id", defaultValue: "")
  String senderId;

  @JsonKey(name: "count", defaultValue: 0)
  int count;

  @JsonKey(name: "created_at", defaultValue: 0)
  double createdAt;

  @JsonKey(name: "reply", defaultValue: "")
  String reply;


  MessageModel(
      {this.conversationId,
      this.senderId,
      this.count,
      this.createdAt,
      this.reply});

  static MessageModel fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
}
