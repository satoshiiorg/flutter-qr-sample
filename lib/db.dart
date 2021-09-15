import 'package:qr_generator/qr.dart';
import 'package:sqflite/sqflite.dart';

final String tableQr = 'qr';
final String columnId = '_id';
final String columnTitle = 'title';
final String columnText = 'text';
final String columnCreated = 'created';
final String columnModified = 'modified';

final String createQr = '''
create table $tableQr ( 
  $columnId integer primary key autoincrement, 
  $columnTitle text not null,
  $columnText text not null,
  $columnCreated int not null,
  $columnModified int not null
  )
''';

//TODO やっぱりQrに定義した方がましなのだろうか
extension QrAdaptor on Qr {
  Map<String, Object?> toMap() {
    return {
      columnId: id,
      columnTitle: title,
      columnText: text,
      // TODO ここでやることではない
      columnCreated: (created ?? DateTime.now()).millisecondsSinceEpoch,
      columnModified: (modified ?? DateTime.now()).millisecondsSinceEpoch
    };
  }

  static Qr fromMap(Map<String, Object?> map) {
    return Qr(
        id: map[columnId] as int,
        title: map[columnTitle] as String,
        text: map[columnText] as String,
        created: DateTime.fromMillisecondsSinceEpoch(map[columnCreated] as int),
        modified: DateTime.fromMillisecondsSinceEpoch(map[columnModified] as int)
    );
  }
}

class QrProvider {
  late Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(createQr);
        });
  }

  Future<Qr> insert(Qr qr) async {
    int id = await db.insert(tableQr, qr.toMap());
    qr.id = id;
    return qr;
  }

  Future<int> update(Qr qr) async {
    return await db.update(tableQr, qr.toMap(),
        where: '$columnId = ?', whereArgs: [qr.id]);
  }

  Future<Qr> merge(Qr qr) async {
    if(qr.id == null) {
      return insert(qr);
    } else {
      await update(qr);
      return qr;
    }
  }

  //TODO 現状は全件取得
  Future<List<Qr>> getQrList() async {
    List<Map<String, Object?>> maps = await db.query(tableQr,
        columns: [columnId, columnTitle, columnText, columnCreated, columnModified]
    );
    return maps.map(QrAdaptor.fromMap).toList();
  }

  Future<Qr?> getQr(int id) async {
    // TODO 型もう少しきれいにならないのか
    List<Map<String, Object?>> maps = await db.query(tableQr,
        columns: [columnId, columnTitle, columnText, columnCreated, columnModified],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return QrAdaptor.fromMap(maps.first);
    }
    return null;
  }

  Future<int?> delete(int id) async {
    return await db.delete(tableQr, where: '$columnId = ?', whereArgs: [id]);
  }

  Future close() async => db.close();
}
