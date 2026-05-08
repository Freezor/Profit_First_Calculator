import 'package:json_annotation/json_annotation.dart';

import '../logger.dart';
import '../result.dart';
import 'openclaw_capabilities.dart';

part 'openclaw_instance.g.dart';

/// A single OpenClaw deployment registered with OpenClaw Center.
@JsonSerializable(explicitToJson: true)
final class OpenClawInstance {
  const OpenClawInstance({
    required this.baseUrl,
    required this.instanceName,
    required this.version,
    required this.capabilities,
  });

  /// Root API URL used to communicate with this OpenClaw deployment.
  final Uri baseUrl;

  /// Human-readable deployment name displayed in instance pickers.
  final String instanceName;

  /// Server version string reported by the deployment.
  final String version;

  /// Feature flags describing which OpenClaw API surfaces are available.
  final OpenClawCapabilities capabilities;

  factory OpenClawInstance.fromJson(Map<String, dynamic> json) =>
      _$OpenClawInstanceFromJson(json);

  Map<String, dynamic> toJson() => _$OpenClawInstanceToJson(this);

  /// Safely parses an instance and returns a structured failure on invalid JSON.
  static Result<OpenClawInstance, ModelParseFailure> tryFromJson(
    Map<String, dynamic> json, {
    OpenClawLogger? logger,
  }) {
    const modelName = 'OpenClawInstance';
    final log = logger ?? OpenClawLogger();
    try {
      final value = OpenClawInstance.fromJson(json);
      log.parseSuccess(modelName, context: {'baseUrl': json['baseUrl']});
      return Result.success(value);
    } catch (error, stackTrace) {
      log.parseFailure(modelName, error, stackTrace, context: {'baseUrl': json['baseUrl']});
      return Result.failure(ModelParseFailure(
        modelName: modelName,
        message: 'Unable to parse OpenClaw instance.',
        source: error,
        stackTrace: stackTrace,
      ));
    }
  }
}
