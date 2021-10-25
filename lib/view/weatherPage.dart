import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:startup_namer/beans/weather.dart';
import 'package:startup_namer/view/SlideVerifyWidget.dart';
import 'package:toast/toast.dart';

import '../DioUtil.dart';

class weather_Page extends StatefulWidget {
  String title;

  weather_Page(this.title);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return weatherPageLayout();
  }
}

class weatherPageLayout extends State<weather_Page>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  String city = "", cityid = "", temp = "", WD = "", WS = "", SD = "", AP = "";

  double contentW = 300.0, contentH = 60.0; //滑动区域大小
  double tops = 0, lefts = 0; //滑块初始位置
  double boxW = 60.0, boxH = 60.0; //滑块大小
  bool isCurUnLook = false;

  double StartX = 0.0;

  Animation animation = null;
  AnimationController animationController = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: new Duration(milliseconds: 300));

    animation = CurvedAnimation(
        parent: animationController, curve: Curves.easeOut); //插值器
    animation.addListener(() {
      setState(() {
        lefts = lefts - lefts * animation.value;
        if (lefts <= 0) {
          lefts = 0;
        }
      });
    });

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        isCurUnLook = false;
        animationController.reset();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: 200,
          child:  Column(
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  widget.title,
                  style: TextStyle(backgroundColor: Colors.blue),
                ),
              ),
              TextButton(child: Text("测试网络请求"), onPressed: _GetPostNet),
              Text("天气网络请求结果："),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("城市--",style: TextStyle(backgroundColor: Colors.blue),), Text(city)]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("温度--",style: TextStyle(backgroundColor: Colors.blue)), Text(temp)]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("风向--",style: TextStyle(backgroundColor: Colors.blue)), Text(WD)]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("风力--"), Text(WS)]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("湿度--"), Text(SD)]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("压强--"), Text(AP)]),
            ],
          ),
        )
       ,
        Align(
          alignment: Alignment.center,
          child:  SlideVerifyWidget(),// 参考的滑动解锁demo
        ),
        Align(//滑动解锁demo
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 40),
            height: contentH,
            width: contentW,
            decoration: BoxDecoration(color: Colors.grey),
            child: _gestureView(),
          ),
        )
      ],
    );
  }

  Stack _gestureView() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: tops,
          left: lefts,
          child: GestureDetector(
            child: Container(
              alignment: Alignment.center,
              color: Colors.blue,
              width: boxW,
              height: boxH,
              // child: Text("滑动解锁",style: TextStyle(fontSize: 14),),
            ),
            onHorizontalDragStart: (DragStartDetails e) {
              print("onPanDown");
              StartX = e.globalPosition.dx;
            },
            onHorizontalDragUpdate: (DragUpdateDetails e) {
              if (isCurUnLook) {
                return;
              }
              print("onPanUpdate");
              double curX = e.globalPosition.dx - StartX;
              //限制在滑动区域滑动
              _settingScroll(0, curX);
            },
            onHorizontalDragEnd: (DragEndDetails e) {
              print("onPanEnd");
              if (!isCurUnLook) {
                //没解锁就反弹回去
                animationController.forward();
              }
            },
          ),
        )
      ],
    );
  }

  //设置滑动
  void _settingScroll(double curY, double curX) {
    if (curX < 0) {
      curX = 0;
    } else if (curX > contentW - boxW) {
      curX = contentW - boxW;
    }
    lefts = curX;
    if (curX == contentW - boxW) {
      Toast.show("解锁成功~", context);
      isCurUnLook = true;
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          lefts = 0;
          isCurUnLook = false;
        });
      });
    }
    setState(() {});
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
      weather wea = weather.fromJson(weatherinfoJsonMap);
      setState(() {
        this.city = wea.city;
        this.cityid = wea.cityid;
        this.temp = wea.temp;
        this.WD = wea.WD;
        this.WS = wea.WS;
        this.SD = wea.SD;
        this.AP = wea.AP;
      });
    }, failure: (error) {
      print(error);
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
