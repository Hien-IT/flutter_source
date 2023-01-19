// ignore: lines_longer_than_80_chars
// ignore_for_file: non_constant_identifier_names, constant_identifier_names, prefer_final_locals, avoid_multiple_declarations_per_line

library lunar_calendar;

import 'dart:math';

enum Timezone {
  Chinese,
  Japanese,
  Korean,
  Vietnamese,
}

/*
Algorithms for computing lunar calendar by timezone
 */
class CalendarConverter {
  //toInit(x) để lấy số nguyên lớn nhất không vượt quá x
  static int toInit(double value) {
    return value.floor();
  }

  //Chuyển đổi ngày tháng năm -> số ngày Julius
  static int jdFromDate(int dd, int mm, int yy) {
    var a = 0;
    var y = 0;
    var m = 0;
    var jd = 0;
    a = toInit((14 - mm) / 12);
    y = yy + 4800 - a;
    m = mm + 12 * a - 3;
    jd = dd +
        toInit((153 * m + 2) / 5) +
        365 * y +
        toInit(y / 4) -
        toInit(y / 100) +
        toInit(y / 400) -
        32045;
    if (jd < 2299161) {
      jd = dd + toInit((153 * m + 2) / 5) + 365 * y + toInit(y / 4) - 32083;
    }
    return jd;
  }

  //Chuyển đổi số ngày Julius -> ngày tháng năm
  static List<int> jdToDate(int jd) {
    const result = <int>[];
    var a = 0;
    var b = 0;
    var c = 0;
    var d = 0;
    var e = 0;
    var m = 0;
    var day = 0;
    var month = 0;
    var year = 0;

    if (jd > 2299160) {
      // After 5/10/1582, Gregorian calendar
      a = jd + 32044;
      b = toInit((4 * a + 3) / 146097);
      c = a - toInit((b * 146097) / 4);
    } else {
      b = 0;
      c = jd + 32082;
    }
    d = toInit((4 * c + 3) / 1461);
    e = c - toInit((1461 * d) / 4);
    m = toInit((5 * e + 2) / 153);
    day = e - toInit((153 * m + 2) / 5) + 1;
    month = m + 3 - 12 * toInit(m / 10);
    year = b * 100 + d - 4800 + toInit(m / 10);

    result[0] = day;
    result[1] = month;
    result[2] = year;

    return result;
  }

  //Tính ngày Sóc thứ k kể từ điểm Sóc ngày 1/1/1900.
  //Kết quả trả về là số ngày Julius của ngày Sóc cần tìm
  static int getNewMoonDay(int k, int timeZone) {
    var T = 0.0;
    var T2 = 0.0;
    var T3 = 0.0;
    var dr = 0.0;
    var Jd1 = 0.0;
    var M = 0.0;
    var Mpr = 0.0;
    var F = 0.0;
    var C1 = 0.0;
    var deltat = 0.0;
    var JdNew = 0.0;
    T = k / 1236.85; // Time in Julian centuries from 1900 January 0.5
    T2 = T * T;
    T3 = T2 * T;
    dr = pi / 180;
    Jd1 = 2415020.75933 + 29.53058868 * k + 0.0001178 * T2 - 0.000000155 * T3;
    Jd1 = Jd1 +
        0.00033 *
            sin((166.56 + 132.87 * T - 0.009173 * T2) * dr); // Mean new moon
    M = 359.2242 +
        29.10535608 * k -
        0.0000333 * T2 -
        0.00000347 * T3; // Sun's mean anomaly
    Mpr = 306.0253 +
        385.81691806 * k +
        0.0107306 * T2 +
        0.00001236 * T3; // Moon's mean anomaly
    F = 21.2964 +
        390.67050646 * k -
        0.0016528 * T2 -
        0.00000239 * T3; // Moon's argument of latitude
    C1 = (0.1734 - 0.000393 * T) * sin(M * dr) + 0.0021 * sin(2 * dr * M);
    C1 = C1 - 0.4068 * sin(Mpr * dr) + 0.0161 * sin(dr * 2 * Mpr);
    C1 = C1 - 0.0004 * sin(dr * 3 * Mpr);
    C1 = C1 + 0.0104 * sin(dr * 2 * F) - 0.0051 * sin(dr * (M + Mpr));
    C1 = C1 - 0.0074 * sin(dr * (M - Mpr)) + 0.0004 * sin(dr * (2 * F + M));
    C1 = C1 - 0.0004 * sin(dr * (2 * F - M)) - 0.0006 * sin(dr * (2 * F + Mpr));
    C1 = C1 +
        0.0010 * sin(dr * (2 * F - Mpr)) +
        0.0005 * sin(dr * (2 * Mpr + M));
    if (T < -11) {
      deltat = 0.001 +
          0.000839 * T +
          0.0002261 * T2 -
          0.00000845 * T3 -
          0.000000081 * T * T3;
    } else {
      deltat = -0.000278 + 0.000265 * T + 0.000262 * T2;
    }

    JdNew = Jd1 + C1 - deltat;
    return toInit(JdNew + 0.5 + timeZone / 24);
  }

