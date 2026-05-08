import 'package:json_annotation/json_annotation.dart';

import '../enums.dart';
import '../logger.dart';
import '../result.dart';

part 'run_event.g.dart';

/// An individual event emitted during an agent run's history.
@JsonSerializable()
final class RunEvent {
  const RunEvent({
    required this.eventId,
    required this.runId,
    required this.timestamp,
    required this.type,
    required this.severity,
    required this.summary,
    this.details,
  });

  /// Stable unique identifier for the event.
  final String eventId;

  /// Identifier of the run that emitted this event.
  final String runId;

  /// Timestamp when the event occurred.
  final DateTime timestamp;

  /// Backend-defined event type, preserved as a string for forward compatibility.
  final String type;

  /// Severity level used to style and filter the event stream.
  @JsonKey(fromJson: EventSeverity.fromJson, toJson: _eventSeverityToJson)
  final EventSeverity severity;

  /// Short human-readable event summary.
  final String summary;

  /// Optional structured details associated with the event.
  final Map<String, dynamic>? details;

  factory RunEvent.fromJson(Map<String, dynamic> json) => _$RunEventFromJson(json);

  Map<String, dynamic> toJson() => _$RunEventToJson(this);

  /// Safely parses a run event and returns a structured failure on invalid JSON.
  static Result<RunEvent, ModelParseFailure> tryFromJson(
    Map<String, dynamic> json, {
    OpenClawLogger? logger,
  }) {
    const modelName = 'RunEvent';
    final log = logger ?? OpenClawLogger();
    try {
      final value = RunEvent.fromJson(json);
      log.parseSuccess(modelName, context: {'eventId': value.eventId, 'runId': value.runId});
      return Result.success(value);
    } catch (error, stackTrace) {
      log.parseFailure(modelName, error, stackTrace, context: {'eventId': json['eventId']});
      return Result.failure(ModelParseFailure(
        modelName: modelName,
        message: 'Unable to parse run event.',
        source: error,
        stackTrace: stackTrace,
      ));
    }
  }
}

String _eventSeverityToJson(EventSeverity value) => value.toJson();
