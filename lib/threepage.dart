import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:startup_namer/view/newsPage.dart';
import 'package:startup_namer/view/storePage.dart';
import 'package:startup_namer/view/weatherPage.dart';
import 'package:toast/toast.dart';

class threePageWidget extends StatelessWidget {

  String clickStr;

  threePageWidget(this.clickStr);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("${clickStr}"),
      ),
      body: Center(
        child: new threePageFul(),
      ),
    );
  }
}

class threePageFul extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return threePageState();
  }
}

class threePageState extends State<threePageFul>
    with SingleTickerProviderStateMixin {
  TabController tabController=null;

  static const List<Tab> tabs = <Tab>[
    Tab(text: '天气'),
    Tab(text: '新闻'),
    Tab(text: '段子'),
  ];

  @override
  void initState() {
    super.initState();
    tabController=new TabController(length: tabs.length, vsync: this);
    tabController.addListener(() {
      Toast.show("切换到了：" + tabController.index.toString(), context);
      switch(tabController.index){
        case 1:
          // if(npage!=null&&!npage.isLoaded){
          //   npage.startLoad();
          // }
          break;
        case 2:
          // if(spage!=null&&!spage.isLoaded){
          //   spage.startLoad();
          // }
          break;
      }
    });
  }

// ...

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              toolbarHeight: 44,
                title:  TabBar(
                  controller: tabController,
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.black26,
                  tabs: tabs,
                ),
            ),
            body: buildTabBarView(context))
    );
  }
  news_Page npage;
  store_Page spage;

  TabBarView buildTabBarView(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: tabs.map((Tab tab) {
        int index = tabs.indexOf(tab);
        switch (index) {
          case 0:
            return weather_Page(index.toString());
          case 1:
            npage=news_Page(index.toString());
            return npage;
          case 2:
            spage=store_Page(index.toString());
            return spage;
        }
      }).toList(),
    );
  }




}
