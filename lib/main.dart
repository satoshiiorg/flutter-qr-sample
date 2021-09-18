import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:qr_generator/preferences.dart';
import 'package:qr_generator/qr_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Preferences().load().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!Preferences().loaded) {
      return CircularProgressIndicator();
    }

    return MaterialApp(
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        // 言語が設定されている場合はそれを返す
        if(Preferences().locale != null) {
          return Preferences().locale;
        }

        final supported = supportedLocales.any(
                (e) => e.languageCode == deviceLocale?.languageCode);
        if (supported) {
          // サポートされているロケールがあるならそれをデフォルトにする
          Preferences().locale = deviceLocale;
          return deviceLocale;
        } else {
          // サポートされているロケールがない場合supportedLocalesの0番目をデフォルトにする
          Preferences().locale = supportedLocales.first;
          return supportedLocales.first;
        }
      },
      localizationsDelegates: [
        FlutterI18nDelegate(
          // デフォルトで useCountryCode: false
          translationLoader: FileTranslationLoader(),
          missingTranslationHandler: (key, locale) {
            print("--- Missing Key: $key, languageCode: ${locale?.languageCode}");
          },
        ),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [
        ja,
        en,
      ],
      // TODO いる？
      // builder: FlutterI18n.rootAppBuilder(),

      title: 'QR Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QrListPage(),
    );
  }
}
