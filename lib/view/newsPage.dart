import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:startup_namer/beans/news/newinfo.dart';
import 'package:startup_namer/beans/news/newsResult.dart';
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
        return Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("位置：" + i.toString()),
            Text(
              info.title,
              // maxLines: 3,
              // overflow: TextOverflow.ellipsis,
              style: new TextStyle(color: Colors.blue),
            ),
            Text(info.date, style: TextStyle(color: Colors.grey))
          ],
        ));
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(
        height: 3,
        thickness: 3,
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
