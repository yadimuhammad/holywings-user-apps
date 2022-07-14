import 'package:flutter/material.dart';

class LMConst {
  static const kColorPrimary = Color(0xFFF3C76F);

  static const kIconCancel = 'assets/lm_cancel.svg';
  static const kIconEdit = 'assets/lm_edit.svg';
  static const kIconSave = 'assets/lm_simpan.svg';
  static const kIconReset = 'assets/lm_reset.svg';
  static const kSizeIconButton = 15.0;
  static const kSizeDialogSuccess = 100.0;
  static const kColorBlue = Color(0xFF63A9BF);
  static const kColorRed = Color(0xFFD06262);
  static const kColorGreen = Color(0xFF7FDA6B);
  static const kColorBg = Color(0xFF323232);
  static const kColorBgSecondary = Color(0xFF505050);
  static const kColorOnHold = Color(0xFFCF56AD);
  static const kWidthDialog = 450.0;
  static const kTargetParentSize = 1200;

  static const kPadding = 20.0;
  static const kPaddingS = 15.0;
  static const kPaddingXS = 10.0;
  static const kPaddingXXS = 5.0;

  static const kSizeRadiusS = Radius.circular(5.0);
  static const kSizeRadius = Radius.circular(10.0);
  static const kSizeRadiusM = Radius.circular(15.0);

  static const kStyleHeadline1 = TextStyle(fontSize: 34, color: Colors.white);
  static const kStyleHeadline2 = TextStyle(fontSize: 24, color: Colors.white);
  static const kStyleHeadline3 = TextStyle(fontSize: 18, color: Colors.white);
  static const kStyleBodyText1 = TextStyle(fontSize: 16, color: Colors.white);
  static const kStyleBodyText2 = TextStyle(fontSize: 14, color: Colors.white);
  static const kStyleSubtitle1 = TextStyle(fontSize: 14, color: Colors.white);
  static const kStyleSubtitle2 = TextStyle(fontSize: 12, color: Colors.white);

  // states
  static const kMcTypePax = 1;
  static const kMcTypeTable = 2;
  static const kStatusMejaReservation = 1;
  static const kStatusMejaWalkin = 2;
  static const kStatusMejaReservationAndWalkin = 3;
  static const kStatusMejaDisable = 4;
  static const kStatusMejaBooked = 3;
  static const kStatusMejaPending = 5;
  static const kStatusTableSelected = 00;
}

enum LayoutManagerState {
  layoutSetup,
  selectReservation,
  selectAssignSeat,
}

enum ZoomableState {
  loaded,
  editable,
}

enum TableStatus {
  unassigned,
  assigned,
  // Available
  // Not available
  // Reserved
}

enum TableState {
  normal,
  dragged,
  placeholder,
}
