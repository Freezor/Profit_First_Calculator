import '../models/openclaw_instance.dart';
import 'auth_failure.dart';
import 'auth_state.dart';
import 'connection_failure.dart';

/// Pure transition helper for Flutter auth/onboarding controllers.
///
/// State-management libraries such as Riverpod, Bloc, or ChangeNotifier can use
/// these transitions while keeping networking, persistence, and secure storage
/// outside the UI layer.
abstract final class OpenClawAuthFlowController {
  /// Chooses the first screen at app startup.
  static AuthState initialState({
    OpenClawSession? existingSession,
    SavedOpenClawInstance? savedInstance,
    required bool hasCompletedOnboarding,
  }) {
    if (existingSession != null) {
      return Authenticated(existingSession);
    }
    if (savedInstance != null) {
      return InstanceReady(savedInstance);
    }
    if (!hasCompletedOnboarding) {
      return const FirstRun();
    }
    return const NeedsInstance();
  }

  /// Moves from the setup primer to instance URL entry.
  static AuthState completePrimer() => const NeedsInstance();

  /// Starts the discovery/health-check step for a candidate instance URL.
  static AuthState beginInstanceCheck(Uri url) => CheckingInstance(url);

  /// Marks a discovered OpenClaw instance as ready for credentials.
  static AuthState instanceDiscovered(
    OpenClawInstance instance, {
    required DateTime checkedAt,
  }) =>
      InstanceReady(SavedOpenClawInstance(
        instance: instance,
        lastSuccessfulConnectionAt: checkedAt,
      ));

  /// Blocks login on a connection failure before credentials are submitted.
  static AuthState connectionBlocked(ConnectionFailure failure) => AuthBlocked(failure);

  /// Starts credential validation against a known reachable instance.
  static AuthState beginSignIn(SavedOpenClawInstance instance) => SigningIn(instance);

  /// Completes sign-in after credentials are accepted by the instance.
  static AuthState signedIn(OpenClawSession session) => Authenticated(session);

  /// Blocks login after credentials are rejected by a reachable instance.
  static AuthState authBlocked(AuthFailure failure) => AuthBlocked(failure);
}
