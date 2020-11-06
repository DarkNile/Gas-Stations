import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:emarat_misr/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Stations extends StatefulWidget {
  @override
  _StationsState createState() => _StationsState();
}

class _StationsState extends State<Stations> {
  String id, gov, address, lat, long, rating, location;
  List<dynamic> stations = <dynamic> [];

  Future<String> loadStation() async =>
      await rootBundle.loadString('assets/emarat_misr.json');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadStation();
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
        title:Text(AppLocalizations.of(context).tr('Stations'),
    ),
    backgroundColor: Colors.green[700],
    centerTitle: true,
    ),
    body: FutureBuilder(
        future: loadStation(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<dynamic> parsedJson = jsonDecode(snapshot.data);
            stations = parsedJson;
            for (int i = 0; i < stations.length; i++) {
                id = stations[i]['name'];
                lat = stations[i]['lat'];
                long = stations[i]['long'];
                address = stations[i]['address'];
                gov = stations[i]['gov'];
                rating = stations[i]['rating'];
                location = stations[i]['location'];
              
            }
          }
          return ListView.builder(
              itemCount: stations.length,
              itemBuilder: (BuildContext context, int index){
                return Card(
                  child: Container(
                    //decoration: BoxDecoration(color: Colors.lightGreen[50]),
                    child:  ListTile(
                      title: Text("${stations[index]['name']}, ${stations[index]['location']}\n",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold
                        ),),
                      subtitle: Text(stations[index]['address'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14
                        ),),
                      onTap: () {
                        {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) =>  Services()));
                        }
                      }
                    ),
                    padding: const EdgeInsets.all(15),
                  )
                );

//                  Card(
//                    child: Container(
//                      decoration: BoxDecoration(color: Colors.lightGreen[50]),
//                      child: Center(
//                          child: Column(
//                            // Stretch the cards in horizontal axis
//                            crossAxisAlignment: CrossAxisAlignment.stretch,
//                            children: <Widget>[
//                              Text(
//                                // Read the name field value and set it in the Text widget
//                                stations[index]['name'],
//                                textAlign: TextAlign.center,
//                                // set some style to text
//                                style: TextStyle(
//                                    fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold),
//                              ),
//                              Text(
//                                // Read the name field value and set it in the Text widget
//                                stations[index]['location'],
//                                textAlign: TextAlign.center,
//                                // set some style to text
//                                style: TextStyle(
//                                    fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.bold),
//                              ),
//                              Text(
//                                // Read the name field value and set it in the Text widget
//                                stations[index]['address'],
//                                textAlign: TextAlign.center,
//                                // set some style to text
//                                style: TextStyle(
//                                    fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.bold),
//                              ),
//                            ],
//                          )),
//                      padding: const EdgeInsets.all(15.0),
//                    ),
//                  );
              }
          );
        }
    )
    )
    );
  }
}
