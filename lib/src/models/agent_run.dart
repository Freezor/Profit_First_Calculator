import 'package:json_annotation/json_annotation.dart';

import '../enums.dart';
import '../logger.dart';
import '../result.dart';

part 'agent_run.g.dart';

/// Tracks the execution state and dashboard metadata for an agent task.
@JsonSerializable()
final class AgentRun {
  const AgentRun({
    required this.runId,
    required this.sourceType,
    required this.label,
    required this.goal,
    required this.lifecycleState,
    required this.attentionState,
    required this.lastMeaningfulEvent,
    required this.lastActivityAt,
    required this.createdAt,
    this.openInSourceUrl,
    this.isPinned = false,
    this.localNote,
  });

  /// Stable unique identifier for the run.
  final String runId;

  /// Originating system type, such as `github`, `local`, or `api`.
  final String sourceType;

  /// Short display label used in run lists.
  final String label;

  /// User-visible goal or task prompt for the run.
  final String goal;

  /// Current execution lifecycle state.
  @JsonKey(fromJson: RunLifecycleState.fromJson, toJson: _runLifecycleStateToJson)
  final RunLifecycleState lifecycleState;

  /// Current human-attention state for the run.
  @JsonKey(fromJson: RunAttentionState.fromJson, toJson: _runAttentionStateToJson)
  final RunAttentionState attentionState;

  /// Most recent important event summary shown in compact dashboards.
  final String lastMeaningfulEvent;

  /// Timestamp of the latest observed activity for sorting and freshness checks.
  final DateTime lastActivityAt;

  /// Timestamp when the run was created by OpenClaw.
  final DateTime createdAt;

  /// Optional deep link back to the source system for this run.
  final Uri? openInSourceUrl;

  /// Local UI preference indicating whether this run should stay pinned.
  final bool isPinned;

  /// Local operator note that is not authoritative server state.
  final String? localNote;

  factory AgentRun.fromJson(Map<String, dynamic> json) => _$AgentRunFromJson(json);

  Map<String, dynamic> toJson() => _$AgentRunToJson(this);

  /// Safely parses an agent run and returns a structured failure on invalid JSON.
  static Result<AgentRun, ModelParseFailure> tryFromJson(
    Map<String, dynamic> json, {
    OpenClawLogger? logger,
  }) {
    const modelName = 'AgentRun';
    final log = logger ?? OpenClawLogger();
    try {
      final value = AgentRun.fromJson(json);
      log.parseSuccess(modelName, context: {'runId': value.runId});
      return Result.success(value);
    } catch (error, stackTrace) {
      log.parseFailure(modelName, error, stackTrace, context: {'runId': json['runId']});
      return Result.failure(ModelParseFailure(
        modelName: modelName,
        message: 'Unable to parse agent run.',
        source: error,
        stackTrace: stackTrace,
      ));
    }
  }
}

String _runLifecycleStateToJson(RunLifecycleState value) => value.toJson();
String _runAttentionStateToJson(RunAttentionState value) => value.toJson();
