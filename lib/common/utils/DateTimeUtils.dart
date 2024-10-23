

class DateTimeUtils {
  // MARK: - 채팅에서 표시할 날짜 시간
  static String chatViewDateTime(DateTime dateTime) {
    int hour = dateTime.hour;
    String hourStr = hour < 10 ? '0$hour' : '$hour';

    int min = dateTime.minute;
    String minStr = min < 10 ? '0$min' : '$min';

    return '$hourStr:$minStr';
  }

  // MARK: - 채팅에서 시스템 날짜 표시 (yyyy년 MM월 dd일)
  static String chatSystemDate(DateTime dateTime) {
    int year = dateTime.year;
    int month = dateTime.month;
    int day = dateTime.day;

    return '$year년 $month월 $day일';
  }

  // MARK: - yyyy-MM-dd HH:mm:ss로 변환
  static String dateTimeToString(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
  }

  // MARK: - yyyy-MM-dd HH:mm:ss를 DateTime으로 변환
  static DateTime stringToDateTime(String dateTime) {
    List<String> date = dateTime.split(' ')[0].split('-');
    List<String> time = dateTime.split(' ')[1].split(':');

    return DateTime(
      int.parse(date[0]),
      int.parse(date[1]),
      int.parse(date[2]),
      int.parse(time[0]),
      int.parse(time[1]),
      int.parse(time[2]),
    );
  }
}