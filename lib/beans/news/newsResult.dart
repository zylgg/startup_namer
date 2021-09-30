import 'package:json_annotation/json_annotation.dart';
import 'package:startup_namer/beans/stores/Info.dart';

import 'newsData.dart';
// part 'Store.g.dart';
//
// @JsonSerializable(explicitToJson: true)
class newsResult{
  final String reason;
  final MyNewsData result;
  final int error_code;

  newsResult(this.reason, this.result, this.error_code);


  // factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);
  // Map<String, dynamic> toJson() => _$StoreToJson(this);
  static newsResult fromJson(Map<String, dynamic> json) {
    String reason = json['reason'];
    MyNewsData result =json['result'] != null ?  new MyNewsData.fromJson(json['result']) : null;
    int errorCode = json['error_code'];
    return new newsResult(reason, result, errorCode);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reason'] = this.reason;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    data['error_code'] = this.error_code;
    return data;
  }
}
