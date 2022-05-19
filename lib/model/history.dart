import 'package:attendance/provider/db_constants.dart';

class History {
  late final int? id;
  late final String date;
  late final String pinLocation;
  late final String userLocation;
  late final num distance;

  History({
    this.id,
    required this.date,
    required this.pinLocation,
    required this.userLocation,
    required this.distance,
  });

  History.fromJson(Map<String, dynamic> json) {
    id = json[DBConstants.columnID] as int;
    date = json[DBConstants.columnDate] as String;
    pinLocation = json[DBConstants.columnPinLocation] as String;
    userLocation = json[DBConstants.columnUserLocation] as String;
    distance = json[DBConstants.columnDistance] as num;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data[DBConstants.columnDate] = date;
    _data[DBConstants.columnPinLocation] = pinLocation;
    _data[DBConstants.columnUserLocation] = userLocation;
    _data[DBConstants.columnDistance] = distance;
    return _data;
  }
}
