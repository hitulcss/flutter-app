class ApiState<T> {
  final T? data;
  final bool isLoading;
  final String? error;

  const ApiState({
    this.data,
    this.isLoading = false,
    this.error,
  });

  ApiState<T> copyWith({
    T? data,
    bool? isLoading,
    String? error,
  }) {
    return ApiState<T>(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}