// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'steering_command.dart';

SteeringCommand _$SteeringCommandFromJson(Map<String, dynamic> json) =>
    SteeringCommand(
      type: SteeringCommandType.fromJson(json['type']),
      text: json['text'] as String,
    );

Map<String, dynamic> _$SteeringCommandToJson(SteeringCommand instance) =>
    <String, dynamic>{
      'type': _steeringCommandTypeToJson(instance.type),
      'text': instance.text,
    };
