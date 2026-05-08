# OpenClaw authentication and first-run onboarding UX

This guide defines a practical Flutter onboarding and login flow for apps that
connect to a user's self-hosted OpenClaw instance. The core design principle is
simple: users should understand what an OpenClaw instance URL is, know where to
find it, and be able to verify connectivity before they enter credentials.

## Goals

- Help first-time users complete setup in under two minutes.
- Keep returning users one tap away from their most recent instance.
- Make the self-hosted nature of OpenClaw explicit before login.
- Separate connection problems from authentication problems.
- Preserve enough diagnostic detail for support without exposing secrets.

## First screen: setup primer before login

Show a concise setup primer when the app has no saved, successfully connected
instance. Avoid opening directly on a username/password form because users often
try credentials before they know which OpenClaw server they are authenticating
against.

Recommended first screen content:

1. **Title:** "Connect to your OpenClaw instance"
2. **One-sentence explanation:** "OpenClaw runs on a server you or your team
   host; this app needs that server address before it can sign you in."
3. **What to have ready:**
   - Instance URL, such as `https://openclaw.example.com` or
     `https://192.168.1.20:8443`.
   - Login credentials or API token issued by that instance.
   - VPN or local network access if the instance is private.
4. **Two-minute checklist:**
   - Open OpenClaw in a browser.
   - Copy the address from the browser bar, including `https://` and any port.
   - Paste it into the app.
   - Tap **Check connection**.
   - Sign in after the app confirms it reached OpenClaw.
5. **Primary action:** "I have my instance URL"
6. **Secondary action:** "How do I find it?"

Problem solved: this screen prevents users from treating OpenClaw like a SaaS
service with one global login endpoint. It also names the exact artifact they
need to gather before authentication starts.

## If the user does not have an instance URL yet

Some users are blocked because OpenClaw itself, or the gateway in front of it,
has not been prepared for mobile access. Add a **Need an OpenClaw address?**
help sheet from the URL entry screen. Keep it optional so users who already have
a URL can continue quickly, but give blocked users a concrete checklist they can
send to an administrator.

Recommended user-facing copy:

- **Title:** "Need an OpenClaw address?"
- **Body:** "If you cannot open OpenClaw in a browser yet, your installation or
  gateway may need a few mobile-friendly settings first."
- **Primary action:** "Send setup checklist"
- **Secondary action:** "Back to URL entry"

### OpenClaw installation and gateway setup checklist

These are the items a user may need to confirm with whoever operates the
self-hosted installation:

| Setup area | What needs to be configured | User/admin prompt |
| --- | --- | --- |
| Reachable base URL | OpenClaw needs a stable URL reachable by the phone over the internet, VPN, or local network. | "What OpenClaw URL should I use from my phone, and do I need VPN or local Wi-Fi first?" |
| Trusted HTTPS | The gateway should serve HTTPS with a certificate trusted by the mobile device. If the site uses a private CA, the organization CA must be installed on the device. | "Is the OpenClaw gateway using a certificate my phone trusts?" |
| Discovery and API routes | The gateway should pass OpenClaw discovery, health/capabilities, authentication, and API routes without incorrect path rewrites. | "Are OpenClaw discovery, health, auth, and API routes exposed through the gateway?" |
| Forwarded URL headers | Reverse proxies should preserve the external host and scheme with headers such as `Host` and `X-Forwarded-Proto` so redirects and generated links use the mobile-visible URL. | "Does the gateway preserve Host and X-Forwarded-Proto for OpenClaw?" |
| Authentication access | OpenClaw should enable the sign-in method used by the app, such as password, API token, or SSO/OIDC, and grant the account API/mobile permissions. | "Is my account or token allowed to sign in from the mobile/API client?" |
| Streaming and timeouts | If the app uses live run events, the gateway should allow WebSocket or server-sent event connections and avoid very short idle timeouts. | "Does the gateway allow OpenClaw live events, WebSockets or SSE, and reasonable idle timeouts?" |

