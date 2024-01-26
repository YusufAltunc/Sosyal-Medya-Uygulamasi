import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_medya/modeller/kullanici.dart';
import 'package:sosyal_medya/sayfalar/ara.dart';
import 'package:sosyal_medya/sayfalar/duyurular.dart';
import 'package:sosyal_medya/sayfalar/hesapdurumu.dart';
import 'package:sosyal_medya/sayfalar/izinlersayfasi.dart';
import 'package:sosyal_medya/sayfalar/sifredegisiklik.dart';

import '../servisler/yetkilendirmeservisi.dart';

class Ayarlar extends StatefulWidget {
  final Kullanici? profilSahipID;
  const Ayarlar({super.key, this.profilSahipID});

  @override
  State<Ayarlar> createState() => _AyarlarState();
}

class _AyarlarState extends State<Ayarlar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        backgroundColor: Colors.grey[100],
        title: Text(
          "Ayarlar",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          //Listile ornegi
          ListTile(
            leading: FlutterLogo(),
            title: Text("Listile 1"),
            subtitle: Text("Lİstile ile ilgili acıklama metni"),
            trailing: Icon(Icons.check_circle),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.published_with_changes),
            title: Text("Kullanıcı Şifre Değişikliği"),
            subtitle: Text("Şifreni mailinden değiştir"),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SifreDegisiklik(profilID: widget.profilSahipID)));
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Hesap Durumu"),
            subtitle: Text("Hesap paylaşımlarını kontrol et"),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HesapDurumu(profilIDyeni: widget.profilSahipID)));
            },
          ),
          ListTile(
            leading: Icon(Icons.person_add),
            title: Text("Yeni arkadaşlar ile tanış"),
            subtitle: Text(
                "yeni insanlarla takipleşip ve etkileşimde bulunup yeni arkadaşlıklar edin."),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Ara()));
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text("Bildirim ve Duyurular"),
            subtitle: Text(
                "Sosyal medyadaki etkileşimlerini buradan haber alabilirsiniz."),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Duyurular()));
            },
          ),
          ListTile(
            leading: Icon(Icons.devices),
            title: Text("Cihaz izinleri"),
            subtitle: Text("Cihazınızda kabul ettiğiniz izinler."),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Izinler()));
            },
          ),
          ListTile(
            title: Text(
              "${widget.profilSahipID!.kullaniciAdi} 'dan çıkış yap",
              style: TextStyle(color: Colors.red),
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Provider.of<YetkilendirmeServisi>(context, listen: false)
                  .cikisYap();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
