# OpenClaw domain models

The OpenClaw model layer is pure Dart and can be reused by Flutter widgets,
repositories, command-line tooling, or tests. Model constructors and generated
`fromJson` factories remain intentionally direct: they throw when payloads are
structurally invalid, matching the standard `json_serializable` contract.

## Result/Either parsing pattern

Each model also exposes a `tryFromJson` factory that wraps parsing in a
`Result<T, ModelParseFailure>`:

- `Success<T, ModelParseFailure>` contains the parsed model.
- `Failure<T, ModelParseFailure>` contains a structured error with the model
  name, message, original exception, and stack trace.

This lets repository and API layers avoid uncaught parsing exceptions while
preserving diagnostic detail for observability.

```dart
final result = AgentRun.tryFromJson(payload);

final label = result.fold(
  (run) => run.label,
  (failure) => 'Unable to load ${failure.modelName}',
);
```

## Logging

`tryFromJson` accepts an optional `OpenClawLogger`. The logger delegates to the
pure Dart `logging` package, so the domain layer has no dependency on Flutter
widgets or platform UI code. Applications may configure `Logger.root` or pass a
wrapped logger from their existing logging pipeline.

## Unknown enum handling

All OpenClaw enums include an `unknown` value and decode through enum-specific
`fromJson` methods. If the server ships a newer enum value, the client maps it
to `unknown` instead of throwing. Serializing `unknown` emits the string
`"unknown"`, making telemetry and debug output explicit.
