
class Qr{
  int? id;
  String title;
  String text;
  DateTime? created;
  DateTime? modified;
  // DateTime created = DateTime.now();
  // DateTime modified = DateTime.now();

  Qr({
    this.id,
    this.title = "",
    this.text = "",
    this.created,
    this.modified
  });

  // Qr.newEmpty(): this(title: "", text: "", created: null, modified: null);

  // Immutableにするなら必要だが
  // Qr withId(int _id) {
  //   return Qr(
  //         id: _id,
  //         title: title,
  //         text: text,
  //         created: created,
  //         modified: modified
  //   );
  // }

  String toString() {
    return "Qr(id=$id,title=$title,text=$text,created=$created,modified=$modified)";
  }
}
