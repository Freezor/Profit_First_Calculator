import 'package:json_annotation/json_annotation.dart';

import '../enums.dart';
import '../logger.dart';
import '../result.dart';

part 'command_result.g.dart';

/// Response returned by OpenClaw after a steering command is submitted.
@JsonSerializable()
final class CommandResult {
  const CommandResult({
    required this.state,
    required this.summary,
  });

  /// Acceptance or failure state for the submitted command.
  @JsonKey(fromJson: CommandResultState.fromJson, toJson: _commandResultStateToJson)
  final CommandResultState state;

  /// Human-readable response summary suitable for toast messages or logs.
  final String summary;

  factory CommandResult.fromJson(Map<String, dynamic> json) => _$CommandResultFromJson(json);

  Map<String, dynamic> toJson() => _$CommandResultToJson(this);

  /// Safely parses a command result and returns a structured failure on invalid JSON.
  static Result<CommandResult, ModelParseFailure> tryFromJson(
    Map<String, dynamic> json, {
    OpenClawLogger? logger,
  }) {
    const modelName = 'CommandResult';
    final log = logger ?? OpenClawLogger();
    try {
      final value = CommandResult.fromJson(json);
      log.parseSuccess(modelName, context: {'state': value.state.toJson()});
      return Result.success(value);
    } catch (error, stackTrace) {
      log.parseFailure(modelName, error, stackTrace, context: {'state': json['state']});
      return Result.failure(ModelParseFailure(
        modelName: modelName,
        message: 'Unable to parse command result.',
        source: error,
        stackTrace: stackTrace,
      ));
    }
  }
}

String _commandResultStateToJson(CommandResultState value) => value.toJson();
