import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
//import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class StorageServisi {
  final _storage = FirebaseStorage.instance.ref();
  late String resimId;

  Future<String> gonderiResmiYukle(File? resimDosyasi) async {
    resimId = Uuid().v4();
    UploadTask yuklemeYoneticisi = _storage
        .child("resimler/gonderiler/gonderi_$resimId.jpg")
        .putFile(resimDosyasi!);

    final snapshot = await yuklemeYoneticisi.whenComplete(() {});
    String yuklenenResimUrl = await snapshot.ref.getDownloadURL();
    //print(yuklenenResimUrl);
    return yuklenenResimUrl;
  }

  Future<String> profilResmiYukle(File? resimDosyasi) async {
    resimId = Uuid().v4();
    UploadTask yuklemeYoneticisi = _storage
        .child("resimler/profil/profil_$resimId.jpg")
        .putFile(resimDosyasi!);

    final snapshot = await yuklemeYoneticisi.whenComplete(() {});
    String yuklenenResimUrl = await snapshot.ref.getDownloadURL();
    //print(yuklenenResimUrl);
    return yuklenenResimUrl;
  }

  void gonderiResmiSil(String gonderiResmiUrl) {
    //Burda gonderi adını almak için Regex yontemini kullandık
    RegExp arama = RegExp(r"gonderi_.+\.jpg");
    var eslesme = arama.firstMatch(gonderiResmiUrl);
    String dosyaAdi = eslesme![0]!;

    _storage.child("resimler/gonderiler/$dosyaAdi").delete();
  }
}