  //Tính tọa độ mặt trời để biết Trung khí nào nằm trong tháng âm lịch nào,
  //Tính xem mặt trời nằm ở khoảng nào trên đường hoàng đạo vào thời điểm bắt
  //đầu một tháng âm lịch:
  //-chia đường hoàng đạo làm 12 phần và đánh số các cung này từ 0 đến 11: từ
  //Xuân phân đến Cốc vũ là 0; từ Cốc vũ đến Tiểu mãn là 1; từ Tiểu mãn đến Hạ
  //chí là 2; v.v..
  //-cho jdn là số ngày Julius của bất kỳ một ngày, phương pháp sau này sẽ trả
  //lại số cung nói trên.
  static int getSunLongitude(int jdn, int timeZone) {
    var T = 0.0;
    var T2 = 0.0;
    var dr = 0.0;
    var M = 0.0;
    var L0 = 0.0;
    var DL = 0.0;
    var L = 0.0;
    T = (jdn - 2451545.5 - timeZone / 24) /
        36525; // Time in Julian centuries from 2000-01-01 12:00:00 GMT
    T2 = T * T;
    dr = pi / 180; // degree to radian
    M = 357.52910 +
        35999.05030 * T -
        0.0001559 * T2 -
        0.00000048 * T * T2; // mean anomaly, degree
    L0 = 280.46645 + 36000.76983 * T + 0.0003032 * T2; // mean longitude, degree
    DL = (1.914600 - 0.004817 * T - 0.000014 * T2) * sin(dr * M);
    DL = DL +
        (0.019993 - 0.000101 * T) * sin(dr * 2 * M) +
        0.000290 * sin(dr * 3 * M);
    L = L0 + DL; // true longitude, degree
    L = L * dr;
    L = L - pi * 2 * (toInit(L / (pi * 2))); // Normalize to (0, 2*PI)
    return toInit(L / pi * 6);
  }

  //Tìm ngày bắt đầu tháng 11 âm lịch
  //Đông chí thường nằm vào khoảng 19/12-22/12, như vậy trước hết ta tìm ngày Sóc trước ngày 31/12.
  //Nếu tháng bắt đầu vào ngày đó không chứa Đông chí thì ta phải lùi lại 1
  //tháng nữa.
  static int getLunarMonth11(int yy, int timeZone) {
    var k = 0;
    var off = 0;
    var nm = 0;
    var sunLong = 0;
    off = jdFromDate(31, 12, yy) - 2415021;
    k = toInit(off / 29.530588853);
    nm = getNewMoonDay(k, timeZone);
    sunLong = getSunLongitude(nm, timeZone); // sun longitude at local midnight
    if (sunLong >= 9) {
      nm = getNewMoonDay(k - 1, timeZone);
    }
    return nm;
  }

  //Xác định tháng nhuận
  //Nếu giữa hai tháng 11 âm lịch (tức tháng có chứa Đông chí) có 13 tháng âm
  // lịch thì năm âm lịch đó có tháng nhuận.
  static int getLeapMonthOffset(int a11, int timeZone) {
    var k = 0;
    var last = 0;
    var arc = 0;
    var i = 0;
    k = toInit((a11 - 2415021.076998695) / 29.530588853 + 0.5);
    last = 0;
    i = 1; // We start with the month following lunar month 11
    arc = getSunLongitude(getNewMoonDay(k + i, timeZone), timeZone);
    do {
      last = arc;
      i++;
      arc = getSunLongitude(getNewMoonDay(k + i, timeZone), timeZone);
    } while (arc != last && i < 14);
    return i - 1;
  }

