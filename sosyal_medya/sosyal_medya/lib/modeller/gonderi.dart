import 'package:cloud_firestore/cloud_firestore.dart';

class Gonderi {
  final String id;
  final String? gonderiResmiUrl;
  final String? aciklama;
  final String? yayinlananId;
  //begeni sayisi string yerine int yaptım
  final String? begeniSayisi;
  final String? konum;

  Gonderi(
      {required this.id,
      this.gonderiResmiUrl,
      this.aciklama,
      this.yayinlananId,
      this.begeniSayisi,
      this.konum});

  factory Gonderi.dokumandanUret(DocumentSnapshot doc) {
    Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;

    return Gonderi(
      id: doc.id,
      gonderiResmiUrl: docData['gonderiResmiUrl'],
      aciklama: docData['aciklama'],
      yayinlananId: docData['yayinlananId'],
      // begeni sayisi yerinde .tostring gelice eger tipini string yaparsan
      begeniSayisi: docData['begeniSayisi'].toString(),
      konum: docData['konum'],
    );
  }
}
