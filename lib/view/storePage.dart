import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:startup_namer/beans/stores/Info.dart';
import 'package:startup_namer/beans/stores/Store.dart';
import 'package:toast/toast.dart';

import '../DioUtil.dart';

class store_Page extends StatefulWidget {
  String title;

  bool isLoaded = false;

  store_Page(this.title);

  @override
  storepagelayout createState() {
    // TODO: implement createState
    return storepagelayout();
  }
}

class storepagelayout extends State<store_Page>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _postStory(storyPage);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(widget.title),
            Text("段子网络请求结果："),
            Text(netStoreResult, style: new TextStyle(color: Colors.green)),
            Expanded(
                child: isHasData
                    ? buildStoryList()
                    : Text("暂无故事数据", style: TextStyle(color: Colors.red))),
          ],
        ),
      ),
    );
  }

  ListView buildStoryList() {
    return ListView.separated(
      itemCount: infoLists.length,
      itemBuilder: (context, i) {
        void setCurLines(bool state) {
          setState(() {
            infoLists[i].isExpand = !state;
          });
        }

        return Container(
            padding: new EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(infoLists[i].content,
                    maxLines: infoLists[i].isExpand ? 10 : 3,
                overflow: TextOverflow.ellipsis,),
                GestureDetector(
                  child: Text(
                    infoLists[i].isExpand ? "收起" : "展开",
                    style: TextStyle(color: infoLists[i].isExpand ?Colors.blue:Colors.greenAccent),
                  ),
                  onTap: () {
                    setCurLines(infoLists[i].isExpand);
                  },
                ),
                Text("位置：" + i.toString())
              ],
            ));
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(
        height: 0,
        thickness: 0,
      ),
    );
  }

  //设置段子的信息
  bool isHasData = false;
  List<Info> infoLists = [];
  int storyPage = 1;
  String netStoreResult = ""; //段子请求结果
  void setNetPostStoreResult(String result) {
    setState(() {
      this.netStoreResult = result;
    });
  }

  void setStoreListView(bool is_hasData, List<Info> infoLists) {
    setState(() {
      this.isHasData = is_hasData;
      if (this.infoLists.length == 0) {
        this.infoLists = infoLists;
      } else {
        this.infoLists.addAll(infoLists);
      }
    });
  }

  void _postStory(int page) {
    //dio库使用post
    //笑话大全api
    String url =
        "http://v.juhe.cn/joke/content/text.php?page=$page&pagesize=10&key=70e76bbf78bfc285fb6c01483f48807a";
    DioUtil.post(url, success: (value) {
      Map<String, dynamic> resultMaps = jsonDecode(value);
      Store s = Store.fromJson(resultMaps);
      setNetPostStoreResult(s.reason);

      var data = s.result.data;
      var length = data.length;
      print("数目：" + (length.toString()));
      setStoreListView(data != null && data.length > 0, data);
    }, failure: (error) {
      print(error.toString());
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
