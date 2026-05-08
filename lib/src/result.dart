/// A small Result/Either type used to return either a success value or a
/// structured failure without throwing exceptions through application layers.
sealed class Result<T, E> {
  const Result();

  /// Creates a successful result containing [value].
  const factory Result.success(T value) = Success<T, E>;

  /// Creates a failed result containing [error].
  const factory Result.failure(E error) = Failure<T, E>;

  /// Whether this result is successful.
  bool get isSuccess => this is Success<T, E>;

  /// Whether this result is failed.
  bool get isFailure => this is Failure<T, E>;

  /// Transforms the success value while preserving failures.
  Result<R, E> map<R>(R Function(T value) transform) {
    final self = this;
    return switch (self) {
      Success<T, E>(:final value) => Result.success(transform(value)),
      Failure<T, E>(:final error) => Result.failure(error),
    };
  }

  /// Folds both branches into a single value.
  R fold<R>(R Function(T value) onSuccess, R Function(E error) onFailure) {
    final self = this;
    return switch (self) {
      Success<T, E>(:final value) => onSuccess(value),
      Failure<T, E>(:final error) => onFailure(error),
    };
  }
}

/// Successful Result branch.
final class Success<T, E> extends Result<T, E> {
  const Success(this.value);

  /// Parsed or computed value.
  final T value;
}

/// Failed Result branch.
final class Failure<T, E> extends Result<T, E> {
  const Failure(this.error);

  /// Structured failure payload.
  final E error;
}

/// Structured parse failure returned by model `tryFromJson` factories.
final class ModelParseFailure {
  const ModelParseFailure({
    required this.modelName,
    required this.message,
    this.source,
    this.stackTrace,
  });

  /// Name of the model that failed to parse.
  final String modelName;

  /// Human-readable parse error message.
  final String message;

  /// Original exception or invalid value that caused the parse failure.
  final Object? source;

  /// Stack trace captured at the failure boundary.
  final StackTrace? stackTrace;

  @override
  String toString() => 'ModelParseFailure(modelName: $modelName, message: $message)';
}
