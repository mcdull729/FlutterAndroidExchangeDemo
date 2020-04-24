import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  static const platform = const MethodChannel('samples.flutter.io/battery');
  static const platform2 = const MethodChannel('samples.flutter.io/openSecondActivity');
  static const platform3 = const MethodChannel('samples.flutter.io/getReturnData');

  String _batteryLevel = 'Unknown battery level.';
  String _returnData = "暂无返回值";
  Future<Null> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  Future<String> _getSecondActivity() async{
    String returnData;
    try{
      returnData = await platform2.invokeMethod('openSecondActivity');
    }catch(e){
      returnData = "获取失败 $e";
      print("error $e");
    }
    String future = await _getReturnData();
    print("future == $future");
  }

  Future<String> _getReturnData() async{
    String returnData ;
    try{
      returnData = await platform3.invokeMethod('getReturnData');
    }catch(e){
      returnData = "获取失败 $e";
      print("error $e");
    }
    setState(() {
      _returnData = returnData;
    });
    return returnData;

  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            new RaisedButton(
              child: new Text('Get Battery Level'),
              onPressed: _getBatteryLevel,
            ),
            new Text(_batteryLevel),
            RaisedButton(onPressed: _getSecondActivity,child: Text("打开第二个页面并获取返回值"),),
            Text("获取到的返回值为 $_returnData"),
          ],
        ),
      ),
    );
  }
}
