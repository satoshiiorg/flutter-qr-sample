import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_generator/db.dart';
import 'package:qr_generator/qr.dart';

// QR詳細ページ
class QrDetailPage extends StatefulWidget {
  final Qr qr;

  // 既存QR編集
  QrDetailPage({Key? key, required this.qr}) : super(key: key);

  // 分けるとかえって面倒なのでコンストラクタのQRがnullならこれにとばす
  // ⇛それも面倒だったのでコンストラクタ呼ぶ側でQr.newEmpty()を渡す⇛Qr()を渡す
  // 新規QR作成
  // QrDetailPage.empty(): this(qr: Qr(title: "", text: "", created: null, modified: null));

  @override
  _QrDetailPageState createState() => _QrDetailPageState();
}

class _QrDetailPageState extends State<QrDetailPage> {
  // TODO 非効率的な気がする
  void _changeTitle(title) {
    widget.qr.title = title;
  }

  void _changeQr(text) {
    // リアルタイムでQR更新するためのsetState
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
            // TODO 動的に変更できる？
            title: Text(widget.qr.title),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  initialValue: widget.qr.title,
                  onChanged: _changeTitle,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Text'),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  initialValue: widget.qr.text,
                  onChanged: _changeQr,
                ),
                ElevatedButton(
                  child: const Text('Save'),
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
