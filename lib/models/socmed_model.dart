class SocmedModel {
  String? faq;
  String? policy;
  String? contact;
  String? email;
  String? instagram;
  String? twitter;
  String? facebook;
  String? youtube;
  String? tiktok;
  SocmedModel();
  SocmedModel.fromJson(Map json)
      : faq = json['faq']['url'],
        policy = json['policy']['url'],
        contact = json['contact']['url'],
        email = json['email']['url'],
        instagram = json['instagram']['url'],
        twitter = json['twitter']['url'],
        facebook = json['facebook']['url'],
        youtube = json['youtube']['url'],
        tiktok = json['tiktok']['url'];
}
