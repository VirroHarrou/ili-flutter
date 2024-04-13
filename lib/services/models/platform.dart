class Platform {
  String? id;
  String? title;
  String? description;
  int? platformType;
  String? logoUrl;
  List<String>? mediaUrls;
  List<String>? mapUrls;
  String? startedAt;
  String? endedAt;
  dynamic platformElements;

  Platform(
      {this.id,
        this.title,
        this.description,
        this.platformType,
        this.logoUrl,
        this.mediaUrls,
        this.mapUrls,
        this.startedAt,
        this.endedAt,
        this.platformElements});

  Platform.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    platformType = json['platformType'];
    logoUrl = json['logoUrl'];
    mediaUrls = json['mediaUrls'] == null ? [] : List<String>.from(json['mediaUrls'].map((x) => x));
    mapUrls = json['mapUrls'] == null ? [] : List<String>.from(json['mapUrls'].map((x) => x));
    startedAt = json['startedAt'];
    endedAt = json['endedAt'];
    platformElements = json['platformElements'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['platformType'] = platformType;
    data['logoUrl'] = logoUrl;
    data['mediaUrls'] = mediaUrls;
    data['mapUrls'] = mapUrls;
    data['startedAt'] = startedAt;
    data['endedAt'] = endedAt;
    if (platformElements != null) {
      data['platformElements'] =
          platformElements!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlatformElement {
  String? id;
  String? platformId;
  String? name;
  String? type;
  String? data;

  PlatformElement({this.id, this.platformId, this.name, this.type, this.data});

  PlatformElement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    platformId = json['platformId'];
    name = json['name'];
    type = json['type'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['platformId'] = platformId;
    data['name'] = name;
    data['type'] = type;
    data['data'] = this.data;
    return data;
  }
}