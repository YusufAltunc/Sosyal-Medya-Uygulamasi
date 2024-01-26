import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
//import 'package:flutter/src/widgets/placeholder.dart';
import 'package:sosyal_medya/modeller/gonderi.dart';
import 'package:sosyal_medya/modeller/kullanici.dart';
import 'package:sosyal_medya/servisler/firestoreservisi.dart';
import 'package:sosyal_medya/widgetlar/gonderikarti.dart';

class TekliGonderi extends StatefulWidget {
  final String? gonderiId;
  final String? gonderiSahibiId;

  const TekliGonderi({super.key, this.gonderiId, this.gonderiSahibiId});

  @override
  State<TekliGonderi> createState() => _TekliGonderiState();
}

class _TekliGonderiState extends State<TekliGonderi> {
  Gonderi? _gonderi;
  Kullanici? _gonderiSahibi;
  bool _yukleniyor = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gonderiGetir();
  }

  gonderiGetir() async {
    Gonderi gonderi = await FireStoreServisi()
        .tekliGonderiGetir(widget.gonderiId, widget.gonderiSahibiId);
    Kullanici? gonderiSahibi =
        await FireStoreServisi().kullaniciGetir(gonderi.yayinlananId);

    setState(() {
      _gonderi = gonderi;
      _gonderiSahibi = gonderiSahibi;
      _yukleniyor = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[100],
          title: Text(
            "Gonderi",
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: !_yukleniyor
            ? GonderiKarti(gonderi: _gonderi, yayinlayan: _gonderiSahibi)
            : Center(child: CircularProgressIndicator()));
  }
}
