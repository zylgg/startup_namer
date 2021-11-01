// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:startup_namer/smallWidget_Page.dart';
import 'package:startup_namer/tabView_Page.dart';
import 'package:toast/toast.dart';

import 'listView_Page.dart';
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
      ),
      floatingActionButton: FloatingActionButton(
          //--------------------------------------------todo 去第二个页面
          child: Text(floatBarStr),
          onPressed: () {
            _navigationSecondPage(context2);
          }),
      persistentFooterButtons: [//固定在下方显示的按钮，比如对话框下方的确定、取消按钮,上面自带分割线
        //----------------------------------------------todo 去第三个页面
        TextButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context2){
              return fourPageless();
            }));
          },
          child: Text("ListView"),
          style: ButtonStyle(
              alignment: Alignment.centerRight
          ),
        ),
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

}
