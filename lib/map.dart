import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:emarat_misr/stations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'about.dart';


class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  Completer<GoogleMapController> completer = Completer();
  TextEditingController _addController = new TextEditingController();
  GoogleMapController mapController;
  String id, gov, address, lat, long, rating, location;
  List<Marker> allMarkers = [];
  String input;
  List<dynamic> stations = <dynamic> [];
  BitmapDescriptor myIcon;

  Future<String> loadStation() async =>
      await rootBundle.loadString('assets/emarat_misr.json');

  @override
  void initState() {
    super.initState();
    loadStation();
    input = _addController.text;
    BitmapDescriptor.fromAssetImage(ImageConfiguration(),'assets/emarat.png').then((onValue){
      myIcon=onValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider
        .of(context)
        .data;
    return EasyLocalizationProvider(
        data: data,
        child: Scaffold(
          appBar: AppBar(
            title:Text(AppLocalizations.of(context).tr('titleBar'),
                style: app_bar()
            ),
            backgroundColor: Colors.green[700],
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Text(AppLocalizations.of(context).tr('exit')),
                onPressed: () => exit(0),
              ),
            ],
          ),
          body: Stack(
            children: <Widget>[
              Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: FutureBuilder(
                      future: loadStation(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          List<dynamic> parsedJson = jsonDecode(snapshot.data);
                          stations = parsedJson;

                          for (int i = 0; i < stations.length; i++) {
                            if (stations[i]['name'].toString().toLowerCase().contains(input.toLowerCase())||
                                stations[i]['name'].toString().toUpperCase().contains(input.toUpperCase())||
                                stations[i]['address'].toString().toLowerCase().contains(input.toLowerCase())||
                                stations[i]['address'].toString().toUpperCase().contains(input.toUpperCase()) ||
                                stations[i]['gov'].toString().toUpperCase().contains(input.toLowerCase()) ||
                                stations[i]['gov'].toString().toUpperCase().contains(input.toUpperCase()) ||
                                stations[i]['location'].toString().toUpperCase().contains(input.toLowerCase()) ||
                                stations[i]['location'].toString().toUpperCase().contains(input.toUpperCase())
                            )
                            {

                              id = stations[i]['name'];
                              lat = stations[i]['lat'];
                              long = stations[i]['long'];
                              address = stations[i]['address'];
                              gov = stations[i]['gov'];
                              rating = stations[i]['rating'];
                              location = stations[i]['location'];


                              allMarkers.add(
                                  Marker(
                                      icon: myIcon,
                                      markerId: MarkerId(id),
                                      position: LatLng(double.parse(lat), double.parse(long)),
                                      infoWindow: InfoWindow(
                                        title: "$id, $location [$rating]" ,
                                        snippet: "$address ",
                                      )
                                  )
                              );
                            }
                          }
                        }

                        return GoogleMap(
                          initialCameraPosition: CameraPosition(
                              target: LatLng(30.1123, 31.3439), zoom: 15),
                          mapType: MapType.normal,
                          onMapCreated: (GoogleMapController controller) {
                            completer.complete(controller);
                          },
                          markers: Set<Marker>.of(allMarkers),
                        );
                      })
              ),

              Positioned(
                top: 25,
                right: 15,
                left: 15,

                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white
                  ),

                  child: TextField(
                    controller: _addController,
                    textInputAction: TextInputAction.search,
                    autocorrect: true,
                    onChanged: (value){
                      setState(() {
                        input = value.toString();
                        allMarkers.clear();
                      });
                    },

                    decoration: InputDecoration(
                        hintText: AppLocalizations.of(context).tr('search'),
                        border: InputBorder.none,
                        hoverColor: Colors.black26,
                        contentPadding: EdgeInsets.only(left: 15, top: 15),
                        suffixIcon: IconButton(
                            icon: Icon(
                              Icons.search, size: 30, color: Colors.blueGrey,),
                            onPressed: (){
                              setState(() {
                                input = _addController.text;
                                moveToMarker();
                              });
                            }
                        )
                    ),
                  ),
                ),
              )
            ],
          ),

          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                Container(
                  height: 120,
                  color: Colors.red,
                  child: Row(
                    children: <Widget>[
                      //Icon(Icons.menu, size: 40, color: Colors.white)
                      Padding(padding: EdgeInsets.only(left: 10)),
                      CircleAvatar(backgroundImage:ExactAssetImage('assets/circle.jpg'), maxRadius: 40,)
                      ,
                      DrawerHeader(
                        child: Text(
                          AppLocalizations.of(context).tr('home'),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                              color: Colors.white,
                              fontFamily: "Times New Roman"),
                        ),
                        padding: EdgeInsets.only(top: 42, left: 20,right: 20),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.white70,
                  height: 700,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          AppLocalizations.of(context).tr('Stations'),
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.green[700],
                              fontFamily: "Times New Roman"),
                        ),
                        leading: Icon(Icons.local_gas_station, color: Colors.green[700],),
                        onTap: ()
                        {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) =>  Stations()));
                        },
                      ),
                      ListTile(
                        title: Text(
                          AppLocalizations.of(context).tr('about'),
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.green[700],
                              fontFamily: "Times New Roman"),
                        ),
                        leading: Icon(Icons.copyright),
                        onTap: ()
                        {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => About()));
                        },
                      ),


                      ListTile(
                          title: Text(AppLocalizations.of(context).tr('lang-ar'),
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.green[700],
                                fontFamily: "Times New Roman"),),
                          leading:  Icon(Icons.language, color: Colors.blue,),
