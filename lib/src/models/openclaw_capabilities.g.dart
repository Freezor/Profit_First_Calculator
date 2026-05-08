// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'openclaw_capabilities.dart';

OpenClawCapabilities _$OpenClawCapabilitiesFromJson(Map<String, dynamic> json) =>
    OpenClawCapabilities(
      runs: json['runs'] as bool,
      attention: json['attention'] as bool,
      commands: json['commands'] as bool,
      approvals: json['approvals'] as bool,
      events: json['events'] as bool,
    );

Map<String, dynamic> _$OpenClawCapabilitiesToJson(OpenClawCapabilities instance) =>
    <String, dynamic>{
      'runs': instance.runs,
      'attention': instance.attention,
      'commands': instance.commands,
      'approvals': instance.approvals,
      'events': instance.events,
    };
