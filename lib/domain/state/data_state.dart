class DataState<T> {
  T? data;
  String? error;
  bool loading = false;

  DataState.success(this.data);

  DataState.error(this.error, this.data);

  DataState.loading(this.data, this.loading);
}