  //Get timezone by locate
  static int getTimeZoneValue(Timezone timezone) {
    switch (timezone) {
      case Timezone.Chinese:
        return 8; //UTC +08
      case Timezone.Japanese:
        return 9; //UTC +09
      case Timezone.Korean:
        return 9; //UTC +09
      case Timezone.Vietnamese:
        return 7; //UTC +07
    }
  }

  //Convert solar day to lunar day
  static DateTime solarToLunar(
    int solarYear,
    int solarMonth,
    int solarDay,
    Timezone timezone,
  ) {
    var utcValue = getTimeZoneValue(timezone);
    var k = 0;
    var dayNumber = 0;
    var monthStart = 0;
    var a11 = 0;
    var b11 = 0;
    var lunarDay = 0;
    var lunarMonth = 0;
    var lunarYear = 0;
    dayNumber = jdFromDate(solarDay, solarMonth, solarYear);
    k = toInit((dayNumber - 2415021.076998695) / 29.530588853);
    monthStart = getNewMoonDay(k + 1, utcValue);
    if (monthStart > dayNumber) {
      monthStart = getNewMoonDay(k, utcValue);
    }
    a11 = getLunarMonth11(solarYear, utcValue);
    b11 = a11;
    if (a11 >= monthStart) {
      lunarYear = solarYear;
      a11 = getLunarMonth11(solarYear - 1, utcValue);
    } else {
      lunarYear = solarYear + 1;
      b11 = getLunarMonth11(solarYear + 1, utcValue);
    }
    lunarDay = dayNumber - monthStart + 1;
    var diff = toInit((monthStart - a11) / 29);
    lunarMonth = diff + 11;
    if (b11 - a11 > 365) {
      var leapMonthDiff = getLeapMonthOffset(a11, utcValue);
      if (diff >= leapMonthDiff) {
        lunarMonth = diff + 10;
        if (diff == leapMonthDiff) {}
      }
    }
    if (lunarMonth > 12) {
      lunarMonth = lunarMonth - 12;
    }
    if (lunarMonth >= 11 && diff < 4) {
      lunarYear -= 1;
    }

    return DateTime(lunarYear, lunarMonth, lunarDay);
  }

  //Convert lunar day to solar day
  List<int> lunarToSolar(
    int lunarYear,
    int lunarMonth,
    int lunarDay,
    int lunarLeap,
    Timezone timezone,
  ) {
    const result = <int>[];

    var utcValue = getTimeZoneValue(timezone);
    var k = 0,
        a11 = 0,
        b11 = 0,
        off = 0,
        leapOff = 0,
        leapMonth = 0,
        monthStart = 0;
    if (lunarMonth < 11) {
      a11 = getLunarMonth11(lunarYear - 1, utcValue);
      b11 = getLunarMonth11(lunarYear, utcValue);
    } else {
      a11 = getLunarMonth11(lunarYear, utcValue);
      b11 = getLunarMonth11(lunarYear + 1, utcValue);
    }
    off = lunarMonth - 11;
    if (off < 0) {
      off += 12;
    }
    if (b11 - a11 > 365) {
      leapOff = getLeapMonthOffset(a11, utcValue);
      leapMonth = leapOff - 2;
      if (leapMonth < 0) {
        leapMonth += 12;
      }
      if (lunarLeap != 0 && lunarMonth != leapMonth) {
        result[0] = 0;
        result[1] = 0;
        result[2] = 0;
      } else if (lunarLeap != 0 || off >= leapOff) {
        off += 1;
      }
    }
    k = toInit(0.5 + (a11 - 2415021.076998695) / 29.530588853);
    monthStart = getNewMoonDay(k + off, utcValue);
    return jdToDate(monthStart + lunarDay - 1);
  }
}
