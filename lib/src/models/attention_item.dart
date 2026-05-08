import 'package:json_annotation/json_annotation.dart';

import '../enums.dart';
import '../logger.dart';
import '../result.dart';

part 'attention_item.g.dart';

/// A decision, issue, or risk that requires human attention.
@JsonSerializable()
final class AttentionItem {
  const AttentionItem({
    required this.attentionItemId,
    required this.runId,
    required this.type,
    required this.riskLevel,
    required this.title,
    required this.reason,
    required this.recommendedAction,
    required this.createdAt,
    required this.status,
    required this.availableActions,
  });

  /// Stable unique identifier for the attention item.
  final String attentionItemId;

  /// Identifier of the run that raised this attention item.
  final String runId;

  /// Category describing why human input is needed.
  @JsonKey(fromJson: AttentionType.fromJson, toJson: _attentionTypeToJson)
  final AttentionType type;

  /// Risk severity used for prioritization and alerting.
  @JsonKey(fromJson: RiskLevel.fromJson, toJson: _riskLevelToJson)
  final RiskLevel riskLevel;

  /// Short title displayed in attention queues.
  final String title;

  /// Explanation of the issue or decision context.
  final String reason;

  /// Suggested operator action from the server.
  final String recommendedAction;

  /// Timestamp when the item was created.
  final DateTime createdAt;

  /// Current workflow status of this attention item.
  @JsonKey(fromJson: AttentionItemStatus.fromJson, toJson: _attentionItemStatusToJson)
  final AttentionItemStatus status;

  /// Server-supported action identifiers that can be applied to this item.
  final List<String> availableActions;

  factory AttentionItem.fromJson(Map<String, dynamic> json) => _$AttentionItemFromJson(json);

  Map<String, dynamic> toJson() => _$AttentionItemToJson(this);

  /// Safely parses an attention item and returns a structured failure on invalid JSON.
  static Result<AttentionItem, ModelParseFailure> tryFromJson(
    Map<String, dynamic> json, {
    OpenClawLogger? logger,
  }) {
    const modelName = 'AttentionItem';
    final log = logger ?? OpenClawLogger();
    try {
      final value = AttentionItem.fromJson(json);
      log.parseSuccess(modelName, context: {'attentionItemId': value.attentionItemId});
      return Result.success(value);
    } catch (error, stackTrace) {
      log.parseFailure(modelName, error, stackTrace, context: {'attentionItemId': json['attentionItemId']});
      return Result.failure(ModelParseFailure(
        modelName: modelName,
        message: 'Unable to parse attention item.',
        source: error,
        stackTrace: stackTrace,
      ));
    }
  }
}

String _attentionTypeToJson(AttentionType value) => value.toJson();
String _riskLevelToJson(RiskLevel value) => value.toJson();
String _attentionItemStatusToJson(AttentionItemStatus value) => value.toJson();
