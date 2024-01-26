import 'package:flutter/src/widgets/framework.dart';
//import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_medya/modeller/gonderi.dart';
import 'package:sosyal_medya/modeller/kullanici.dart';
import 'package:sosyal_medya/sayfalar/mesajsayfasi.dart';
import 'package:sosyal_medya/servisler/firestoreservisi.dart';
import 'package:sosyal_medya/servisler/yetkilendirmeservisi.dart';
import 'package:sosyal_medya/widgetlar/gonderikarti.dart';
import 'package:sosyal_medya/widgetlar/silinmeyenfuturebuilder.dart';

class Akis extends StatefulWidget {
  final String? profilSahibiIdYeni;
  const Akis({super.key, this.profilSahibiIdYeni});

  @override
  State<Akis> createState() => _AkisState();
}

class _AkisState extends State<Akis> {
  List<Gonderi> _gonderiler = [];

  _akisGonderileriniGetir() async {
    String? aktifKullaniciId =
        Provider.of<YetkilendirmeServisi>(context, listen: false)
            .aktifKullaniciId;
    try {
      List<Gonderi> gonderiler =
          await FireStoreServisi().akisGonderileriniGetir(aktifKullaniciId);
      if (mounted) {
        setState(() {
          _gonderiler = gonderiler;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _akisGonderileriniGetir();
  }

  void Fark() {
    print("object");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SocialApp"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.message,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MesajSayfasi(
                              profilSahibiId: widget.profilSahibiIdYeni,
                            )));
              }),
        ],
      ),
      body: ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: _gonderiler.length,
        itemBuilder: (context, index) {
          Gonderi gonderi = _gonderiler[index];

          return SilinmeyenFutureBuilder(
              future: FireStoreServisi().kullaniciGetir(gonderi.yayinlananId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox();
                }

                Kullanici? gonderiSahibi = snapshot.data;

                return GonderiKarti(
                  gonderi: gonderi,
                  yayinlayan: gonderiSahibi,
                );
              });
        },
      ),
    );
  }
}
