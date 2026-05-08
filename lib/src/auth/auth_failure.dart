/// Authentication failures that happen after an OpenClaw instance is reachable.
enum AuthFailureKind {
  rejectedCredentials,
  expiredToken,
  missingPermission,
  serverUnavailable,
  unknown,
}

/// Actionable authentication failure copy for login screens.
final class AuthFailure {
  const AuthFailure({
    required this.kind,
    required this.title,
    required this.message,
    required this.recoveryAction,
    this.technicalDetail,
  });

  final AuthFailureKind kind;
  final String title;
  final String message;
  final String recoveryAction;
  final Object? technicalDetail;

  const AuthFailure.rejectedCredentials({Object? technicalDetail})
      : this(
          kind: AuthFailureKind.rejectedCredentials,
          title: 'Credentials rejected',
          message: 'The instance is reachable, but these credentials were rejected.',
          recoveryAction: 'Check your username, password, or API token and try again.',
          technicalDetail: technicalDetail,
        );

  const AuthFailure.expiredToken({Object? technicalDetail})
      : this(
          kind: AuthFailureKind.expiredToken,
          title: 'Token expired',
          message: 'The instance accepted the connection but says this token is expired.',
          recoveryAction: 'Create a new token in OpenClaw and sign in again.',
          technicalDetail: technicalDetail,
        );

  const AuthFailure.missingPermission({Object? technicalDetail})
      : this(
          kind: AuthFailureKind.missingPermission,
          title: 'Access not allowed',
          message: 'Your account does not have permission to use this OpenClaw app.',
          recoveryAction: 'Ask an administrator to grant mobile or API access for your account.',
          technicalDetail: technicalDetail,
        );
}
