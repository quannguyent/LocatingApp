import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:locaing_app/res/resources.dart';
import 'package:locaing_app/utils/common.dart';

class DrawMap {
  final double sides = 3.0;

  Future<Uint8List> loadAvatarUser(String imageUrl, int width,
      {int widthStatus, int status}) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Paint borderPaint = Paint()..color = Colors.white;
    final double shadowWidth = 15.0;
    final Radius radius = Radius.circular(width / 2);

    Color colorStatus;
    if (status == 1) {
      colorStatus = AppTheme.statusOn;
    } else {
      colorStatus = AppTheme.statusOff;
    }

    final Paint shadowPaint = Paint()..color = colorStatus;

    // Add shadow circle
    if (status != null) {
      canvas.drawRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTWH(
              0.0,
              0.0,
              width * 1.0,
              width * 1.0,
            ),
            topLeft: radius,
            topRight: radius,
            bottomLeft: radius,
            bottomRight: radius,
          ),
          shadowPaint);
    }

    // Add border circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(shadowWidth, shadowWidth, width - (shadowWidth * 2),
              width - (shadowWidth * 2)),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        borderPaint);

    final double imageOffset = 15.0;

    Rect oval = Rect.fromLTWH(imageOffset, imageOffset,
        width - (imageOffset * 2), width - (imageOffset * 2));

    canvas.clipPath(Path()..addOval(oval));

    var markerImageFile = await DefaultCacheManager()
        .getSingleFile(Common.getAvatarUrl(imageUrl));
    final Uint8List markerImageBytes = await markerImageFile.readAsBytes();

    final ui.Codec markerImageCodec = await ui.instantiateImageCodec(
      markerImageBytes,
      targetWidth: width,
    );

    final ui.FrameInfo frameInfo = await markerImageCodec.getNextFrame();

    paintImage(
        canvas: canvas, image: frameInfo.image, rect: oval, fit: BoxFit.cover);

    final ui.Image markerAsImage = await pictureRecorder
        .endRecording()
        .toImage(width.toInt(), width.toInt());

    // Convert image to bytes
    final ByteData byteData =
        await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List resizedMarkerImageBytes = byteData.buffer.asUint8List();

    return resizedMarkerImageBytes;
  }

  Future<Uint8List> getBytesFromAsset(
      String path, int width, int height) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width, targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  Future<Uint8List> getBytesFromNetwork(
      String url, int width, int height) async {
    ByteData bytes = (await NetworkAssetBundle(Uri.parse(url)).load(url));
    ui.Codec codec = await ui.instantiateImageCodec(bytes.buffer.asUint8List(),
        targetWidth: width, targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  Future<Uint8List> drawTriangle(int width, int height) async {
    final double radians = math.pi * 5 / 6;
    final double radius = 30;
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    var paint = Paint()
      ..color = AppTheme.nealyRed
      ..strokeWidth = 5
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    var path = Path();

    var angle = (math.pi * 2) / sides;

    Offset center = Offset(width / 2, height / 2);
    Offset startPoint =
        Offset(radius * math.cos(radians), radius * math.sin(radians));

    path.moveTo(startPoint.dx + center.dx, startPoint.dy + center.dy);

    for (int i = 1; i <= sides; i++) {
      double x = radius * math.cos(radians + angle * i) + center.dx;
      double y = radius * math.sin(radians + angle * i) + center.dy;
      path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
    final img = await pictureRecorder.endRecording().toImage(width, height);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data.buffer.asUint8List();
  }

  Future<Uint8List> drawCircle(int width, int height, String userName,
      {int status}) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    var paint = Paint()
      ..color = AppTheme.grey_500
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    Paint paintBorder = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    Color colorStatus;
    if (status == 1) {
      colorStatus = AppTheme.statusOn;
    } else {
      colorStatus = AppTheme.statusOff;
    }

    final Paint shadowPaint = Paint()..color = colorStatus;

    Offset center = Offset(width / 2, height / 2);

    canvas.drawCircle(center, width / 2 - 2, shadowPaint);
    canvas.drawCircle(center, width / 2 - 20, paint);
    canvas.drawCircle(center, width / 2 - 20, paintBorder);

    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: userName,
      style: TextStyle(fontSize: 40.0, color: AppTheme.white),
    );
    painter.layout();
    painter.paint(
        canvas,
        Offset((width * 0.5) - painter.width * 0.5,
            (height * 0.5) - painter.height * 0.5));
    final img = await pictureRecorder.endRecording().toImage(width, height);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data.buffer.asUint8List();
  }
}
