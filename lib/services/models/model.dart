class Model {
  String? id;
  String? code;
  String? valueUrl;
  String? valueUrlUSDZ;
  String? title;
  String? description;
  String? logoUrl;
  String? platformLogoUrl;
  int? version;
  String? createdAt;
  String? updatedAt;
  bool? like;

  Model(
      {this.id,
        this.code,
        this.valueUrl,
        this.valueUrlUSDZ,
        this.title,
        this.description,
        this.logoUrl,
        this.platformLogoUrl,
        this.version,
        this.createdAt,
        this.updatedAt,
        this.like});

  Model.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    valueUrl = json['valueUrl'];
    valueUrlUSDZ = json['valueUrlUSDZ'];
    title = json['title'];
    description = json['description'];
    logoUrl = json['logoUrl'];
    platformLogoUrl = json['platformLogoUrl'];
    version = json['version'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    like = json['like'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['valueUrl'] = valueUrl;
    data['valueUrlUSDZ'] = valueUrlUSDZ;
    data['title'] = title;
    data['description'] = description;
    data['logoUrl'] = logoUrl;
    data['platformLogoUrl'] = platformLogoUrl;
    data['version'] = version;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['like'] = like;
    return data;
  }
}