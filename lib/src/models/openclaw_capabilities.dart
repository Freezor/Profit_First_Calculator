import 'package:json_annotation/json_annotation.dart';

import '../logger.dart';
import '../result.dart';

part 'openclaw_capabilities.g.dart';

/// Feature flags advertised by an OpenClaw instance.
@JsonSerializable()
final class OpenClawCapabilities {
  const OpenClawCapabilities({
    required this.runs,
    required this.attention,
    required this.commands,
    required this.approvals,
    required this.events,
  });

  /// Whether the instance supports listing and inspecting agent runs.
  final bool runs;

  /// Whether the instance exposes attention items requiring human action.
  final bool attention;

  /// Whether steering commands can be sent to active runs.
  final bool commands;

  /// Whether approval workflows are supported by this deployment.
  final bool approvals;

  /// Whether run history events are available from this deployment.
  final bool events;

  factory OpenClawCapabilities.fromJson(Map<String, dynamic> json) =>
      _$OpenClawCapabilitiesFromJson(json);

  Map<String, dynamic> toJson() => _$OpenClawCapabilitiesToJson(this);

  /// Safely parses capabilities and returns a structured failure on invalid JSON.
  static Result<OpenClawCapabilities, ModelParseFailure> tryFromJson(
    Map<String, dynamic> json, {
    OpenClawLogger? logger,
  }) {
    const modelName = 'OpenClawCapabilities';
    final log = logger ?? OpenClawLogger();
    try {
      final value = OpenClawCapabilities.fromJson(json);
      log.parseSuccess(modelName);
      return Result.success(value);
    } catch (error, stackTrace) {
      log.parseFailure(modelName, error, stackTrace);
      return Result.failure(ModelParseFailure(
        modelName: modelName,
        message: 'Unable to parse OpenClaw capabilities.',
        source: error,
        stackTrace: stackTrace,
      ));
    }
  }
}
