import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:intl/intl.dart';
import 'package:startup_namer/beans/news/newinfo.dart';
import 'package:startup_namer/beans/news/newsResult.dart';
import 'package:startup_namer/beans/webviewPage.dart';
import 'package:toast/toast.dart';
import '../DioUtil.dart';

class news_Page extends StatefulWidget {
  String title;

  news_Page(this.title);

  @override
  newsPageLayoutState createState() {
    return newsPageLayoutState();
  }
}

class newsPageLayoutState extends State<news_Page>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _postNews(storyPage,true);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Center(
            child: Column(
      children: [
        Text(widget.title),
        Text("新闻请求结果："),
        Text(netNewsResult, style: new TextStyle(color: Colors.green)),
        Expanded(
            child: isHasNewsData
                ? buildNewsList()
                : Text("暂无新闻数据", style: TextStyle(color: Colors.red)))
      ],
    )));
  }

  int storyPage = 1;
  List<newinfo> newLists = [];
  bool isHasNewsData = false;
  String netNewsResult = ""; //新闻请求结果
  EasyRefreshController _refreshController = EasyRefreshController();

  EasyRefresh buildNewsList() {
    return EasyRefresh(
      controller: _refreshController,
      firstRefresh: false,
      child: _getListView(),
      onRefresh: () async{
        await Future.delayed(Duration(seconds: 2), () {
          print("下拉刷新、、、、");
          storyPage = 1;
          _postNews(storyPage,true);
          _refreshController.finishRefresh(success: true);
        });
      },
      onLoad: () async{
        await Future.delayed(Duration(seconds: 2), () {
          print("加载更多、、、、");
          storyPage = storyPage + 1;
          _postNews(storyPage,false);
          _refreshController.finishLoad(noMore: false);
        });
      },
    );
  }

  /*
  * 生成滑动列表页面
  *
  * */
  ListView _getListView() {
    return ListView.separated(
      shrinkWrap: false,
      padding: new EdgeInsets.all(10),
      itemCount: newLists.length,
      itemBuilder: (context, i) {
        // //处理加载更多
        // if (i == this.newLists.length - 1) {
        //   storyPage = storyPage + 1;
        //   _postNews(storyPage);
        // }
        newinfo info = newLists[i];
        var date=DateFormat("MM-dd");
        String curTime=date.format(DateTime.parse(info.date));

        return  GestureDetector(
          onTap: (){
            // Toast.show(info.title, context,duration: 2);
            Navigator.push(context, MaterialPageRoute(builder: (context2) {
              return myWebViewPageless(info.title,info.url);                      //构造方法传参
            }));
          },
          child: Container(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      height: 90,
                        margin: EdgeInsets.fromLTRB(0, 0, 110, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                info.title,
                                // maxLines: 3,
                                // overflow: TextOverflow.ellipsis,
                                style: new TextStyle(color: Colors.blue,),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis
                            ),
                            Text("位置：" + i.toString()),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              Text(info.author_name, style: TextStyle(color: Colors.grey)),
                              Text(curTime, style: TextStyle(color: Colors.grey))
                            ],)
                          ],
                        )),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child:  Container(
                        margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                        child:Image.network(info.thumbnail_pic_s,width: 100)),
                  )
                ],
              )
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(
        height: 3,
        thickness: 3,
        color: Color(0xFFEEEEEE),
      ),
    );
  }


  //更新数据
  void setNewListView(bool is_hasData,bool isReFresh, List<newinfo> lists) {
    setState(() {
      this.isHasNewsData = is_hasData;
      if (this.newLists.length == 0) {
        this.newLists = lists;
      } else {
        if(isReFresh){
          this.newLists.clear();
        }
        this.newLists.addAll(lists);
      }
    });
  }

  void setNetPostNewsResult(String result) {
    setState(() {
      this.netNewsResult = result;
    });
  }

  //网络请求
  void _postNews(int page,bool isRefresh) {
    //dio库使用post
    //新闻头条
    String url =
        "http://v.juhe.cn/toutiao/index?type=top&page=$page&page_size=20&key=91b4315dbc53f7b42bc114f08b5195ce";
    DioUtil.post(url, success: (value) {
      Map<String, dynamic> resultMaps = jsonDecode(value);
      newsResult s = newsResult.fromJson(resultMaps);
      setNetPostNewsResult(s.reason);

      var data = s.result.data;
      var length = data.length;
      print("数目：" + (length.toString()));
      // if (storyPage == 4) {
      //   storyPage = storyPage - 1;
      //   Toast.show("没有更多了", context);
      //   return;
      // }
      setNewListView(data != null && data.length > 0, isRefresh,data);
    }, failure: (error) {
      print(error.toString());
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
