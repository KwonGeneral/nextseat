
// MARK: - 스킴
enum Scheme {
  // MARK: - 스플래시
  SPLASH("/splash"),

  // MARK: - 홈
  HOME("/home"),

  // MARK: - 미들웨어
  MIDDLEWARE('/middleware'),

  // MARK: - 초기 체크
  INIT_CHECK('/init_check');

  final String path;

  const Scheme(this.path);
}