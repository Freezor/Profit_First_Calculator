// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'command_result.dart';

CommandResult _$CommandResultFromJson(Map<String, dynamic> json) => CommandResult(
      state: CommandResultState.fromJson(json['state']),
      summary: json['summary'] as String,
    );

Map<String, dynamic> _$CommandResultToJson(CommandResult instance) =>
    <String, dynamic>{
      'state': _commandResultStateToJson(instance.state),
      'summary': instance.summary,
    };
