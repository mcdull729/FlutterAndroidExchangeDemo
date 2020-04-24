import 'package:flutter/material.dart';

class SecondPageWithRoute extends StatelessWidget {
  final String title;

  const SecondPageWithRoute({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(child: Text('这里是命名路由页面'),),
    );
  }
}
