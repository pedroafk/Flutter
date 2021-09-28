import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

final String _ip = "http://000.00.000.000:00000";
final String mapPointsUrl = _ip + "/rest/mappoints/?format=json";

class API{
  static Future getUsers() async {
    var url = mapPointsUrl;
    return await http.get(url);
  }
}
