import '../result.dart';

/// Failure categories surfaced while validating an OpenClaw instance URL before
/// any network request is attempted.
enum InstanceUrlFailureCode {
  empty,
  missingScheme,
  unsupportedScheme,
  missingHost,
  copiedLoginPath,
  malformed,
}

/// Actionable validation failure for an OpenClaw instance URL field.
final class InstanceUrlValidationFailure {
  const InstanceUrlValidationFailure({
    required this.code,
    required this.message,
    required this.recoveryHint,
    this.suggestedValue,
  });

  final InstanceUrlFailureCode code;
  final String message;
  final String recoveryHint;
  final String? suggestedValue;

  @override
  String toString() => 'InstanceUrlValidationFailure(code: $code, message: $message)';
}

/// Validates and normalizes user-entered OpenClaw instance URLs.
abstract final class OpenClawInstanceUrl {
  static const _loginPathSegments = <String>{
    'login',
    'signin',
    'sign-in',
    'auth',
  };

  /// Returns a normalized [Uri] or an actionable validation failure.
  ///
  /// The validator intentionally accepts private-network hosts and explicit
  /// ports because self-hosted OpenClaw deployments often live on LAN/VPN
  /// addresses. `http://` is rejected by default to nudge users toward secure
  /// deployments, but can be enabled for local development builds.
  static Result<Uri, InstanceUrlValidationFailure> validate(
    String input, {
    bool allowHttp = false,
  }) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      return const Result.failure(InstanceUrlValidationFailure(
        code: InstanceUrlFailureCode.empty,
        message: 'Enter your OpenClaw instance URL.',
        recoveryHint: 'Open OpenClaw in a browser and copy the address from the browser bar.',
      ));
    }

    if (!trimmed.contains('://')) {
      return Result.failure(InstanceUrlValidationFailure(
        code: InstanceUrlFailureCode.missingScheme,
        message: 'Add https:// to the start of your OpenClaw address.',
        recoveryHint: 'Use the same secure address you open in your browser.',
        suggestedValue: 'https://$trimmed',
      ));
    }

    final parsed = Uri.tryParse(trimmed);
    if (parsed == null) {
      return const Result.failure(InstanceUrlValidationFailure(
        code: InstanceUrlFailureCode.malformed,
        message: 'This does not look like a valid URL.',
        recoveryHint: 'Check for spaces, missing dots, or an incomplete IPv6 address.',
      ));
    }

    final scheme = parsed.scheme.toLowerCase();
    if (scheme != 'https' && !(allowHttp && scheme == 'http')) {
      return const Result.failure(InstanceUrlValidationFailure(
        code: InstanceUrlFailureCode.unsupportedScheme,
        message: 'Use an https:// OpenClaw address.',
        recoveryHint: 'Ask your administrator for the secure external or VPN address for this instance.',
      ));
    }

    if (parsed.host.isEmpty) {
      return const Result.failure(InstanceUrlValidationFailure(
        code: InstanceUrlFailureCode.missingHost,
        message: 'The OpenClaw address is missing a host name or IP address.',
        recoveryHint: 'Paste the full address, such as https://openclaw.example.com.',
      ));
    }

    final copiedLoginPath = parsed.pathSegments.any(
      (segment) => _loginPathSegments.contains(segment.toLowerCase()),
    );
    if (copiedLoginPath) {
      return Result.failure(InstanceUrlValidationFailure(
        code: InstanceUrlFailureCode.copiedLoginPath,
        message: 'Paste the base OpenClaw address, not the login page.',
        recoveryHint: 'Remove the login path and use the main instance address.',
        suggestedValue: _withoutPathQueryOrFragment(parsed).toString(),
      ));
    }

    return Result.success(_normalize(parsed));
  }

  static Uri _normalize(Uri uri) {
    final path = uri.path == '/' ? '' : uri.path;
    return uri.replace(
      scheme: uri.scheme.toLowerCase(),
      host: uri.host.toLowerCase(),
      path: path,
      fragment: '',
    );
  }

  static Uri _withoutPathQueryOrFragment(Uri uri) => uri.replace(
        path: '',
        query: '',
        fragment: '',
      );
}
