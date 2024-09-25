// MARK: - 기초 도메인 예외 정의
abstract class BaseDomainException implements Exception {
  final String message;
  BaseDomainException(this.message);

  @override
  String toString() {
    return message;
  }
}