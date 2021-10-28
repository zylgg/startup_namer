import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class myWebViewPageless extends StatelessWidget{
  String title,url;

  myWebViewPageless(this.title,this.url);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("${title}"),
      ),
      body: Center(
        child: myWebViewPage(url),
      ),
    );
  }

}

class myWebViewPage extends StatefulWidget{
  String url;

  myWebViewPage(this.url);


  @override
  myWebViewPageState createState() {
    // TODO: implement createState
    return myWebViewPageState();
  }

}

class myWebViewPageState extends State<myWebViewPage>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WebView(
      initialUrl: widget.url,
    );
  }

}