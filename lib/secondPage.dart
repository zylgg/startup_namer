import 'dart:convert';

// import 'dart:html';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:startup_namer/beans/news/newinfo.dart';
import 'package:startup_namer/beans/stores/Store.dart';
import 'package:toast/toast.dart';
import 'DioUtil.dart';
import 'package:http/http.dart' as http;

import 'beans/stores/Info.dart';
import 'beans/news/newsResult.dart';

class secondPageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //获取settings下的arguments，获取传来的参数
    String params = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text(params),
      ),
      backgroundColor: Colors.blue,
      body: Center(
        child: mytwopageFulState(),
      ),
    );
  }
}

class mytwopageFulState extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => mypagestate();
}

final List<int> colorCodes = <int>[600, 500, 100];

class mypagestate extends State {
  //--------------------------------------------------布局区--------------------------------------------
  @override
  Widget build(BuildContext context2) {
    return Scaffold(
      body: CustomScrollView(shrinkWrap: true, slivers: <Widget>[
        new SliverPadding(
          padding: EdgeInsets.all(2),
          sliver: new SliverList(
            delegate: new SliverChildListDelegate(
              <Widget>[
                Center(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card(child: Padding(
                    //     padding: EdgeInsets.only(top:50),
                    //         child:Center(
                    //           child: Column(
                    //             children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        child: TextButton(
                            child: Text("我是回弹"),
                            onPressed: () {
                              Navigator.pop(context2, "~~啥也没传回来~~");
                            })),
                    getSmallWidget(),
                  ],
                ))
              ],
            ),
          ),
        )
      ]),
      bottomNavigationBar:
      Container(
            child:
              TextButton(onPressed: () {}, child: Text("提交",style: TextStyle(backgroundColor: Colors.white38),))
          )
    );
  }

//--------------------------------------------------布局，逻辑区--------------------------------------------
  bool isCheckeds = false;
  bool check = false;

  Container getSmallWidget() {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("图片图标加载", style: TextStyle(color: Colors.blue)),
            _photoLayout(),
            Text("多选框", style: TextStyle(color: Colors.blue)),
            Row(
              children: [_getCheckbox(), _getCheckbox(), _getCheckbox()],
            ),
            Column(children: [
              getColumnCheckboxListTile(),
              getColumnCheckboxListTile(),
              getColumnCheckboxListTile(),
            ]),
            Text("单选框", style: TextStyle(color: Colors.blue)),
            _radioColumn(),
            Text("输入框", style: TextStyle(color: Colors.blue)),
            _textField()
          ],
        ));
  }

  Row _photoLayout() {
    return Row(
      children: [
        Image.asset("images/icon_phone.jpg", width: 100, height: 100),
        Image(
            image: AssetImage('images/icon_phone.jpg'),
            width: 100,
            height: 100),
        Icon(
          Icons.favorite,
          size: 36.0,
          color: Colors.blue,
        ),
      ],
    );
  }

  TextEditingController edit_controller = new TextEditingController();

  TextField _textField() {
    return TextField(
      controller: edit_controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.start,

      /// 用来设置文字的绘制方向的
      /// TextDirection.ltr left to  right 文字从左向右
      /// TextDirection.rtl right to left  文字从右向左
      textDirection: TextDirection.ltr,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "label输入手机号",
        labelStyle: TextStyle(color: Colors.pink),
        helperText: "helper输入手机号",
        helperStyle: TextStyle(color: Colors.cyanAccent),
      ),
      onChanged: (String str) {
        print("onChanged--" + str);
      },
    );
  }

  CheckboxListTile getColumnCheckboxListTile() {
    return CheckboxListTile(
      contentPadding: EdgeInsets.all(0),
      dense: false,
      controlAffinity: ListTileControlAffinity.leading,
      title: const Text('带标题的多选'),
      value: this.check,
      onChanged: (bool value) {
        setState(() {
          this.check = !this.check;
        });
      },
    );
  }

  Row _getCheckbox() {
    return Row(
      children: [
        Checkbox(
            value: isCheckeds,
            onChanged: (bool value) {
              setState(() {
                isCheckeds = value;
              });
            }),
        getTextButton()
      ],
    );
  }

  TextButton getTextButton() {
    return TextButton(
      child: Text(
        "分类",
        style: TextStyle(color: Colors.grey),
      ),
      onPressed: () {
        setState(() {
          this.isCheckeds = !isCheckeds;
        });
      },
    );
  }

  int groupValue = 2; //默认选中第几个
  Column _radioColumn() {
    return Column(
      children: [
        _colorfulRadio(1),
        _colorfulRadio(2),
        _colorfulRadio(3),
      ],
    );
  }

  Row _colorfulRadio(index) {
    return Row(
      children: [
        Radio(
          value: index,
          groupValue: groupValue,
          onChanged: (value) {
            setState(() {
              Toast.show("单选O：" + index.toString(), context);
              groupValue = value;
            });
          },
        ),
        TextButton(
          child: Text("按钮" + index.toString()),
          onPressed: () {
            setState(() {
              Toast.show("单选title：" + index.toString(), context);
              groupValue = index;
            });
          },
        )
      ],
    );
  }
}
