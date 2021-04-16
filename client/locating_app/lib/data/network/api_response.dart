class ApiResponse<T> {
  int resultCode;
  String message;
  T data;
  dynamic error;
  bool isErrorLocal = false;
  String accessToken;
  String serverToken;

  ApiResponse.success({
    this.resultCode,
    this.message,
    this.data,
    this.error,
    this.accessToken,
    this.serverToken,
  });

  ApiResponse.error(this.message);

  ApiResponse.errorLocal(this.message) {
    this.isErrorLocal = true;
  }

  bool get isSuccess => this.resultCode == 1;

  @override
  String toString() {
    return "Status : \n Message : $message \n Data : $data";
  }
}
