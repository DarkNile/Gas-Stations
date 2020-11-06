import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';

class Services extends StatefulWidget {
  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
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
         ),
         backgroundColor: Colors.green[700],
         centerTitle: true,
       ),
      ),
    );
  }
}
