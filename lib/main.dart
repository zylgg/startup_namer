// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:startup_namer/smallWidgetPage.dart';
import 'package:startup_namer/tabViewPage.dart';
import 'package:toast/toast.dart';
//其中包含数千个最常用的英文单词以及一些实用功能。

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context1) {
    final wordPair = WordPair.random();
    return new MaterialApp(
      // theme: new ThemeData(primaryColor: Colors.greenAccent),
      home: Scaffold(
        // appBar: AppBar(
        //   title: Text('Welcome to Flutter'),
        // ),
        body: Center(
          // child: Text('Hello World'),
          // child: Text(wordPair.asPascalCase)

          //3然后你需要将 RandomWords 内嵌到已有的无状态的 MyApp widget。
          child: RandomWords(),
        ),
      ),

      // title: "startup_name_generator",
      // theme: new ThemeData(
      //   primaryColor: Colors.white
      // ),
      // home: RandomWords(),
    );
  }
}

//1添加一个 stateful widget（有状态的 widget）—— RandomWords，
class RandomWords extends StatefulWidget {
  ///这个Widget是应用程序的主页
  @override
  _RandomWordsState createState() => _RandomWordsState(); //这是 Dart 中单行函数或方法的简写。
}

//2它会创建自己的状态类 —— _RandomWordsState，
class _RandomWordsState extends State<RandomWords> {
  //该应用程序的大多数逻辑都位于此处—它维护 RandomWords widget 的状态

  String floatBarStr = "小控件";
  String tabClickStr = "TabView";

  @override
  Widget build(BuildContext context2) {
    final wordPair = WordPair.random();
    // return Text(wordPair.asPascalCase);

    return Scaffold(
      appBar: AppBar(
        title: Text('这是主页面'),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.list), onPressed: _pushSave)
        ],
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          Text('可加载更多的ListView', style: new TextStyle(color: Colors.blue)),
          //在Flutter 的Column或者Row内使用ListView.builder()需要对改ListView的大小进行指定
          SizedBox(height: 300, child: _buildMoreDataListView()),

          Text('固定数量的ListView', textAlign: TextAlign.left),
          SizedBox(
            height: 250,
            child: _buildFixSizeListView(),
          )
        ],
      )),
      floatingActionButton: FloatingActionButton(
          //--------------------------------------------todo 去第二个页面
          child: Text(floatBarStr),
          onPressed: () {
            _navigationSecondPage(context2);
          }),
      persistentFooterButtons: [
        //----------------------------------------------todo 去第三个页面
        TextButton(
          child: Title(color: Colors.blue, child: Text(tabClickStr)),
          onPressed: () {
            Navigator.push(context2, MaterialPageRoute(builder: (context2) {
              return threePageWidget(tabClickStr);                      //构造方法传参
            }));
          },
        ),
      ],
    );
  }

  void _navigationSecondPage(BuildContext context) async {
    final result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => secondPageWidget(),
                settings: RouteSettings(
                  //利用settings，参数放入RouteSettings下传参
                  arguments: floatBarStr,
                )))
        // .then((value) => {
        // Toast.show(value.toString(), context)                    //第一种接受回传参数(不用async 和 await)
        // })
        ;
    if(result==null){
      Toast.show("直接返回了", context);
      return;
    }
    ScaffoldMessenger.of(context)                                  //第二种接收回传参数
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        content: Text("${result}"),
        action: SnackBarAction(
            label: "关闭",
            textColor: Colors.black45,
            onPressed: () {
              // Toast.show("点一点", context);
              // ScaffoldMessenger.of(context).removeCurrentSnackBar();
            }),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.blue,
      )).closed.then((value) => {Toast.show("我关闭了", context)});
  }

  //实现一个固定数量的ListView
  final _listDataS = <String>[];

  Widget _buildFixSizeListView() {
    _listDataS.clear();
    for (int i = 0; i < 7; i++) {
      _listDataS.add("fixItem:" + i.toString());
    }
    return ListView.builder(
        itemCount: _listDataS.length,
        itemBuilder: (context, i) {
          if (i.isOdd) return new Divider();
          final index = i ~/ 2;
          return Column(children: <Widget>[
            TextButton(
              child: Text(_listDataS[index]),
              onPressed: () {
                // AlertDialog(title: Text("你猜我是："+index.toString()));
                Toast.show("你猜我是：" + index.toString(), context);
              },
            ),
          ]);
        });
  }

  //实现一个listView,并且滑动到底部后，自动加载10个数据
  final _suggestions = <String>[];

  Widget _buildMoreDataListView() {
    for (int i = 0; i < 10; i++) {
      _suggestions.add("item:" + i.toString());
    }
    return ListView.builder(
        // padding: EdgeInsets.all(12.0), //设置一下整个listView外边距
        itemBuilder: (context, i) {
      //一个工厂匿名回调函数
      if (i.isOdd) //判断是奇数
        return Divider(
          //分割线
          height: 2,
          thickness: 2, //厚度
        );

      final index = i ~/ 2; //因为分割线也算个item，所以算item下标要除以2
      final dataSize = _suggestions.length;
      if (index >= dataSize) {
        //到底了给数组加10个数
        for (int i = dataSize; i < dataSize + 5; i++) {
          _suggestions.add("more_item:" + i.toString());
        }
      }
      return _buildRow(_suggestions[index], index);
    });
  }

  final Set<String> _saved = new Set<String>();

  Widget _buildRow(String pair, int index) {
    final bool alreadySaved = _saved.contains(pair);

    return ListTile(
      title: Text(
        pair,
        style: TextStyle(
            //定义文字样式
            // fontSize: index % 2 == 0 ? 15.0 : 9.0,
            color: index % 2 == 0 ? Colors.white : Colors.lightBlueAccent),
      ),
      tileColor: Colors.blue,
      // contentPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),//去掉item的间距
      trailing: new Icon(alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null), //尾部放一个图标，当做收藏标志
      onTap: () {
        //item点击事件
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  //点收藏的跳转方法
  void _pushSave() {
    Navigator.of(context)
        .push(new MaterialPageRoute<void>(builder: (BuildContext context) {
      final Iterable<ListTile> titles = _saved.map((String str) {
        return new ListTile(
          title: new Text(
            str,
            style: new TextStyle(fontSize: 20.0),
          ),
        );
      });

      final List<Widget> divided = ListTile.divideTiles(
        //在每个 ListTile 之间添加 1 像素的分割线。
        context: context,
        tiles: titles,
      ).toList();

      return new Scaffold(
        appBar: new AppBar(
          title: const Text('favorite list'),
        ),
        body: new ListView(children: divided),
      );
    }));
  }
}
