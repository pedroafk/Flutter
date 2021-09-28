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
      home: BuildList(),
    );
  }
}

class BuildList extends StatefulWidget {
  @override
  _BuildListState createState() => _BuildListState();
}
class _BuildListState extends State<BuildList> {

  var mappoints = new List<MapPoints>();
  _getUsers(){
    API.getUsers().then((response){
      setState(() {
        Iterable lista  = json.decode(response.body);
        mappoints = lista.map((model) => MapPoints.fromJson(model)).toList();
      });
    });
  }

  _BuildListState(){
    _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: listaUsuario(),
    );
  }
  listaUsuario(){
    _getLocationBasedPos();
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: mapPointsOrdered.length,
        itemBuilder: (context, index){
          return Card(
            child: ListTile(
                leading: Icon(Icons.pin_drop),
                title: Text('Local ${mapPointsOrdered[index].desc}',style: TextStyle(fontSize: 20.0, color: Colors.black),),
                subtitle: Text(mapPointsOrdered[index].latitude +' , '+ mapPointsOrdered[index].longitude),
                isThreeLine: true
            ),
          );
        }
    );
  }

  /*Começo de Geolocalização para listas*/
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
  /*Fim da Geolocalização para listas*/
  _getLocationBasedPos(){ /*Função para ordenar lista só quando receber os dados async*/
    if(!_isGettingLocation){
      _orderedList(_latitude, _longitude);
    }
  }

  var mapPointsOrdered = [];
  var distBasedUserLocation = [];

  _orderedList(xA,yA){
    mapPointsOrdered.clear();
    distBasedUserLocation.clear();
    for(int i=0; i<mappoints.length; i++){
      var xB = double.parse(mappoints[i].latitude);
      var yB = double.parse(mappoints[i].longitude);
      var dAB = sqrt(   pow((xB-xA), 2) + pow((yB-yA), 2)   );
      distBasedUserLocation.add(dAB);
    }
    _orderedVector(distBasedUserLocation);
    _createOrderedListForMap(distBasedUserLocation,xA,yA);
  }

  _orderedVector(distance){
    var aux;
    for(int i=0; i<distance.length; i++ ){
      for(int j=i+1; j<distance.length; j++ ){
        if( distance[i] > distance[j] ){
          aux = distance[i];
          distance[i] = distance[j];
          distance[j] = aux;
        }
      }
    }
  }

  _createOrderedListForMap(distance,xA,yA){
    for(int i=0; i<distance.length; i++){
      for(int j=0; j<distance.length; j++){
        var xB = double.parse(mappoints[j].latitude);
        var yB = double.parse(mappoints[j].longitude);
        var dAB = sqrt(   pow((xB-xA), 2) + pow((yB-yA), 2)   );
        if(dAB == distance[i]){
          mapPointsOrdered.add(mappoints[j]);
        }
      }
    }
  }
}
