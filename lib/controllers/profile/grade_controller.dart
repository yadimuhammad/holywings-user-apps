import 'dart:math';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/models/vouchers/grade_model.dart';
import 'package:holywings_user_apps/utils/keys.dart';

class GradeController extends BaseControllers {
  RxList<GradeModel> arrGrade = RxList();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  @override
  Future<void> load() async {
    HomeController _homeController = Get.find();
    if (_homeController.isLoggedIn.isTrue) {
      super.load();
      await api.getMembership(controller: this);
    }
  }

  @override
  void loadSuccess({
    required int requestCode,
    required response,
    required int statusCode,
  }) {
    super.loadSuccess(
      requestCode: requestCode,
      response: response,
      statusCode: statusCode,
    );
    parseGrade(response['data']);
  }

  void parseGrade(List<dynamic> data) {
    arrGrade.clear();
    for (Map item in data) {
      arrGrade.add(GradeModel.fromJson(item));
    }
  }

  double getProgress({required int myPoint, required String name}) {
    double currentFullPercentage = 0.0; //full percentage with current grade
    int nominalRangeNeeded = 0; //nominal needed between current grade to next grade
    double reachPercentage = 0.0; //percentage reached with current grade nominal range
    int currentPoints = 0; //current point (myPoints - current grade max points)

    double hasil = 1;

    for (int i = 0; i < arrGrade.length; i++) {
      if (arrGrade[i].name?.toLowerCase() == member_tier_1 && name.toLowerCase() == member_tier_1) {
        hasil = getPercentage(
          myPoint: myPoint,
          fullPercentage: 0.36,
          needCurrentGrade: int.parse(arrGrade[i].nominalNeeded ?? '0'),
          needNextGrade: int.parse(arrGrade[i + 1].nominalNeeded ?? '0'),
          addedPoints: 0,
        );
      }

      if (arrGrade[i].name?.toLowerCase() == member_tier_2 && name.toLowerCase() == member_tier_2) {
        hasil = getPercentage(
          myPoint: myPoint,
          fullPercentage: 0.265,
          needCurrentGrade: int.parse(arrGrade[i].nominalNeeded ?? '0'),
          needNextGrade: int.parse(arrGrade[i + 1].nominalNeeded ?? '0'),
          addedPoints: 0.36,
        );
      }

      if (arrGrade[i].name?.toLowerCase() == member_tier_3 && name.toLowerCase() == member_tier_3) {
        hasil = getPercentage(
          myPoint: myPoint,
          fullPercentage: 0.265,
          needCurrentGrade: int.parse(arrGrade[i].nominalNeeded ?? '0'),
          needNextGrade: int.parse(arrGrade[i + 1].nominalNeeded ?? '0'),
          addedPoints: 0.635,
        );
      }
      if (name == member_tier_4 || name == member_tier_5) {
        hasil = 1;
      }
    }

    return hasil;
  }

  double getProgressWithinTier(int myPoint, int tier) {
    double threshold = 0.0;
    double pointPerThreshold = 1 / (arrGrade.length - 1);
    for (GradeModel grade in arrGrade) {
      int pointTemp = int.parse(grade.nominalNeeded ?? '');
      if (pointTemp == 0) continue;
      if (myPoint <= pointTemp) {
        double hasil = (((myPoint) / (pointTemp)) * pointPerThreshold + threshold);
        return hasil;
      }
      threshold += pointPerThreshold;
    }

    return 0.0;
  }

  int getMaxPoints() {
    int point = 0;
    for (GradeModel grade in arrGrade) {
      int pointTemp = int.parse(grade.nominalNeeded ?? '');
      if (pointTemp > point) point = pointTemp;
    }

    return point;
  }

  double getPercentage({
    required int myPoint,
    required double fullPercentage,
    required int needCurrentGrade,
    required int needNextGrade,
    required double addedPoints,
  }) {
    // current FULL percentage to reach VIP from Green / Prior from VIP
    double currentFullPercentage = fullPercentage;

    // nominal needed to reach vip (50jt - 12.500k) / Prior (500jt - 50jt)
    int nominalRangeNeeded = needNextGrade - needCurrentGrade;

    // current points accrd = mypoinyts - currentNominalNeeded(12.500k)
    int currentPoints = myPoint - needCurrentGrade;

    // current percentge, based on current nominal range.
    // currentPoints - nominalRangeNeeded(37500k) * 100;
    double reachPercentage = (currentPoints / nominalRangeNeeded) * 100;

    // hasil is reachPercentage / 100 * currentFullPercentage
    double hasil = (reachPercentage / 100) * currentFullPercentage;

    if (myPoint > needNextGrade) return currentFullPercentage + addedPoints;
    if (myPoint < needCurrentGrade) return addedPoints;
    return hasil += addedPoints;
  }
}
