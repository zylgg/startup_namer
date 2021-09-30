import 'package:json_annotation/json_annotation.dart';

// part 'Info.g.dart';
//
// @JsonSerializable(explicitToJson: true)
class Info{
   String content;
   String hashId;
   int unixtime;
   String updatetime;
   bool isExpand=false;

  Info(this.content, this.hashId, this.unixtime, this.updatetime);

  // static fromJson(Map<String, dynamic> e) =>_$InfoFromJson(e);
  // Map<String, dynamic> toJson() => _$InfoToJson(this);
  Info.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    hashId = json['hashId'];
    unixtime = json['unixtime'];
    updatetime = json['updatetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['hashId'] = this.hashId;
    data['unixtime'] = this.unixtime;
    data['updatetime'] = this.updatetime;
    return data;
  }

}