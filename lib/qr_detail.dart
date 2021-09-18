import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_generator/db.dart';
import 'package:qr_generator/qr.dart';

// QR詳細ページ
class QrDetailPage extends StatefulWidget {
  final Qr qr;

  // 既存QR編集
  QrDetailPage({Key? key, required this.qr}) : super(key: key);

  @override
  _QrDetailPageState createState() => _QrDetailPageState();
}

class _QrDetailPageState extends State<QrDetailPage> {
  void _changeTitle(title) {
    setState(() {
      widget.qr.title = title;
    });
  }

  void _changeQr(text) {
    setState(() {
      widget.qr.text = text;
    });
  }

  // TODO 初期化タイミング考える
  Future<Qr> _saveQr() async {
    final provider = QrProvider();
    await provider.open('qr.db');
    return provider.merge(widget.qr);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            title: I18nText('detailTitle',
                translationParams: {'title': widget.qr.title}),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                      labelText: FlutterI18n.translate(context, 'title')),
                  initialValue: widget.qr.title,
                  onChanged: _changeTitle,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: FlutterI18n.translate(context, 'text')),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  initialValue: widget.qr.text,
                  onChanged: _changeQr,
                ),
                ElevatedButton(
                  child: I18nText('save'),
                  onPressed: _saveQr,
                ),
                QrImage(
                  data: widget.qr.text,
                  version: QrVersions.auto,
                  size: 300.0,
                ),
              ],
            ),
          )
      )
    );
  }
}
