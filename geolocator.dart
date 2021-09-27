import 'dart:convert';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';

class ClassName extends StatelessWidget {
  ClassName({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return App(
      title: "",
      theme: ,
      home: BuildMap(),
    );
  }
}

class BuildMap extends StatefulWidget {
  @override
  _BuildMapState createState() => _BuildMapState();
}

class _BuildMapState extends State<BuildMap> {

  var mapview = new List<MapPoints>();
  _getUsers(){
    API.getUsers().then((response){
      setState(() {
        Iterable lista  = json.decode(response.body);
        mapview = lista.map((model) => MapPoints.fromJson(model)).toList();
      });
    });
  }

  _BuildMapState(){
    _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: listaMapa(),
    );
  }
  listaMapa(){
    return _isGettingLocation ? Center(
      child: CircularProgressIndicator()
    ) : Scaffold(
      body: FlutterMap(
        options: MapOptions(center: new LatLng(_latitude, _longitude), zoom: 10.0, maxZoom: 18.0, minZoom: 5.0),
        layers: [
          TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a','b','c']
          ),
          new MarkerLayerOptions(markers: _ListaPontos()),
        ],
      ),
    );
  }

  _ListaPontos(){
    final List<Marker> marker = [];
    mapview.forEach((s) {
      marker.add(
        Marker(
          point: new LatLng(double.parse(s.latitude), double.parse(s.longitude)),
          builder: (ctx) => Icon(Icons.location_on, size: 50.0, color: Colors.red,),
        ),
      );
    });
    marker.add(
      Marker(
        point: new LatLng(_latitude, _longitude),
        builder: (ctx) => Icon(Icons.my_location, size: 35.5, color: Colors.black,),
      ),
    );
    return marker;
  }
  /*Começo de Geolocalização*/
  double _latitude;
  double _longitude;
  bool _isGettingLocation;

  @override
  void initState() {
    super.initState();
    _isGettingLocation = true;
    getLocation();
  }

  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    try {
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _isGettingLocation = false;
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }
  /*Fim de Geolocalização*/
}
