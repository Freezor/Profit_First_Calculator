import 'package:json_annotation/json_annotation.dart';

import '../enums.dart';
import '../logger.dart';
import '../result.dart';

part 'steering_command.g.dart';

/// User instruction sent to an agent run.
@JsonSerializable()
final class SteeringCommand {
  const SteeringCommand({
    required this.type,
    required this.text,
  });

  /// Command intent that OpenClaw should apply to the run.
  @JsonKey(fromJson: SteeringCommandType.fromJson, toJson: _steeringCommandTypeToJson)
  final SteeringCommandType type;

  /// Human-authored instruction or decision text.
  final String text;

  factory SteeringCommand.fromJson(Map<String, dynamic> json) => _$SteeringCommandFromJson(json);

  Map<String, dynamic> toJson() => _$SteeringCommandToJson(this);

  /// Safely parses a steering command and returns a structured failure on invalid JSON.
  static Result<SteeringCommand, ModelParseFailure> tryFromJson(
    Map<String, dynamic> json, {
    OpenClawLogger? logger,
  }) {
    const modelName = 'SteeringCommand';
    final log = logger ?? OpenClawLogger();
    try {
      final value = SteeringCommand.fromJson(json);
      log.parseSuccess(modelName, context: {'type': value.type.toJson()});
      return Result.success(value);
    } catch (error, stackTrace) {
      log.parseFailure(modelName, error, stackTrace, context: {'type': json['type']});
      return Result.failure(ModelParseFailure(
        modelName: modelName,
        message: 'Unable to parse steering command.',
        source: error,
        stackTrace: stackTrace,
      ));
    }
  }
}

String _steeringCommandTypeToJson(SteeringCommandType value) => value.toJson();
