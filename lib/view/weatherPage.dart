

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:startup_namer/beans/weather.dart';

import '../DioUtil.dart';

class weather_Page extends StatefulWidget{

  String title;

  weather_Page(this.title);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return weatherPageLayout();
  }

}

class weatherPageLayout extends State<weather_Page> with AutomaticKeepAliveClientMixin{

  String city="",cityid="",temp="",WD="",WS="",SD="",AP="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          child: Text(widget.title,style: TextStyle(backgroundColor: Colors.blue),),
        ),
        TextButton(child: Text("测试网络请求"), onPressed: _GetPostNet),
        Text("天气网络请求结果："),
        Text("城市--"+city),
        Text("城市id--"+cityid),
        Text("温度--"+temp),
        Text("风向--"+WD),
        Text("风力--"+WS),
        Text("湿度--"+SD),
        Text("大气压强--"+AP),
      ],
    );
  }

  //--------------------------------------------------网络请求，逻辑区--------------------------------------------

  String newWeatherResult = ""; //天气请求结果

  void setNetPostWeatherResult(String result) {
    setState(() {
      this.newWeatherResult = result;
    });
  }


  int storyPage = 1;

  _GetPostNet() async {
    setNetPostWeatherResult("暂无天气数据");
    // dio库使用get
    _getWeatherInfo();
    //dio库使用post
    // _postStory(storyPage);
    // _postNews(storyPage);
  }

  void _getWeatherInfo() {
    // dio库使用get
    DioUtil.get("http://www.weather.com.cn/data/sk/101010100.html",
        success: (value) {
          Map<String, dynamic> resultMap = jsonDecode(value);
          var weatherinfo = resultMap['weatherinfo'];
          // print("天气信息Map集合——" + weatherinfo.toString());
          weatherinfo.forEach((key, value) {
            // print("key:${key}--value:${value}");
          });

          String weatherinfoJson = jsonEncode(weatherinfo); //编码生成json串
          // print("天气json串——" + weatherinfoJson);
          Map<String, dynamic> weatherinfoJsonMap = jsonDecode(weatherinfoJson);
          weather wea =weather.fromJson(weatherinfoJsonMap);
          setState(() {
            this.city=wea.city;
            this.cityid=wea.cityid;
            this.temp=wea.temp;
            this.WD=wea.WD;
            this.WS=wea.WS;
            this.SD=wea.SD;
            this.AP=wea.AP;
          });
        }, failure: (error) {
          print(error);
        });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;


}