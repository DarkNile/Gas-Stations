import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'splash_screen.dart';


void main() => runApp(EasyLocalization(child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
        data: data,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Emarat Misr",
          home: SplashScreen(),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            EasylocaLizationDelegate(
                locale: data.locale,
                path: 'lang'
            )
          ],
          supportedLocales: [
            Locale('en','US'),
            Locale('ar','EG')
          ],
          locale : data.savedLocale,));
  }
}
