import 'package:flutter/material.dart';
import 'package:qr_generator/db.dart';
import 'package:qr_generator/qr.dart';
import 'package:qr_generator/qr_detail.dart';

// QR一覧ページ
class QrListPage extends StatefulWidget {
  @override
  _QrListPageState createState() => _QrListPageState();
}

class _QrListPageState extends State<QrListPage> {

  // QRリストのロード
  Future<List<Qr>> _loadQrList() async {
    // TODO openまで初期処理時だけにしたい(一応)
    // Subsequent calls to openDatabase with the same path will return the same instance
    // とあるので問題はないが
    final provider = QrProvider();
    await provider.open('qr.db');
    return provider.getQrList();
  }

  // QR削除
  Future _deleteQr(Qr qr) async {
    final provider = QrProvider();
    await provider.open('qr.db');
    setState(() {
      provider.delete(qr.id!);
    });
  }

  // QR詳細画面を開き、戻ってきた場合は画面を更新する
  Future _popQrDetail(Qr? qr) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QrDetailPage(qr: qr ?? Qr()),
        )
    );
    setState(() {
      _loadQrList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title : Text("QR Code List")
      ),
      body: Center(
        child: FutureBuilder<List<Qr>>(
          future: _loadQrList(),
          builder: (context, snapshot) {
            final data = snapshot.hasData ? snapshot.data ?? [] : [];
            // リストビュー：タップ時は詳細画面へ遷移
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    title: Text(data[i].title),
                    onTap: () async => _popQrDetail(data[i]),
                    // 削除ボタン
                    trailing: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: Text("Delete '${data[i].title}'"),
                              content: Text("Are you sure?"),
                              actions: <Widget>[
                                // ボタン領域
                                TextButton(
                                  child: Text("Cancel"),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                TextButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    _deleteQr(data[i]);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    ),
                  );
                }
            );
          }
        ),
      ),
      // 新規ボタン
      floatingActionButton: FloatingActionButton(
        onPressed: () async => _popQrDetail(null),
        tooltip: 'New QR Code',
        child: Icon(Icons.add),
      ),
    );
  }
}