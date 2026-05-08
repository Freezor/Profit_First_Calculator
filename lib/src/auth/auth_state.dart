import '../models/openclaw_instance.dart';
import 'auth_failure.dart';
import 'connection_failure.dart';

/// Locally remembered OpenClaw instance metadata for returning users.
final class SavedOpenClawInstance {
  const SavedOpenClawInstance({
    required this.instance,
    required this.lastSuccessfulConnectionAt,
  });

  final OpenClawInstance instance;
  final DateTime lastSuccessfulConnectionAt;
}

/// Authenticated session metadata safe to keep in memory.
final class OpenClawSession {
  const OpenClawSession({
    required this.instance,
    required this.userLabel,
    required this.authenticatedAt,
  });

  final OpenClawInstance instance;
  final String userLabel;
  final DateTime authenticatedAt;
}

/// UI state model that separates onboarding, instance discovery, and login.
sealed class AuthState {
  const AuthState();
}

/// First app launch with no completed OpenClaw setup primer.
final class FirstRun extends AuthState {
  const FirstRun();
}

/// The user needs to provide an OpenClaw instance URL.
final class NeedsInstance extends AuthState {
  const NeedsInstance();
}

/// The app is checking whether a URL reaches OpenClaw.
final class CheckingInstance extends AuthState {
  const CheckingInstance(this.url);

  final Uri url;
}

/// A reachable OpenClaw instance is ready for credentials.
final class InstanceReady extends AuthState {
  const InstanceReady(this.instance);

  final SavedOpenClawInstance instance;
}

/// Credentials are being checked by a reachable instance.
final class SigningIn extends AuthState {
  const SigningIn(this.instance);

  final SavedOpenClawInstance instance;
}

/// The user is signed in.
final class Authenticated extends AuthState {
  const Authenticated(this.session);

  final OpenClawSession session;
}

/// Login is blocked by a connection or credential failure.
final class AuthBlocked extends AuthState {
  const AuthBlocked(this.failure);

  final Object failure;

  bool get isConnectionFailure => failure is ConnectionFailure;

  bool get isAuthFailure => failure is AuthFailure;
}
