
// ignore_for_file: constant_identifier_names


import 'package:nextseat/presenter/lang/LangKeys.dart';
import 'package:nextseat/presenter/lang/Messages.dart';

enum DateTypes {
  // 일
  DAY(1),

  // 주간
  WEEK(2),

  // 월
  MONTH(3),

  // 년
  YEAR(4),

  // 없음
  NONE(99);

  static String getTitle(DateTypes type) {
    switch(type) {
      case DateTypes.MONTH:
        return Messages.get(LangKeys.month);
      case DateTypes.DAY:
        return Messages.get(LangKeys.day);
      case DateTypes.WEEK:
        return Messages.get(LangKeys.week);
      case DateTypes.NONE:
        return Messages.get(LangKeys.none);
      case DateTypes.YEAR:
        return Messages.get(LangKeys.year);
    }
    return "";
  }

  static DateTypes getDateType(int? type) {
    var data = DateTypes.NONE;
    if(type == null) {
      return data;
    }
    for (var value in DateTypes.values) {
      if (value.type == type) {
        data = value;
        break;
      }
    }
    return data;
  }

  final int type;
  const DateTypes(this.type);
}