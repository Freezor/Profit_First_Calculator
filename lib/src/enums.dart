import 'package:json_annotation/json_annotation.dart';

/// Lifecycle state for an agent run.
enum RunLifecycleState {
  @JsonValue('queued') queued,
  @JsonValue('running') running,
  @JsonValue('waiting') waiting,
  @JsonValue('completed') completed,
  @JsonValue('failed') failed,
  @JsonValue('cancelled') cancelled,
  @JsonValue('unknown') unknown;

  static RunLifecycleState fromJson(Object? value) => _decode(
        value,
        values,
        _runLifecycleStateWireNames,
        unknown,
      );

  String toJson() => _runLifecycleStateWireNames[this]!;
}

const _runLifecycleStateWireNames = <RunLifecycleState, String>{
  RunLifecycleState.queued: 'queued',
  RunLifecycleState.running: 'running',
  RunLifecycleState.waiting: 'waiting',
  RunLifecycleState.completed: 'completed',
  RunLifecycleState.failed: 'failed',
  RunLifecycleState.cancelled: 'cancelled',
  RunLifecycleState.unknown: 'unknown',
};

/// Human-attention state for an agent run.
enum RunAttentionState {
  @JsonValue('none') none,
  @JsonValue('needs_attention') needsAttention,
  @JsonValue('blocked') blocked,
  @JsonValue('resolved') resolved,
  @JsonValue('unknown') unknown;

  static RunAttentionState fromJson(Object? value) => _decode(
        value,
        values,
        _runAttentionStateWireNames,
        unknown,
      );

  String toJson() => _runAttentionStateWireNames[this]!;
}

const _runAttentionStateWireNames = <RunAttentionState, String>{
  RunAttentionState.none: 'none',
  RunAttentionState.needsAttention: 'needs_attention',
  RunAttentionState.blocked: 'blocked',
  RunAttentionState.resolved: 'resolved',
  RunAttentionState.unknown: 'unknown',
};

/// Category of an attention item raised by the backend.
enum AttentionType {
  @JsonValue('approval') approval,
  @JsonValue('risk') risk,
  @JsonValue('question') question,
  @JsonValue('blocked') blocked,
  @JsonValue('manual_review') manualReview,
  @JsonValue('unknown') unknown;

  static AttentionType fromJson(Object? value) => _decode(
        value,
        values,
        _attentionTypeWireNames,
        unknown,
      );

  String toJson() => _attentionTypeWireNames[this]!;
}

const _attentionTypeWireNames = <AttentionType, String>{
  AttentionType.approval: 'approval',
  AttentionType.risk: 'risk',
  AttentionType.question: 'question',
  AttentionType.blocked: 'blocked',
  AttentionType.manualReview: 'manual_review',
  AttentionType.unknown: 'unknown',
};

/// Risk level used to prioritize attention items.
enum RiskLevel {
  @JsonValue('low') low,
  @JsonValue('medium') medium,
  @JsonValue('high') high,
  @JsonValue('critical') critical,
  @JsonValue('unknown') unknown;

  static RiskLevel fromJson(Object? value) => _decode(
        value,
        values,
        _riskLevelWireNames,
        unknown,
      );

  String toJson() => _riskLevelWireNames[this]!;
}

const _riskLevelWireNames = <RiskLevel, String>{
  RiskLevel.low: 'low',
  RiskLevel.medium: 'medium',
  RiskLevel.high: 'high',
  RiskLevel.critical: 'critical',
  RiskLevel.unknown: 'unknown',
};

/// Workflow status for an attention item.
enum AttentionItemStatus {
  @JsonValue('open') open,
  @JsonValue('acknowledged') acknowledged,
  @JsonValue('resolved') resolved,
  @JsonValue('dismissed') dismissed,
  @JsonValue('unknown') unknown;

  static AttentionItemStatus fromJson(Object? value) => _decode(
        value,
        values,
        _attentionItemStatusWireNames,
        unknown,
      );

  String toJson() => _attentionItemStatusWireNames[this]!;
}

const _attentionItemStatusWireNames = <AttentionItemStatus, String>{
  AttentionItemStatus.open: 'open',
  AttentionItemStatus.acknowledged: 'acknowledged',
  AttentionItemStatus.resolved: 'resolved',
  AttentionItemStatus.dismissed: 'dismissed',
  AttentionItemStatus.unknown: 'unknown',
};

/// User command type sent to a running agent.
enum SteeringCommandType {
  @JsonValue('continue') continueRun,
  @JsonValue('pause') pause,
  @JsonValue('cancel') cancel,
  @JsonValue('approve') approve,
  @JsonValue('reject') reject,
  @JsonValue('message') message,
  @JsonValue('unknown') unknown;

  static SteeringCommandType fromJson(Object? value) => _decode(
        value,
        values,
        _steeringCommandTypeWireNames,
        unknown,
      );

  String toJson() => _steeringCommandTypeWireNames[this]!;
}

const _steeringCommandTypeWireNames = <SteeringCommandType, String>{
  SteeringCommandType.continueRun: 'continue',
  SteeringCommandType.pause: 'pause',
  SteeringCommandType.cancel: 'cancel',
  SteeringCommandType.approve: 'approve',
  SteeringCommandType.reject: 'reject',
  SteeringCommandType.message: 'message',
  SteeringCommandType.unknown: 'unknown',
};

/// Result state returned after sending a steering command.
enum CommandResultState {
  @JsonValue('accepted') accepted,
  @JsonValue('rejected') rejected,
  @JsonValue('queued') queued,
  @JsonValue('failed') failed,
  @JsonValue('unknown') unknown;

  static CommandResultState fromJson(Object? value) => _decode(
        value,
        values,
        _commandResultStateWireNames,
        unknown,
      );

  String toJson() => _commandResultStateWireNames[this]!;
}

const _commandResultStateWireNames = <CommandResultState, String>{
  CommandResultState.accepted: 'accepted',
  CommandResultState.rejected: 'rejected',
  CommandResultState.queued: 'queued',
  CommandResultState.failed: 'failed',
  CommandResultState.unknown: 'unknown',
};

/// Severity level for run events.
enum EventSeverity {
  @JsonValue('debug') debug,
  @JsonValue('info') info,
  @JsonValue('warning') warning,
  @JsonValue('error') error,
  @JsonValue('critical') critical,
  @JsonValue('unknown') unknown;

  static EventSeverity fromJson(Object? value) => _decode(
        value,
        values,
        _eventSeverityWireNames,
        unknown,
      );

  String toJson() => _eventSeverityWireNames[this]!;
}

const _eventSeverityWireNames = <EventSeverity, String>{
  EventSeverity.debug: 'debug',
  EventSeverity.info: 'info',
  EventSeverity.warning: 'warning',
  EventSeverity.error: 'error',
  EventSeverity.critical: 'critical',
  EventSeverity.unknown: 'unknown',
};

T _decode<T extends Enum>(
  Object? value,
  List<T> values,
  Map<T, String> wireNames,
  T fallback,
) {
  if (value is! String) return fallback;
  final normalized = value.trim().toLowerCase();
  for (final entry in wireNames.entries) {
    if (entry.value == normalized || entry.key.name.toLowerCase() == normalized) {
      return entry.key;
    }
  }
  return fallback;
}
