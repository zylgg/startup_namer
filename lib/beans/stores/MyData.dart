
import 'package:json_annotation/json_annotation.dart';
import 'Info.dart';

// part 'MyData.g.dart';

// @JsonSerializable(explicitToJson: true)
class MyData{
   List<Info> data;

  MyData({this.data});

  // static fromJson(Map<String, dynamic> json) =>_$MyDataFromJson(json);
  // Map<String, dynamic> toJson() => _$MyDataToJson(this);
  MyData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Info>();
      json['data'].forEach((v) {
        data.add(new Info.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}