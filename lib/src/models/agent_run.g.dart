// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent_run.dart';

AgentRun _$AgentRunFromJson(Map<String, dynamic> json) => AgentRun(
      runId: json['runId'] as String,
      sourceType: json['sourceType'] as String,
      label: json['label'] as String,
      goal: json['goal'] as String,
      lifecycleState: RunLifecycleState.fromJson(json['lifecycleState']),
      attentionState: RunAttentionState.fromJson(json['attentionState']),
      lastMeaningfulEvent: json['lastMeaningfulEvent'] as String,
      lastActivityAt: DateTime.parse(json['lastActivityAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      openInSourceUrl: json['openInSourceUrl'] == null
          ? null
          : Uri.parse(json['openInSourceUrl'] as String),
      isPinned: json['isPinned'] as bool? ?? false,
      localNote: json['localNote'] as String?,
    );

Map<String, dynamic> _$AgentRunToJson(AgentRun instance) => <String, dynamic>{
      'runId': instance.runId,
      'sourceType': instance.sourceType,
      'label': instance.label,
      'goal': instance.goal,
      'lifecycleState': _runLifecycleStateToJson(instance.lifecycleState),
      'attentionState': _runAttentionStateToJson(instance.attentionState),
      'lastMeaningfulEvent': instance.lastMeaningfulEvent,
      'lastActivityAt': instance.lastActivityAt.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'openInSourceUrl': instance.openInSourceUrl?.toString(),
      'isPinned': instance.isPinned,
      'localNote': instance.localNote,
    };
