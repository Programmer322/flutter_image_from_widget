import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';


class SharePosterUtils {


  static Future<ByteData?> getWidgetToImageByteData(
      GlobalKey repaintKey) async {
//存储权限
    PermissionStatus status = await Permission.storage.status;
    print(status.isGranted);
    if (!status.isGranted) {
      status = await Permission.storage.request();
      // return null;
    }
    BuildContext? buildContext = repaintKey.currentContext;
    print(buildContext);
    if (null != buildContext) {
      RenderRepaintBoundary? boundary =
          buildContext.findRenderObject() as RenderRepaintBoundary?;
      ui.Image? image = await boundary?.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image?.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
      EasyLoading.show(status: '保存失败, == >>> 获取 image.toByteData 失败');
        return null;
      } else {
        return byteData;
      }
    }
    return null;
  }

  static Future<String?> getImageFilePath(GlobalKey repaintKey) async {
    ByteData? byteData = await SharePosterUtils.getWidgetToImageByteData(repaintKey);
    if (byteData == null) {
      print('获取 byteData 失败 ');
      return null;
    }
    Uint8List imageByte = byteData.buffer.asUint8List();
    var tempDir = await getTemporaryDirectory();
    var file = await File('${tempDir
        .path}/image_${DateTime.now().millisecond}.jpg').create();
    file.writeAsBytesSync(imageByte);
    return file.path;
  }


  // static void ShareImage(
  //     {String? title,
  //       String? decs,
  //       String? file,
  //       String? url,
  //       String? asset,
  //       int scene = 1}) async {
  //   Fluwx fluwx=Fluwx();
  //   WeChatScene wxScene = WeChatScene.session;
  //   if (scene == 2) {
  //     wxScene = WeChatScene.timeline;
  //   } else if (scene == 3) {
  //     wxScene = WeChatScene.favorite;
  //   }
  //   WeChatShareImageModel? model;
  //   print('1');
  //   if (file != null) {
  //     print('2');
  //     model = WeChatShareImageModel(WeChatImage.file(File(file)),
  //         title: title, description: decs, scene: wxScene);
  //     print('3');
  //   } else if (url != null) {
  //     model = WeChatShareImageModel(WeChatImage.network(url),
  //         title: title, description: decs, scene: wxScene);
  //   } else if (asset != null) {
  //     model = WeChatShareImageModel(WeChatImage.asset(asset),
  //         title: title, description: decs, scene: wxScene);
  //   } else {
  //     throw Exception("缺少图片资源信息");
  //   }
  //   fluwx.share(model);
  // }

  static savePosterImage(GlobalKey repaintKey) async {
    ByteData? byteData = await SharePosterUtils.getWidgetToImageByteData(repaintKey);
    if (byteData == null) {
      print('获取 byteData 失败 ');
      return;
    }
    final result = await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
    if (result['isSuccess']) {
      print('保存成功。。。');
    } else {
      print('操作失败。。。');
    }
  }

}

