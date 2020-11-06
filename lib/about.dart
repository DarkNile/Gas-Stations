import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About",style: app_bar(),),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Image.asset('assets/splash.jpg',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,)
        ],
      ),
    );
  }
}

TextStyle app_bar(){
  return TextStyle(
      fontSize: 25,
      fontFamily: "Times New Roman",
      fontWeight: FontWeight.bold
  );
}