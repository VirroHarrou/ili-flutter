class PlatformServicesModel {
  PlatformServicesModel({
    this.title,
    this.union,
    this.description,
    this.location,
    this.logoUrl,
  });

  String? logoUrl;
  String? title;
  String? location;
  String? description;
  String? union;

  PlatformServicesModel.fromJson(Map<String, dynamic> json) {
    title = json['name'];
    union = json['union'];
    description = json['description'];
    location = json['location'];
    logoUrl = json['logoUrl'];
  }
}

class PlatformNewsModel {
  PlatformNewsModel({
    this.logoUrl,
    this.title,
    this.url,
    this.order,
  });

  String? logoUrl;
  String? title;
  String? url;
  int? order;

  PlatformNewsModel.fromJson(Map<String, dynamic> json){
    logoUrl = json['logoUrl'];
    title = json['name'];
    url = json['url'];
    order = json[order];
  }
}

class PlatformLinksModel {
  String? title;
  String? url;
  int? order;

  PlatformLinksModel({
    this.title,
    this.url,
    this.order,
  });

  PlatformLinksModel.fromJson(Map<String, dynamic> json) {
    title = json['name'];
    url = json['url'];
    order = json['order'];
  }
}

class PlatformElementsSerializer {
  static Future<List<PlatformLinksModel>> deserializeLinks(List<dynamic> json) async {
    var result = <PlatformLinksModel>[];
    for (var el in json){
      result.add(PlatformLinksModel.fromJson(el));
    }
    return result;
  }

  static Future<List<PlatformServicesModel>> deserializeServices(List<dynamic> json) async {
    var result = <PlatformServicesModel>[];
    for (var el in json){
      result.add(PlatformServicesModel.fromJson(el));
    }
    return result;
  }

  static Future<List<PlatformNewsModel>> deserializeNews(List<dynamic> json) async {
    var result = <PlatformNewsModel>[];
    for (var el in json){
      result.add(PlatformNewsModel.fromJson(el));
    }
    return result;
  }
}