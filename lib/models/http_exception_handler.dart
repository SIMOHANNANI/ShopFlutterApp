class HttpExceptionHandler implements Exception{
  final String error;
  HttpExceptionHandler(this.error);
  @override
  String toString(){
    return error;
  }
}