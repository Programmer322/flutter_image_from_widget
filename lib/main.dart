import 'package:flutter/material.dart';
import 'package:testapp/utils.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyDrawingPage(),
    );
  }
}

class MyDrawingPage extends StatefulWidget {

  @override
  State<MyDrawingPage> createState() => _MyDrawingPageState();
}

class _MyDrawingPageState extends State<MyDrawingPage> {
  GlobalKey repaintWidgetKey = GlobalKey(); // 绘图key值
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('生成图片示例'),
      ),
      body: Center(
        child: RepaintBoundary(
          key: repaintWidgetKey,
          child: Container(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    var aaa = await SharePosterUtils.getImageFilePath(repaintWidgetKey);
                    await SharePosterUtils.savePosterImage(repaintWidgetKey);
                  },
                  child: Text('生成图片'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

