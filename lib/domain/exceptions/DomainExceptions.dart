// MARK: - 기초 도메인 예외 정의
abstract class BaseDomainException implements Exception {
  final String message;
  BaseDomainException(this.message);

  @override
  String toString() {
    return '[도메인 예외] $message';
  }
}

// MARK: - 기본 데이터 예외 정의
class DomainException extends BaseDomainException {
  DomainException(super.message);
}
