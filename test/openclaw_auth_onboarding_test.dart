import 'package:profit_first_calculator/openclaw.dart';
import 'package:test/test.dart';

void main() {
  group('OpenClawOnboardingContent', () {
    test('starts by explaining self-hosted instance setup', () {
      expect(OpenClawOnboardingContent.firstRunSteps.first.id, 'setup_primer');
      expect(
        OpenClawOnboardingContent.setupPrimer.body,
        contains('server you or your team host'),
      );
      expect(
        OpenClawOnboardingContent.setupPrimer.bullets,
        contains(contains('instance URL')),
      );
    });

    test('includes installation and gateway setup help for blocked users', () {
      expect(OpenClawOnboardingContent.adminSetupHelp.id, 'admin_setup_help');
      expect(
        OpenClawOnboardingContent.adminSetupHelp.bullets,
        contains(contains('trusted HTTPS certificate')),
      );
      expect(
        OpenClawOnboardingContent.installationSetupChecklist.map((item) => item.id),
        containsAll(<String>[
          'reachable_base_url',
          'trusted_https',
          'discovery_and_api_routes',
          'forwarded_headers',
          'authentication_access',
          'streaming_timeouts',
        ]),
      );
      expect(
        OpenClawOnboardingContent.installationSetupChecklist
            .firstWhere((item) => item.id == 'forwarded_headers')
            .userPrompt,
        contains('X-Forwarded-Proto'),
      );
    });
  });

  group('OpenClawInstanceUrl', () {
    test('suggests https when scheme is missing', () {
      final result = OpenClawInstanceUrl.validate('openclaw.example.com');

      expect(result.isFailure, isTrue);
      expect(
        result.fold((_) => null, (failure) => failure.code),
        InstanceUrlFailureCode.missingScheme,
      );
      expect(
        result.fold((_) => null, (failure) => failure.suggestedValue),
        'https://openclaw.example.com',
      );
    });

    test('normalizes valid self-hosted URLs with ports', () {
      final result = OpenClawInstanceUrl.validate(' HTTPS://OpenClaw.Example.Com:8443/ ');

      expect(result.isSuccess, isTrue);
      expect(
        result.fold((uri) => uri.toString(), (_) => null),
        'https://openclaw.example.com:8443',
      );
    });

    test('warns when users paste a login page instead of the base URL', () {
      final result = OpenClawInstanceUrl.validate('https://openclaw.example.com/login');

      expect(result.isFailure, isTrue);
      expect(
        result.fold((_) => null, (failure) => failure.code),
        InstanceUrlFailureCode.copiedLoginPath,
      );
      expect(
        result.fold((_) => null, (failure) => failure.suggestedValue),
        'https://openclaw.example.com',
      );
    });

    test('rejects http by default but allows it for development builds', () {
      final rejected = OpenClawInstanceUrl.validate('http://192.168.1.20:8080');
      final allowed = OpenClawInstanceUrl.validate(
        'http://192.168.1.20:8080',
        allowHttp: true,
      );

      expect(rejected.isFailure, isTrue);
      expect(
        rejected.fold((_) => null, (failure) => failure.code),
        InstanceUrlFailureCode.unsupportedScheme,
      );
      expect(allowed.isSuccess, isTrue);
    });
  });

  group('OpenClawAuthFlowController', () {
    test('routes first-time users to the setup primer', () {
      final state = OpenClawAuthFlowController.initialState(
        hasCompletedOnboarding: false,
      );

      expect(state, isA<FirstRun>());
    });

    test('routes returning users with a saved instance directly to login', () {
      final instance = OpenClawInstance(
        baseUrl: Uri.parse('https://openclaw.example.com'),
        instanceName: 'Team OpenClaw',
        version: '1.0.0',
        capabilities: const OpenClawCapabilities(
          runs: true,
          attention: true,
          commands: true,
          approvals: false,
          events: true,
        ),
      );
      final saved = SavedOpenClawInstance(
        instance: instance,
        lastSuccessfulConnectionAt: DateTime.utc(2026, 5, 8),
      );

      final state = OpenClawAuthFlowController.initialState(
        savedInstance: saved,
        hasCompletedOnboarding: true,
      );

      expect(state, isA<InstanceReady>());
      expect((state as InstanceReady).instance.instance.instanceName, 'Team OpenClaw');
    });
  });

  group('AuthBlocked', () {
    test('distinguishes connection failures from credential failures', () {
      const connection = AuthBlocked(ConnectionFailure.notOpenClaw());
      const auth = AuthBlocked(AuthFailure.rejectedCredentials());

      expect(connection.isConnectionFailure, isTrue);
      expect(connection.isAuthFailure, isFalse);
      expect(auth.isConnectionFailure, isFalse);
      expect(auth.isAuthFailure, isTrue);
    });
  });
}
