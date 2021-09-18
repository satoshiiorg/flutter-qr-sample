import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:qr_generator/preferences.dart';
import 'package:qr_generator/qr_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

// TODO Statelessでいい？
class _MyAppState extends State<MyApp> {
  // bool preferencesLoaded = false;

  @override
  void initState() {
    super.initState();
    Preferences().load().then((_) {
      setState(() {
        // preferencesLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!Preferences().loaded) {
      return CircularProgressIndicator();
    }

    return MaterialApp(
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        if(Preferences().locale != null) {
          return Preferences().locale;
        }
        final supported = supportedLocales.any(
                (e) => e.languageCode == deviceLocale?.languageCode);
        if (supported) {
          Preferences().locale = deviceLocale;
          return deviceLocale;
        } else {
          Preferences().locale = supportedLocales.first;
          return supportedLocales.first;
        }
      },
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ja', ''),
        const Locale('en', ''),
      ],
      title: 'QR Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QrListPage(),
    );
  }
}
