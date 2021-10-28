import 'package:json_annotation/json_annotation.dart';

// part 'Info.g.dart';
//
// @JsonSerializable(explicitToJson: true)
class newinfo{
   String title;
   String date;
   String author_name;
   String url;
   String thumbnail_pic_s;

   // "uniquekey": "db61b977d9fabd0429c6d0c671aeb30e",
   // "title": "“新时代女性的自我关爱”主题沙龙暨双山街道福泰社区妇儿活动家园启动仪式举行",
   // "date": "2021-03-08 13:47:00",
   // "category": "头条",
   // "author_name": "鲁网",
   // "url": "https://mini.eastday.com/mobile/210308134708834241845.html",
   // "thumbnail_pic_s": "https://dfzximg02.dftoutiao.com/news/20210308/20210308134708_d0216565f1d6fe1abdfa03efb4f3e23c_0_mwpm_03201609.png",
   // "thumbnail_pic_s02": "https://dfzximg02.dftoutiao.com/news/20210308/20210308134708_d0216565f1d6fe1abdfa03efb4f3e23c_1_mwpm_03201609.png",
   // "thumbnail_pic_s03": "https://dfzximg02.dftoutiao.com/news/20210308/20210308134708_d0216565f1d6fe1abdfa03efb4f3e23c_2_mwpm_03201609.png",
   // "is_content": "1"

   newinfo(this.title, this.date);

  // static fromJson(Map<String, dynamic> e) =>_$InfoFromJson(e);
  // Map<String, dynamic> toJson() => _$InfoToJson(this);
   newinfo.fromJson(Map<String, dynamic> json) {
     title = json['title'];
     date = json['date'];
     author_name=json['author_name'];
     url=json['url'];
     thumbnail_pic_s=json['thumbnail_pic_s'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['date'] = this.date;
    data['url']=this.url;
    data['thumbnail_pic_s']=this.thumbnail_pic_s;
    data['author_name']=this.author_name;
    return data;
  }

}