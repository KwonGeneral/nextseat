
// MARK: - 채팅 타입
// Normal: 일반 채팅
// System: 시스템 메세지
// Date: 날짜 표시
enum ChatTypes {
  NORMAL('normal'),
  SYSTEM('system'),
  DATE('date');
  
  final String value;
  
  const ChatTypes(this.value);
  
  // MARK: - value로 ChatTypes 반환
  static ChatTypes fromValue(String? value) {
    var data = ChatTypes.NORMAL;
    if(value == null) {
      return data;
    }
    for (var type in ChatTypes.values) {
      if (type.value == value) {
        data = type;
        break;
      }
    }
    return data;
  }
}