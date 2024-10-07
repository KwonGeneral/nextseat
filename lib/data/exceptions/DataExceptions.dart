// MARK: - 기초 데이터 예외 정의
abstract class BaseDataException implements Exception {
  final String message;
  BaseDataException(this.message);

  @override
  String toString() {
    return '[데이터 예외] $message';
  }
}

// MARK: - 기본 데이터 예외 정의
class DataException extends BaseDataException {
  DataException(super.message);
}
