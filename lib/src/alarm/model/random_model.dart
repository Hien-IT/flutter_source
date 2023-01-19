class RandomModel {
  RandomModel({this.coin, this.random});

  RandomModel.fromJson(Map<String, dynamic> json) {
    coin = json['coin'] as String?;
    random = json['random'] as String?;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['coin'] = coin;
    data['random'] = random;
    return data;
  }

  String? coin;
  String? random;
}

class RandomList {
  RandomList({this.list, this.createdAt});

  RandomList.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <RandomModel>[];
      json['list'].forEach((v) {
        list?.add(RandomModel.fromJson(v as Map<String, dynamic>));
      });
    }
    createdAt = DateTime.tryParse(json['createdAt'] as String);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (list != null) {
      data['list'] = list?.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = createdAt?.toIso8601String();
    return data;
  }

  List<RandomModel>? list;
  DateTime? createdAt;
}
