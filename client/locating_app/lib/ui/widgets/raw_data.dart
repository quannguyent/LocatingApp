import 'package:flutter/material.dart';
import 'package:raw_gnss/gnss_measurement_model.dart';
import 'package:raw_gnss/raw_gnss.dart';

import '../../utils/utils.dart';

class RawData extends StatefulWidget {
  @override
  _RawDataState createState() => _RawDataState();
}

class _RawDataState extends State<RawData> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30),
      width: DeviceUtil.getDeviceWidth(context),
      height: DeviceUtil.getDeviceHeight(context),
      child: SingleChildScrollView(
        child: Center(
          child: StreamBuilder<GnssMeasurementModel>(
            builder: (context, snapshot) {
              print( snapshot.data.toJson());
              return Text(snapshot.hasData ? snapshot.data.string : "");
            },
            stream: RawGnss().gnssMeasurementEvents,
          ),
        ),
      ),
    );
  }
}
