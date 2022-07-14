import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension StringParser on String {
  String timestampToDate({String format = 'd MMM yyy'}) {
    var str = this;
    DateTime dt = DateTime.parse(str);
    return DateFormat('$format').format(dt);
  }

  String toDateJson({String formatInput = 'dd MMM yyyy', String formatOutput = 'yyyy-MM-dd'}) {
    DateTime parseDate = new DateFormat(formatInput).parse(this);
    var inputDate = DateTime.parse(parseDate.toString());
    return DateFormat(formatOutput).format(inputDate);
  }

  DateTime toDate({String formatInput = 'yyyy-MM-dd'}) {
    return new DateFormat(formatInput).parse(this);
  }

  String timeAgo({bool numericDates = true, String suffix = ' ago'}) {
    // DateTime notificationDate = DateFormat("dd-MM-yyyy h:mma").parse(dateString);

    DateTime notificationDate = DateTime.parse(this);
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);

    var days = difference.inDays.abs();

    if ((days / 365).floor() >= 1) {
      return (numericDates) ? '${(days / 365).floor()} year$suffix' : 'Last year';
    }
    if ((days / 30).floor() >= 1) {
      return (numericDates) ? '${(days / 30).floor()} month$suffix' : 'Last month';
    }
    if ((days / 7).floor() >= 1) {
      return (numericDates) ? '${(days / 7).floor()} week$suffix' : 'Last week';
    }
    if (days >= 2) {
      return '$days days$suffix';
    }
    if (days >= 1) {
      return (numericDates) ? '1 day$suffix' : 'Yesterday';
    }
    if (difference.inHours >= 2) {
      return '${difference.inHours} hours$suffix';
    }
    if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour$suffix' : 'An hour$suffix';
    }
    if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes$suffix';
    }
    if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute$suffix' : 'A minute$suffix';
    }
    if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds$suffix';
    }
    return 'Just now';
  }
}

extension DateParser on DateTime {
  String formatDate({String format = 'dd MMM yyyy'}) {
    String formattedDate = DateFormat('$format').format(this);
    return formattedDate;
  }

  String formatDateJson({String format = 'yyyy-MM-dd'}) {
    String formattedDate = DateFormat('$format').format(this);
    return formattedDate;
  }
}

extension TextStyleExt on BuildContext {
  TextTheme style() {
    return Theme.of(this).textTheme;
  }

  TextStyle? h1() {
    return this.style().headline1;
  }

  TextStyle? h2() {
    return this.style().headline2;
  }

  TextStyle? h3() {
    return this.style().headline3;
  }

  TextStyle? h4() {
    return this.style().headline4;
  }

  TextStyle? h5() {
    return this.style().headline5;
  }

  TextStyle? bodyText1() {
    return this.style().bodyText1;
  }

  TextStyle? bodyText2() {
    return this.style().bodyText2;
  }

  TextStyle? subtitle1() {
    return this.style().subtitle1;
  }

  TextStyle? subtitle2() {
    return this.style().subtitle2;
  }
}
