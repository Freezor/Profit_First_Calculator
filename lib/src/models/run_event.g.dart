// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'run_event.dart';

RunEvent _$RunEventFromJson(Map<String, dynamic> json) => RunEvent(
      eventId: json['eventId'] as String,
      runId: json['runId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: json['type'] as String,
      severity: EventSeverity.fromJson(json['severity']),
      summary: json['summary'] as String,
      details: json['details'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$RunEventToJson(RunEvent instance) => <String, dynamic>{
      'eventId': instance.eventId,
      'runId': instance.runId,
      'timestamp': instance.timestamp.toIso8601String(),
      'type': instance.type,
      'severity': _eventSeverityToJson(instance.severity),
      'summary': instance.summary,
      'details': instance.details,
    };
