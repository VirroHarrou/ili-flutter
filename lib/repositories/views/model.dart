class Model {
  String? id;
  String? code;
  String? valueUrl;
  String? title;
  String? description;
  String? logoUrl;
  String? forumId;
  String? forumTitle;
  String? forumLogoUrl;
  String? startedAt;
  String? endedAt;
  String? createdAt;
  String? updatedAt;
  bool? like;

  Model(
      {this.id,
        this.code,
        this.valueUrl,
        this.title,
        this.logoUrl,
        this.createdAt,
        this.updatedAt,
        this.like});

  Model.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    valueUrl = json['valueUrl'];
    title = json['title'];
    description = json['description'];
    logoUrl = json['logoUrl'];
    forumId = json['forumId'];
    forumTitle = json['forumTitle'];
    forumLogoUrl = json['forumLogoUrl'];
    startedAt = json['startedAt'];
    endedAt = json['endedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    like = json['like'];
    print(json.toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['valueUrl'] = valueUrl;
    data['title'] = title;
    data['logoUrl'] = logoUrl;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['like'] = like;
    return data;
  }
}

class Favorites {
  List<Model>? modelList;

  Favorites({this.modelList});

  Favorites.fromJson(Map<String, dynamic> json) {
    if (json['favorites'] != null) {
      modelList = <Model>[];
      json['favorites'].forEach((v) {
        modelList!.add(Model.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (modelList != null) {
      data['favorites'] = modelList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ModelList {
  List<ModelReduction>? models;

  ModelList({this.models});

  ModelList.fromJson(Map<String, dynamic> json) {
    if (json['models'] != null) {
      models = <ModelReduction >[];
      json['models'].forEach((v) {
        models!.add(ModelReduction .fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (models != null) {
      data['models'] = models!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ModelReduction {
  String? id;
  String? code;

  ModelReduction({this.id, this.code});

  ModelReduction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    return data;
  }
}