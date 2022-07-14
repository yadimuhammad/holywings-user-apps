import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/models/campaign/campaign_model.dart';

class CarouselDetailsController extends BaseControllers {
  String id;
  String type;
  Rx<CampaignModel>? model = CampaignModel().obs;

  CarouselDetailsController({required this.id, required this.type});

  @override
  void onInit() {
    super.onInit();
    load();
  }

  @override
  void load() {
    super.load();
    switch (this.type) {
      case 'event':
        api.getEvent(controller: this, id: this.id);
        break;
      case 'promo':
        api.getPromo(controller: this, id: this.id);
        break;
      case 'news':
        api.getNews(controller: this, id: this.id);
        break;
    }
  }

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
    parseDetail(response['data']);
  }

  void parseDetail(Map data) {
    model!.value = CampaignModel.fromJson(data);
  }
}
