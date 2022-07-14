import 'benefit_model.dart';

class GradeModel {
  int? id;
  String? name;
  String? grade;
  String? nominalNeeded;
  String? nominalDisplay;
  String? image;
  String? description;
  String? extraDescription;
  List<BenefitModel> benefits = [];
  GradeModel.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        grade = json['grade'],
        nominalNeeded = json['minimum_experience'].toString(),
        nominalDisplay = json['nominal_display'],
        image = json['image'],
        description = json['description'],
        extraDescription = json['extra-description'] {
    benefits.clear();
    if (json['benefits'] != null) {
      for (Map item in json['benefits']) {
        benefits.add(BenefitModel.fromJson(item));
      }
    }
  }
}
