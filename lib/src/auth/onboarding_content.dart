/// Product copy and screen structure for the first-run OpenClaw setup flow.
///
/// These values are intentionally framework-agnostic so Flutter widgets can
/// render them with Material, Cupertino, or a custom design system while keeping
/// the onboarding language consistent across platforms.
final class OpenClawOnboardingStep {
  const OpenClawOnboardingStep({
    required this.id,
    required this.title,
    required this.body,
    required this.bullets,
    required this.primaryActionLabel,
    this.secondaryActionLabel,
    required this.problemSolved,
  });

  /// Stable analytics/deep-link identifier for the screen or panel.
  final String id;

  /// Main heading shown to the user.
  final String title;

  /// Short explanatory copy shown under the heading.
  final String body;

  /// Checklist or instructional bullets shown on the screen.
  final List<String> bullets;

  /// Label for the primary button.
  final String primaryActionLabel;

  /// Optional label for a secondary help action.
  final String? secondaryActionLabel;

  /// Internal product rationale explaining which user confusion this solves.
  final String problemSolved;
}

/// A setup prerequisite users may need to verify in their OpenClaw installation
/// or gateway before the mobile app can connect.
final class OpenClawInstallationSetupItem {
  const OpenClawInstallationSetupItem({
    required this.id,
    required this.title,
    required this.description,
    required this.userPrompt,
  });

  /// Stable analytics/help identifier for this prerequisite.
  final String id;

  /// Short label shown in a checklist or help sheet.
  final String title;

  /// Explanation of what must be configured.
  final String description;

  /// Plain-language prompt users can send to their administrator.
  final String userPrompt;
}

/// Concise copy for a setup flow that can be completed in under two minutes.
abstract final class OpenClawOnboardingContent {
  static const setupPrimer = OpenClawOnboardingStep(
    id: 'setup_primer',
    title: 'Connect to your OpenClaw instance',
    body: 'OpenClaw runs on a server you or your team host. This app needs that server address before it can sign you in.',
    bullets: <String>[
      'Have your instance URL ready, such as https://openclaw.example.com or https://192.168.1.20:8443.',
      'Have the username, password, or API token issued by that instance.',
      'Join your VPN or local network first if the instance is private.',
    ],
    primaryActionLabel: 'I have my instance URL',
    secondaryActionLabel: 'How do I find it?',
    problemSolved: 'Prevents users from assuming OpenClaw has one shared SaaS login endpoint.',
  );

  static const findInstance = OpenClawOnboardingStep(
    id: 'find_instance',
    title: 'Find your instance URL',
    body: 'Use the same address you open in your browser when you access OpenClaw.',
    bullets: <String>[
      'Open OpenClaw in a browser.',
      'Copy the address from the browser bar, including https:// and any port number.',
      'Paste the address into the app and tap Check connection.',
    ],
    primaryActionLabel: 'Paste instance URL',
    secondaryActionLabel: 'Enter manually',
    problemSolved: 'Gives users a concrete place to find the URL instead of asking them to infer what an instance address means.',
  );

  static const connectionCheck = OpenClawOnboardingStep(
    id: 'connection_check',
    title: 'Check the connection',
    body: 'The app will verify that the address is reachable and looks like OpenClaw before asking for credentials.',
    bullets: <String>[
      'We check the server address first.',
      'If OpenClaw is found, you will see the instance name and version.',
      'If the server is private, connection checks may require VPN or local network access.',
    ],
    primaryActionLabel: 'Check connection',
    secondaryActionLabel: 'Continue anyway',
    problemSolved: 'Separates network, TLS, and wrong-server issues from credential errors.',
  );

  static const authenticate = OpenClawOnboardingStep(
    id: 'authenticate',
    title: 'Sign in to OpenClaw',
    body: 'Your credentials are checked by your OpenClaw instance, not by a central OpenClaw service.',
    bullets: <String>[
      'Confirm the instance name before entering credentials.',
      'Use the username, password, or token configured on that instance.',
      'Use Change instance if you copied the wrong address.',
    ],
    primaryActionLabel: 'Sign in',
    secondaryActionLabel: 'Change instance',
    problemSolved: 'Makes it clear which server receives the credentials and how to recover from a wrong instance.',
  );

  static const adminSetupHelp = OpenClawOnboardingStep(
    id: 'admin_setup_help',
    title: 'Need an OpenClaw address?',
    body: 'If you cannot open OpenClaw in a browser yet, your installation or gateway may need a few mobile-friendly settings first.',
    bullets: <String>[
      'Ask for the public, VPN, or local URL that mobile devices should use.',
      'Confirm the gateway uses a trusted HTTPS certificate.',
      'Confirm API, discovery, and sign-in routes are reachable from your network.',
      'Confirm your account or token has permission to use the mobile/API client.',
    ],
    primaryActionLabel: 'Send setup checklist',
    secondaryActionLabel: 'Back to URL entry',
    problemSolved: 'Gives blocked users a concrete administrator checklist instead of leaving them stuck on the URL field.',
  );

  /// Setup details users may need to confirm in OpenClaw or a reverse proxy,
  /// API gateway, VPN, or zero-trust access layer before mobile login works.
  static const installationSetupChecklist = <OpenClawInstallationSetupItem>[
    OpenClawInstallationSetupItem(
      id: 'reachable_base_url',
      title: 'Reachable base URL',
      description: 'OpenClaw should have a stable base URL that the phone can reach over the internet, VPN, or local network.',
      userPrompt: 'What OpenClaw URL should I use from my phone, and do I need VPN or local Wi-Fi first?',
    ),
    OpenClawInstallationSetupItem(
      id: 'trusted_https',
      title: 'Trusted HTTPS certificate',
      description: 'The gateway should serve HTTPS with a certificate trusted by the mobile device; self-signed certificates need an installed organization CA.',
      userPrompt: 'Is the OpenClaw gateway using a certificate my phone trusts?',
    ),
    OpenClawInstallationSetupItem(
      id: 'discovery_and_api_routes',
      title: 'Discovery and API routes',
      description: 'The gateway should pass the OpenClaw discovery, health or capabilities, authentication, and API routes without rewriting them incorrectly.',
      userPrompt: 'Are OpenClaw discovery, health, auth, and API routes exposed through the gateway?',
    ),
    OpenClawInstallationSetupItem(
      id: 'forwarded_headers',
      title: 'Forwarded URL headers',
      description: 'Reverse proxies should preserve the host and original scheme with headers such as Host and X-Forwarded-Proto so redirects and generated links use the external URL.',
      userPrompt: 'Does the gateway preserve Host and X-Forwarded-Proto for OpenClaw?',
    ),
    OpenClawInstallationSetupItem(
      id: 'authentication_access',
      title: 'Authentication access',
      description: 'The OpenClaw installation should enable the sign-in method this app uses, such as password, API token, or SSO/OIDC, and grant the account API/mobile permissions.',
      userPrompt: 'Is my account or token allowed to sign in from the mobile/API client?',
    ),
    OpenClawInstallationSetupItem(
      id: 'streaming_timeouts',
      title: 'Streaming and timeout settings',
      description: 'If the app uses live run events, the gateway should allow WebSocket or server-sent event connections and avoid very short idle timeouts.',
      userPrompt: 'Does the gateway allow OpenClaw live events, WebSockets or SSE, and reasonable idle timeouts?',
    ),
  ];

  /// Recommended first-run sequence for Flutter onboarding screens.
  static const firstRunSteps = <OpenClawOnboardingStep>[
    setupPrimer,
    findInstance,
    connectionCheck,
    authenticate,
  ];
}
