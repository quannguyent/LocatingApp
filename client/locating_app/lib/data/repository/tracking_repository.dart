import 'dart:typed_data';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locaing_app/data/model/model.dart';

import 'package:locaing_app/utils/utils.dart';

class TrackingRepository {
  final DrawMap drawMap = DrawMap();

  Future<Set<Marker>> getMarKerFriend(
      {List<LogLocationModel> logs, List<ProfileUserModel> profiles}) async {
    Set<Marker> markers = {};
    Map<String, LogLocationModel> _mapLocation = new Map();
    logs.forEach((log) {
      _mapLocation[log.userId] = log;
    });
    for (var friend in profiles) {
      LogLocationModel log = _mapLocation[friend.uuid];
      Uint8List avatar;
      String imageUrl = friend.avatar;
      if (log != null) {
        if (friend.avatar == null) {
          String username = friend.username.substring(0, 4);
          avatar = await drawMap.drawCircle(200, 200, username);
        } else {
          avatar = await drawMap.loadAvatarUser( imageUrl, 200);
        }
        markers.add(Marker(
          markerId: MarkerId('${friend.uuid}'),
          icon: BitmapDescriptor.fromBytes(avatar),
          position: LatLng(log.lat, log.lng),
        ));
      }
    }
    return markers;
  }
}
