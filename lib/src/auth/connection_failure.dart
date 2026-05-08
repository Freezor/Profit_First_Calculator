/// Connection and discovery failures that happen before credential validation.
enum ConnectionFailureKind {
  dns,
  timeout,
  offline,
  tls,
  notOpenClaw,
  unsupportedVersion,
  unauthorizedDiscovery,
  unknown,
}

/// Actionable connection failure copy for Flutter UI surfaces.
final class ConnectionFailure {
  const ConnectionFailure({
    required this.kind,
    required this.title,
    required this.message,
    required this.recoveryAction,
    this.technicalDetail,
  });

  final ConnectionFailureKind kind;
  final String title;
  final String message;
  final String recoveryAction;
  final Object? technicalDetail;

  const ConnectionFailure.dns({Object? technicalDetail})
      : this(
          kind: ConnectionFailureKind.dns,
          title: 'Server not found',
          message: "We couldn't find a server at this address.",
          recoveryAction: 'Check the spelling, VPN, and network connection.',
          technicalDetail: technicalDetail,
        );

  const ConnectionFailure.timeout({Object? technicalDetail})
      : this(
          kind: ConnectionFailureKind.timeout,
          title: 'Connection timed out',
          message: 'The address did not respond in time.',
          recoveryAction: 'Try again, or confirm that your VPN or local network is connected.',
          technicalDetail: technicalDetail,
        );

  const ConnectionFailure.tls({Object? technicalDetail})
      : this(
          kind: ConnectionFailureKind.tls,
          title: 'Certificate problem',
          message: "This server's secure certificate could not be verified.",
          recoveryAction: 'Contact your administrator or use the officially configured OpenClaw address.',
          technicalDetail: technicalDetail,
        );

  const ConnectionFailure.notOpenClaw({Object? technicalDetail})
      : this(
          kind: ConnectionFailureKind.notOpenClaw,
          title: 'OpenClaw not found',
          message: 'This address is reachable, but it does not look like OpenClaw.',
          recoveryAction: 'Confirm that you copied the base OpenClaw instance URL.',
          technicalDetail: technicalDetail,
        );

  const ConnectionFailure.unsupportedVersion({Object? technicalDetail})
      : this(
          kind: ConnectionFailureKind.unsupportedVersion,
          title: 'Unsupported OpenClaw version',
          message: 'This OpenClaw version is not supported by this app.',
          recoveryAction: 'Update the app or ask your administrator to update the OpenClaw instance.',
          technicalDetail: technicalDetail,
        );
}
