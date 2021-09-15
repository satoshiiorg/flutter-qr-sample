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
  // final List<Qr> qrList = [];
  // final QrProvider provider = QrProvider();
  //
  // _QrListPageState() {
  //   provider.open('qr.db');
  // }

  // @override
  // void initState() {
  //   Future.delayed(Duration.zero).then((_) => _loadQrList());
  //   super.initState();
  // }

  // QRリストのロード
  // Future _loadQrList() async {
  //   QrProvider provider = QrProvider();
  //   await provider.open('qr.db');
  //   qrList.clear();
  //   qrList.addAll(await provider.getQrList());
  // }

  // QRリストのロード
  Future<List<Qr>> _loadQrList() async {
    final provider = QrProvider();
    await provider.open('qr.db');
    return provider.getQrList();
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
                  );
                }
            );
          }
        ),
        // ListView.builder(
        //     itemCount: qrList.length,
        //     itemBuilder: (context, i) {
        //       return ListTile(
        //         title: Text(qrList[i].title),
        //         onTap: () async => _popQrDetail(qrList[i]),
        //       );
        //     }
        // ),
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