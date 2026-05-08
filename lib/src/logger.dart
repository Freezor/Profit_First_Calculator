import 'package:logging/logging.dart';

/// Lightweight structured logging adapter used by pure Dart models.
///
/// This keeps the domain layer independent of Flutter widgets while allowing
/// callers to bridge parse events into their preferred logging pipeline.
final class OpenClawLogger {
  OpenClawLogger([Logger? logger]) : _logger = logger ?? Logger('OpenClawModels');

  final Logger _logger;

  /// Logs a successful model parse with optional contextual fields.
  void parseSuccess(String modelName, {Map<String, Object?> context = const {}}) {
    _logger.fine({'event': 'model_parse_success', 'model': modelName, ...context});
  }

  /// Logs a failed model parse with optional contextual fields.
  void parseFailure(
    String modelName,
    Object error,
    StackTrace stackTrace, {
    Map<String, Object?> context = const {},
  }) {
    _logger.warning(
      {'event': 'model_parse_failure', 'model': modelName, ...context},
      error,
      stackTrace,
    );
  }
}