Problem solved: users who do not control the OpenClaw deployment can ask for the
right concrete setup work instead of reporting only that "login does not work."

## Guided connection flow

Use a short, progressive flow instead of one dense login form.

### Step 1: Enter instance URL

- Label the field **OpenClaw instance URL** rather than "server" or "host".
- Placeholder: `https://openclaw.your-domain.com`.
- Helper text: "Use the same address you open in your browser. Include
  `https://` and a port if your instance uses one."
- Add a paste affordance and preserve clipboard privacy by only reading after a
  user taps **Paste**.
- Normalize harmless input, such as trimming spaces and adding `https://` only
  after asking or showing a clear suggestion.
- Validate locally before network calls:
  - URL has `http://` or `https://`.
  - URL has a host.
  - URL does not include a login path copied from a browser, such as
    `/login`, unless the API genuinely lives there.

Problem solved: users get specific feedback about the instance address before a
slow or doomed network request.

### Step 2: Check connection

Run a lightweight discovery request, such as `GET /.well-known/openclaw` or an
OpenClaw health/capabilities endpoint if available. Show a visible status row:

- **Checking address...** while DNS/TLS/network checks run.
- **OpenClaw found** with instance name and version when discovery succeeds.
- **Reachable, but not OpenClaw** when the server responds without the expected
  OpenClaw metadata.
- **Cannot reach this address** for DNS, timeout, offline, or private network
  failures.
- **Certificate problem** for TLS errors, with a safe explanation and no blanket
  recommendation to disable certificate validation.

Problem solved: users learn whether the app can reach their self-hosted server
before they spend effort entering credentials.

### Step 3: Authenticate

Only reveal credential fields after the instance check succeeds or after the
user explicitly chooses **Continue anyway**. Include the verified instance name
above the fields so users know which server will receive their credentials.

Recommended fields and copy:

- Header: "Sign in to `<instance name>`"
- Subtext: "Your credentials are checked by your OpenClaw instance, not by a
  central OpenClaw service."
- Username/email field according to server capabilities.
- Password or token field according to server capabilities.
- Remembered instance switcher for users who manage multiple OpenClaw servers.

Problem solved: authentication failures are no longer conflated with connection
or wrong-server failures.

## Login screen improvements

For returning users, load the last successful instance and display a compact
login screen:

- Instance chip at the top: "OpenClaw: `openclaw.example.com`".
- **Change** action next to the chip to reopen the connection flow.
- Connection health indicator that can silently refresh in the background.
- Credential fields focused by default when the remembered instance is healthy.
- **Use another instance** action for multi-instance users.
- **Forgot where your instance is?** help link that opens the same discovery
  guidance used in onboarding.

Problem solved: returning users do not have to repeat onboarding, while users
with a changed or unavailable server still have an obvious repair path.

## Error message model

Use actionable, cause-specific messages. Avoid generic messages such as
"Authentication failed" until the app has already established that the instance
is reachable.

| Scenario | User-facing message | Action |
| --- | --- | --- |
| Missing scheme | "Add `https://` to the start of your OpenClaw address." | Offer **Use https://...** |
| DNS failure | "We couldn't find a server at this address." | Check spelling, VPN, network |
| Timeout | "The address did not respond in time." | Try again, confirm VPN/local network |
| TLS error | "This server's secure certificate could not be verified." | Contact admin, view safe details |
| Non-OpenClaw response | "This address is reachable, but it does not look like OpenClaw." | Confirm copied base URL |
| 401/403 after credentials | "The instance is reachable, but these credentials were rejected." | Retry credentials, reset password/token |
| Unsupported version | "This OpenClaw version is not supported by this app." | Show required and detected versions |

Problem solved: the user can distinguish address, network, certificate,
server-version, and credential issues without reading logs.

## Implemented reusable onboarding primitives

The repository now includes framework-agnostic Dart primitives that Flutter
screens can consume directly:

- `OpenClawOnboardingContent` supplies the short first-run primer, help copy,
  installation/gateway setup checklist, connection-check copy, and sign-in copy.
