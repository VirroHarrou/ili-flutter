class Forums {
  List<Forum>? forumList;

  Forums({this.forumList});

  Forums.fromJson(Map<String, dynamic> json) {
    if (json['forumList'] != null) {
      forumList = <Forum>[];
      json['forumList'].forEach((v) {
        forumList!.add(Forum.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (forumList != null) {
      data['forumList'] = forumList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Forum {
  String? id = '';
  String title = '';
  String description = '';
  String logoUrl = '';
  List<String>? imageUrls;
  List<String>? mapUrls;
  String startedAt = '';
  String endedAt = '';

  Forum(
      {required this.id,
        required this.title,
        required this.description,
        required this.logoUrl,
        this.imageUrls,
        this.mapUrls,
        required this.startedAt,
        required this.endedAt});

  Forum.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    logoUrl = json['logoUrl'];
    imageUrls = json['imageUrls'].cast<String>();
    mapUrls = json['mapUrls'].cast<String>();
    startedAt = json['startedAt'];
    endedAt = json['endedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['logoUrl'] = logoUrl;
    data['imageUrls'] = imageUrls;
    data['mapUrls'] = mapUrls;
    data['startedAt'] = startedAt;
    data['endedAt'] = endedAt;
    return data;
  }
}