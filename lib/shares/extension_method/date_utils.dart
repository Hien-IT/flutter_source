// ignore_for_file: non_constant_identifier_names, prefer_final_locals

import 'dart:math';

class DateUtils {
  String getNameDayOfWeek(DateTime date) {
    if (date.weekday == DateTime.monday) {
      return 'Thứ 2';
    }
    if (date.weekday == DateTime.tuesday) {
      return 'Thứ 3';
    }
    if (date.weekday == DateTime.wednesday) {
      return 'Thứ 4';
    }
    if (date.weekday == DateTime.thursday) {
      return 'Thứ 5';
    }
    if (date.weekday == DateTime.friday) {
      return 'Thứ 6';
    }
    if (date.weekday == DateTime.saturday) {
      return 'Thứ 7';
    }
    return 'Chủ Nhật';
  }

  DateTime increaseDay(DateTime date) {
    var day = date.day + 1;
    var month = date.month;
    var year = date.year;
    final maxDayThisMonth = lastDayOfMonth(date);
    if (maxDayThisMonth.day == day) {
      day = 1;
      month++;
      if (date.month == 12) {
        month = 1;
        year++;
      }
    }

    return DateTime(year, month, day, date.hour, date.minute, date.second);
  }

  DateTime decreaseDay(DateTime date) {
    var day = date.day - 1;
    var month = date.month;
    var year = date.year;
    if (date.day == 1) {
      final maxDayPreviousMonth = lastDayOfPreviousMonth(date);
      day = maxDayPreviousMonth.day;
      month = maxDayPreviousMonth.month;
      year = maxDayPreviousMonth.year;
    }

    return DateTime(year, month, day, date.hour, date.minute, date.second);
  }

  DateTime lastDayOfMonth(DateTime date) {
    if (date.month < 12) {
      return DateTime(date.year, date.month + 1, 0);
    }
    return DateTime(date.year + 1, 1, 0);
  }

  DateTime lastDayOfPreviousMonth(DateTime date) {
    return DateTime(date.year, date.month, 0);
  }

  int jdFromDate(int dd, int mm, int yy) {
    final a = toInt((14 - mm) / 12);
    final y = yy + 4800 - a;
    final m = mm + 12 * a - 3;
    final jd = dd +
        toInt((153 * m + 2) / 5) +
        365 * y +
        toInt(y / 4) -
        toInt(y / 100) +
        toInt(y / 400) -
        32045;
    if (jd < 2299161) {
      return jd;
    } else {
      final b = toInt((jd - 1867216.25) / 36524.25);
      return jd + 1 + b - toInt(b / 4);
    }
  }

  DateTime jdToDate(int jd) {
    // ignore: avoid_multiple_declarations_per_line
    int a, b, c, d, e, m;
    if (jd > 2299160) {
      a = jd + 32044;
      b = toInt((4 * a + 3) / 146097);
      c = a - toInt((b * 146097) / 4);
    } else {
      b = 0;
      c = jd + 32082;
    }
    d = toInt((4 * c + 3) / 1461);
    e = c - toInt((1461 * d) / 4);
    m = toInt((5 * e + 2) / 153);
    final day = e - toInt((153 * m + 2) / 5) + 1;
    final month = m + 3 - 12 * toInt(m / 10);
    final year = b * 100 + d - 4800 + toInt(m / 10);
    return DateTime(year, month, day);
  }

  int getNewMoonDay(int k) {
    final T = k / 1236.85; // Time in Julian centuries from 1900 January 0.5
    final T2 = T * T;
    final T3 = T2 * T;
    const dr = pi / 180;
    var Jd1 =
        2415020.75933 + 29.53058868 * k + 0.0001178 * T2 - 0.000000155 * T3;
    Jd1 = Jd1 +
        0.00033 *
            sin((166.56 + 132.87 * T - 0.009173 * T2) * dr); // Mean new moon
    final M = 359.2242 +
        29.10535608 * k -
        0.0000333 * T2 -
        0.00000347 * T3; // Sun's mean anomaly
    final Mpr = 306.0253 +
        385.81691806 * k +
        0.0107306 * T2 +
        0.00001236 * T3; // Moon's mean anomaly
    final F = 21.2964 +
        390.67050646 * k -
        0.0016528 * T2 -
        0.00000239 * T3; // Moon's argument of latitude
    var C1 = (0.1734 - 0.000393 * T) * sin(M * dr) + 0.0021 * sin(2 * dr * M);
    C1 = C1 - 0.4068 * sin(Mpr * dr) + 0.0161 * sin(dr * 2 * Mpr);
    C1 = C1 - 0.0004 * sin(dr * 3 * Mpr);
    C1 = C1 + 0.0104 * sin(dr * 2 * F) - 0.0051 * sin(dr * (M + Mpr));
    C1 = C1 - 0.0074 * sin(dr * (M - Mpr)) + 0.0004 * sin(dr * (2 * F + M));
    C1 = C1 - 0.0004 * sin(dr * (2 * F - M)) - 0.0006 * sin(dr * (2 * F + Mpr));
    C1 = C1 +
        0.0010 * sin(dr * (2 * F - Mpr)) +
        0.0005 * sin(dr * (2 * Mpr + M));

    var deltat = 0.0;
    if (T < -11) {
      deltat = 0.001 +
          0.000839 * T +
          0.0002261 * T2 -
          0.00000845 * T3 -
          0.000000081 * T * T3;
    } else {
      deltat = -0.000278 + 0.000265 * T + 0.000262 * T2;
    }

    final JdNew = Jd1 + C1 - deltat;
    return toInt(JdNew + 0.5 + 7 / 24);
  }

  int getSunLongitude(int jdn) {
    var T = (jdn - 2451545.5 - 7 / 24) /
        36525; // Time in Julian centuries from 2000-01-01 12:00:00 GMT
    var T2 = T * T;
    var dr = pi / 180; // degree to radian
    var M = 357.52910 +
        35999.05030 * T -
        0.0001559 * T2 -
        0.00000048 * T * T2; // mean anomaly, degree
    var L0 =
        280.46645 + 36000.76983 * T + 0.0003032 * T2; // mean longitude, degree
    var DL = (1.914600 - 0.004817 * T - 0.000014 * T2) * sin(dr * M);
    DL = DL +
        (0.019993 - 0.000101 * T) * sin(dr * 2 * M) +
        0.000290 * sin(dr * 3 * M);
    var L = L0 + DL; // true longitude, degree
    L = L * dr;
    L = L - pi * 2 * (toInt(L / (pi * 2))); // Normalize to (0, 2*PI)
    return toInt(L / pi * 6);
  }

  int getLunarMonth11(int yy) {
    var off = jdFromDate(31, 12, yy) - 2415021;
    var k = toInt(off / 29.530588853);
    var nm = getNewMoonDay(k);
    var sunLong = getSunLongitude(nm); // sun longitude at local midnight
    if (sunLong >= 9) {
      nm = getNewMoonDay(k - 1);
    }
    return nm;
  }

  int toInt(double d) {
    return d.toInt();
  }

  int getLeapMonthOffset(int a11) {
    var k = toInt((a11 - 2415021.076998695) / 29.530588853 + 0.5);
    var last = 0;
    var i = 1; // We start with the month following lunar month 11
    var arc = getSunLongitude(getNewMoonDay(k + i));
    do {
      last = arc;
      i++;
      arc = getSunLongitude(getNewMoonDay(k + i));
    } while (arc != last && i < 14);
    return i - 1;
  }
}
