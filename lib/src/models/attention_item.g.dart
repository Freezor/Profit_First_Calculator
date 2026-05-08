// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attention_item.dart';

AttentionItem _$AttentionItemFromJson(Map<String, dynamic> json) => AttentionItem(
      attentionItemId: json['attentionItemId'] as String,
      runId: json['runId'] as String,
      type: AttentionType.fromJson(json['type']),
      riskLevel: RiskLevel.fromJson(json['riskLevel']),
      title: json['title'] as String,
      reason: json['reason'] as String,
      recommendedAction: json['recommendedAction'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: AttentionItemStatus.fromJson(json['status']),
      availableActions: (json['availableActions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$AttentionItemToJson(AttentionItem instance) =>
    <String, dynamic>{
      'attentionItemId': instance.attentionItemId,
      'runId': instance.runId,
      'type': _attentionTypeToJson(instance.type),
      'riskLevel': _riskLevelToJson(instance.riskLevel),
      'title': instance.title,
      'reason': instance.reason,
      'recommendedAction': instance.recommendedAction,
      'createdAt': instance.createdAt.toIso8601String(),
      'status': _attentionItemStatusToJson(instance.status),
      'availableActions': instance.availableActions,
    };
