import 'dart:convert'

class MapPoints {
  String desc;
  String latitude;
  String longitude;

  MapPoints(
      { this.desc,
        this.latitude,
        this.longitude});

  MapPoints.fromJson(Map<String, dynamic> json) {
    desc = json['desc'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['desc'] = this.desc;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
