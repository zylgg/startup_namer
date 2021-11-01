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

void main() => runApp(threePageWidget(TITLE));

String TITLE="TabBar首页";
class threePageWidget extends StatelessWidget {
  String clickStr="";
  //
  threePageWidget(this.clickStr);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("${clickStr}"),
        ),
        body: Center(
          child: new threePageFul(),
        ),
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
  TabController tabController = null;

  static const List<Tab> tabs = <Tab>[
    Tab(
      text: '新闻',
      icon: Icon(Icons.home),
    ),
    Tab(text: '天气',
      // icon: Text("   "),
      icon: Icon(Icons.ac_unit_outlined),
      // iconMargin: EdgeInsets.only(bottom: 20),
    ),

    Tab(text: '段子', icon: Icon(Icons.favorite)),
  ];

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: tabs.length, vsync: this);
    tabController.addListener(() {
      print("切换到了：" + tabController.index.toString());
      switch (tabController.index) {
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
      _bottomCenterListener(tabController.index);
    });
  }

// ...

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        // appBar: AppBar(//上面放导航栏
        //   backgroundColor: Colors.white,
        //   automaticallyImplyLeading: false,
        //   toolbarHeight: 44,
        //   title: TabBar(
        //     controller: tabController,
        //     labelColor: Colors.blue,
        //     unselectedLabelColor: Colors.black26,
        //     tabs: tabs,
        //   ),
        // ),
        floatingActionButton: FloatingActionButton(
            child: new Image.asset(
              centerIcons,
              width: 30.0,
              height: 30.0,
            ),
            backgroundColor: Colors.white,
            elevation: 4,
            onPressed: _bottomCenterListener1),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        body: buildTabBarView(context),
        bottomNavigationBar: _myTabBarStack(),
      ),
    );
  }

  String centerIcons = "images/bottom_default.png";

  _bottomCenterListener1() {
    setState(() {
      _bottomCenterListener(1);
    });
  }

  _bottomCenterListener(int index) {
    setState(() {
      if (index == 1) {
        this.centerIcons = "images/bottom_select.png";
        print("中间");
        this.tabController.animateTo(1,
            duration: const Duration(milliseconds: 300), curve: Curves.ease);
      } else {
        this.centerIcons = "images/bottom_default.png";
      }
    });
  }

  Container _myTabBarStack() {
    return Container(
        height: 60,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          overflow: Overflow.visible,
          children: [
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: _myTabBar(),
            ),
            Container(
                margin: EdgeInsets.only(bottom: 60),
                child: Divider(
                  height: 2,
                  thickness: 2,
                )),
            // Align(
            //   alignment: AlignmentDirectional.bottomCenter,
            //   child: InkWell(
            //     child: Image.asset(centerIcons, width: 50, height: 50),
            //     onTap: _bottomCenterListener1,
            //   ),
            // ),
            // Container(
            //   margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            //   child: InkWell(
            //     child: new Image.asset(
            //       centerIcons,
            //       width: 50.0,
            //       height: 50.0,
            //     ),
            //     onTap: _bottomCenterListener1,
            //   ),
            // )
          ],
        ));
  }

  Widget _myTabBar() {
    return Theme(
        //地下放导航栏
        data: ThemeData(
          highlightColor: Colors.transparent,

          ///点击的背景高亮颜色,处理阴影
          splashColor: Colors.transparent,

          ///点击水波纹颜色
        ),
        child: TabBar(
          controller: tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.black26,
          indicatorSize: TabBarIndicatorSize.label,
          indicator: const BoxDecoration(),
          tabs: tabs,
        ));
  }

  news_Page npage;
  store_Page spage;

  TabBarView buildTabBarView(BuildContext context) {
    return TabBarView(
      physics: NeverScrollableScrollPhysics(),
      controller: tabController,
      children: tabs.map((Tab tab) {
        int index = tabs.indexOf(tab);
        switch (index) {
          case 0:
            npage = news_Page(index.toString());
            return npage;
          case 1:
            return weather_Page(index.toString());
          case 2:
            spage = store_Page(index.toString());
            return spage;
        }
      }).toList(),
    );
  }
}
