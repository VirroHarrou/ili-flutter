class Model {
  String? id;
  String? code;
  String? valueUrl;
  String? title;
  String? logoUrl;
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
    logoUrl = json['logoUrl'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    like = json['like'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['valueUrl'] = this.valueUrl;
    data['title'] = this.title;
    data['logoUrl'] = this.logoUrl;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['like'] = this.like;
    return data;
  }
}