//                        IconButton(
//                            icon: Icon(Icons.language),
//                            onPressed: () {
//                              data.changeLocale(Locale('ar', 'EG'));
//                            },
//                        ),
                          onTap:() => data.changeLocale(Locale('ar', 'EG'))
                      ),

                      ListTile(
                          title: Text(AppLocalizations.of(context).tr('lang-en'),
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.green[700],
                                fontFamily: "Times New Roman"),),
                          leading:  Icon(Icons.language, color: Colors.blue,),
//                        IconButton(
//                          icon: Icon(Icons.language, color: Colors.red,),
//                          onPressed: () {
//                            data.changeLocale(Locale('en', 'US'));
//                          },
//                        ),
                          onTap:() => data.changeLocale(Locale('en', 'US'))
                      ),

//                      ListTile(
//                        leading: Icon(Icons.location_city,color: Colors.blue),
//                        trailing:IconButton(
//                            icon: Text(AppLocalizations.of(context).tr('drop'),
//                              style: TextStyle(
//                                  fontSize: 20,
//                                  color: Colors.green[700],
//                                  fontFamily: "Times New Roman"),),
//                            onPressed: (){
//                              allMarkers.clear();
//                              moveToMarker();
//                              Navigator.pop(context);
//                            }),
////                        title: DropdownButton<String>(
////
////                            hint: Text(AppLocalizations.of(context).tr('gov'),
////                              style: TextStyle(
////                                  fontSize: 20,
////                                  color: Colors.green[700],
////                                  fontFamily: "Times New Roman"),),
////                            isExpanded: true,
////                            style: TextStyle(color: Colors.green[700],fontSize: 20),
////                            iconSize: 25,
////                            value: dropVal,
////                            onChanged: (value){
////                              setState(() {
////                                dropVal =value;
////
////
////
////                              });
////                            },
////                            items: Govs.map<DropdownMenuItem<String>>((String value){
////                              return DropdownMenuItem<String>(
////                                child: Text(value),
////                                value: value,
////                              );
////                            }).toList()
////                        ),
//                      ),

//                      ListTile(
//                        title: Text(
//                          AppLocalizations.of(context).tr('exit')
//                          ,style: TextStyle(color: Colors.black,fontSize: 20, fontFamily: "Times New Roman"),),
//                        onTap: ()=>exit(0),
//                        leading:Icon(Icons.close, color: Colors.red,),
////                          IconButton(icon: Icon(Icons.close,color: Colors.purpleAccent,size: 30,),
////                            onPressed: ()=>exit(0),
////                            tooltip: 'Colse app',
////                          )
//                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        )
    );
  }


  Future<void> moveToMarker() async {
    GoogleMapController controller = await completer.future;
    controller.animateCamera(
        CameraUpdate.newLatLngZoom(
            LatLng(double.parse(lat), double.parse(long)), 15));
  }

//  void onMapCreated(controller) {
//    setState(() {
//      mapController = controller;
//    });
//  }
}



TextStyle app_bar() {
  return TextStyle(
      fontSize: 25, fontFamily: "Times New Roman", fontWeight: FontWeight.bold);
}
TextStyle modalheaders(){
  return TextStyle(
      fontSize: 20,
      fontStyle: FontStyle.italic,
      fontFamily: "",
      fontWeight: FontWeight.bold,
      color: Colors.red
  );
}
TextStyle modal(){
  return TextStyle(
      fontSize: 20,
      fontStyle: FontStyle.italic,
      fontFamily: "",
      fontWeight: FontWeight.bold
  );
}