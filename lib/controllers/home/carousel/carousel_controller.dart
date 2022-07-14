import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/models/campaign/campaign_model.dart';
import 'package:holywings_user_apps/models/home/carousel/carousel_info_model.dart';
import 'package:holywings_user_apps/screens/campaign/campaign.dart';

class CarouselController extends BaseControllers {
  CampaignModel? modelCarousel;
  RxList<CarouselInfoModel> arrData = RxList();
  RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  Future<void> load() async {
    super.load();
    await getHighlight();
    currentIndex.value = 0;
  }

  @override
  void loadSuccess({
    required int requestCode,
    required var response,
    required int statusCode,
  }) {
    super.loadSuccess(
      requestCode: requestCode,
      response: response,
      statusCode: statusCode,
    );
    processHighlight(response['data']);
    modelCarousel = CampaignModel.fromJson(response);
  }

  Future<void> getHighlight() async {
    api.getHighlight(controller: this);
  }

  void processHighlight(data) {
    arrData.clear();

    for (Map item in data) {
      arrData.add(CarouselInfoModel.fromJson(item));
    }
  }

  Function? clickCarousel(CarouselInfoModel model) {
    Get.to(
        (() => Campaign(
              id: '${model.id}',
              type: model.type.toLowerCase(),
              imageUrl: model.imageUrl,
            )),
        transition: Transition.downToUp);
  }
}
