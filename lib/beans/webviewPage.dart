import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:webview_flutter/webview_flutter.dart';

class myWebViewPageless extends StatelessWidget {
  String title, url;

  myWebViewPageless(this.title, this.url);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("${title}"),
      ),
      body: Center(
        child: myWebViewPage(url),
      ),
    );
  }
}

class myWebViewPage extends StatefulWidget {
  String url;

  myWebViewPage(this.url);

  @override
  myWebViewPageState createState() {
    // TODO: implement createState
    return myWebViewPageState();
  }
}

class myWebViewPageState extends State<myWebViewPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  //屏幕中间弹框
  Future<void> _askedToLead() {
    showDialog<Null>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              Text(
                "回复",
                textAlign: TextAlign.center,
              ),
              SimpleDialogOption(
                onPressed: () {
                  Toast.show("1", context);
                  Navigator.of(context).pop();
                },
                child: Text('Treasury department'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Toast.show("2", context);
                },
                child: Text('State department'),
              ),
            ],
          );
        });
  }

  TextEditingController controller = new TextEditingController();
  String curInputResult = "";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.only(bottom: 44),
            child: Divider(
              height: 2,
              thickness: 2,
            ),
          ),
        ), //分割线
        Container(
          margin: EdgeInsets.only(bottom: 45),
          child: WebView(
            initialUrl: widget.url,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 44,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    // _askedToLead();//底部输入框
                    _openCommentDialog(context);
                  },
                  child: Container(
                    width: 200,
                    height: 30,
                    padding: EdgeInsets.all(0),
                    alignment: Alignment.center,
                    // margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text("我来说两句~"),
                    ),
                  ),
                ),
                Container(
                  height: 45,
                  width: 45,
                  // margin: EdgeInsets.only(left: 10),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(Icons.message),
                      Positioned(
                          //设置角标
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: EdgeInsets.only(left: 3, right: 3),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                border: Border.all(color: Colors.red),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Text(
                              "1",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          ))
                    ],
                  ),
                ),
                Container(
                  height: 45,
                  width: 45,
                  // margin: EdgeInsets.only(left: 1),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(Icons.new_releases),
                      Positioned(
                          //ToDo 设置角标
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: EdgeInsets.only(left: 3, right: 3),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                border: Border.all(color: Colors.red),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Text(
                              "10",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          ))
                    ],
                  ),
                ),
                Container(
                  height: 45,
                  width: 45,
                  // margin: EdgeInsets.only(left: 1),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(Icons.share),
                      Positioned(
                          //ToDo 设置角标
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: EdgeInsets.only(left: 3, right: 3),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                border: Border.all(color: Colors.red),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Text(
                              "99+",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _openCommentDialog(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
            height: 120.0,
            color: Color(0xFF737373),
            child: new Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            child: Text("取消"),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          Text("回复"),
                          GestureDetector(
                              child: Text("发布",
                                  style: TextStyle(color: Colors.lime)),
                              onTap: () {
                                Navigator.of(context).pop();
                                var isEmpty = curInputResult.isEmpty;
                                if (isEmpty) {
                                  Toast.show("未输入", context);
                                } else {
                                  Toast.show("" + curInputResult, context);
                                }
                              }),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: TextField(
                        controller: controller,
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10, right: 10),
                          border: OutlineInputBorder(),
                          hintText: "输入评论~~",
                        ),
                        onChanged: (String str) {
                          print("__" + str);
                          this.curInputResult = str;
                        },
                      ),
                    ),
                    Text("111111111111111111111111111111"),
                    Text("111111111111111111111111111111")
                  ],
                )),
          );
        });
  }
}