- `OpenClawInstanceUrl.validate` normalizes instance addresses and returns
  actionable failures before a network request is made.
- `ConnectionFailure` and `AuthFailure` separate discovery/connectivity problems
  from credential problems.
- `AuthState` models first-run, instance-needed, checking, ready, signing-in,
  authenticated, and blocked states.
- `OpenClawAuthFlowController` provides pure startup routing and transition
  helpers that Riverpod, Bloc, or ChangeNotifier controllers can call.

## Flutter implementation structure

Keep onboarding, connection discovery, and credential authentication as separate
states. This prevents UI screens from guessing whether a failed request means
"bad password" or "bad instance URL".

Suggested folders:

```text
lib/features/auth/
  application/
    auth_controller.dart
    auth_state.dart
    onboarding_controller.dart
    onboarding_state.dart
  data/
    auth_repository.dart
    instance_discovery_client.dart
    secure_credential_store.dart
  domain/
    auth_failure.dart
    connection_failure.dart
    openclaw_session.dart
    saved_instance.dart
  presentation/
    onboarding_intro_screen.dart
    instance_url_screen.dart
    connection_check_screen.dart
    login_screen.dart
    instance_switcher_sheet.dart
```

Suggested high-level states:

```dart
sealed class AuthState {
  const AuthState();
}

final class FirstRun extends AuthState {}
final class NeedsInstance extends AuthState {}
final class CheckingInstance extends AuthState {
  const CheckingInstance(this.url);
  final Uri url;
}
final class InstanceReady extends AuthState {
  const InstanceReady(this.instance);
  final SavedInstance instance;
}
final class SigningIn extends AuthState {
  const SigningIn(this.instance);
  final SavedInstance instance;
}
final class Authenticated extends AuthState {
  const Authenticated(this.session);
  final OpenClawSession session;
}
final class AuthBlocked extends AuthState {
  const AuthBlocked(this.failure);
  final Object failure;
}
```

Recommended persistence:

- Store `hasCompletedOpenClawOnboarding` in shared preferences or another
  low-risk local settings store.
- Store instance URL, display name, version, last successful connection time,
  and capability metadata in an app database or preferences.
- Store tokens and passwords only in platform secure storage.
- Never store raw failed passwords, full tokens, or TLS private details in logs.

Recommended startup routing:

1. If a valid session exists, route to the app.
2. Else if a saved instance exists, route to the returning-user login screen.
3. Else if onboarding has not been completed, route to the setup primer.
4. Else route to the instance URL screen.

Problem solved: first-time and returning users get different amounts of guidance
without duplicating authentication logic across screens.

## UX patterns to borrow from similar self-hosted apps

- **Slack workspace entry:** ask for the workspace or URL first, then ask for
  identity after the destination is known.
- **GitLab self-managed sign-in:** make the instance address editable and
  visibly separate from account credentials.
- **Nextcloud mobile setup:** provide examples for private domains, local IPs,
  and ports because self-hosted installations vary widely.
- **Home Assistant companion app:** detect and explain local-network or remote
  access requirements instead of treating every unreachable server as a bad
  login.
- **Bitwarden/Vaultwarden server URL settings:** keep the selected server
  visible near the sign-in controls so credentials are sent to the intended
  host.

Problem solved: these patterns are familiar to users of self-hosted software and
reduce the cognitive jump from "account login" to "choose my own server first."

## Implementation checklist

- [ ] Add first-run primer screen before credential entry.
- [ ] Add instance URL field with examples, paste action, and local validation.
- [ ] Add connection discovery request and status UI.
- [ ] Add a **Need an OpenClaw address?** sheet with installation and gateway
      setup prompts users can send to an administrator.
- [ ] Gate credential fields behind successful discovery or explicit continue.
- [ ] Split connection failures from credential failures in domain models.
- [ ] Persist last successful instance separately from secure credentials.
- [ ] Add a returning-user shortcut with an instance chip and **Change** action.
- [ ] Add telemetry counters for URL validation failure, discovery failure,
      auth rejection, and successful login without logging secrets.
