import 'package:cloud_firestore/cloud_firestore.dart';

class Yorum {
  final String? id;
  final String icerik;
  final String? yayinlayanId;
  final Timestamp? OlusturulmaZamani;
  //required yapıldı icerik kısmında
  Yorum(
      {this.id,
      required this.icerik,
      this.yayinlayanId,
      this.OlusturulmaZamani});

  factory Yorum.dokumandanUret(DocumentSnapshot doc) {
    Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;

    return Yorum(
      id: doc.id,
      icerik: doc['icerik'],
      yayinlayanId: doc['yayinlayanId'],
      OlusturulmaZamani: doc['olusturulmaZamani'],
    );
  }
}
