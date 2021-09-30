
import 'package:json_annotation/json_annotation.dart';
import 'newinfo.dart';

// part 'MyData.g.dart';

// @JsonSerializable(explicitToJson: true)
class MyNewsData{
   List<newinfo> data;

   MyNewsData({this.data});

  // static fromJson(Map<String, dynamic> json) =>_$MyDataFromJson(json);
  // Map<String, dynamic> toJson() => _$MyDataToJson(this);
   MyNewsData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<newinfo>();
      json['data'].forEach((v) {
        data.add(new newinfo.fromJson(v));
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