import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
//import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_medya/modeller/gonderi.dart';
import 'package:sosyal_medya/modeller/kullanici.dart';
import 'package:sosyal_medya/modeller/yorum.dart';
import 'package:sosyal_medya/servisler/firestoreservisi.dart';
import 'package:sosyal_medya/servisler/yetkilendirmeservisi.dart';
import 'package:timeago/timeago.dart' as timeago;

class Yorumlar extends StatefulWidget {
  final Gonderi? gonderi;

  const Yorumlar({super.key, required this.gonderi});

  @override
  State<Yorumlar> createState() => _YorumlarState();
}

class _YorumlarState extends State<Yorumlar> {
  TextEditingController _yorumKontrolcusu = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timeago.setLocaleMessages('tr', timeago.TrMessages());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Text(
          "Yorumlar",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: <Widget>[_yorumlariGoster(), _yorumEkle()],
      ),
    );
  }

  _yorumlariGoster() {
    return Expanded(
        child: StreamBuilder<QuerySnapshot>(
      stream: FireStoreServisi().yorumlariGetir(widget.gonderi!.id),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              Yorum? yorum = Yorum.dokumandanUret(snapshot.data!.docs[index]);
              return _yorumSatiri(yorum);
            });
      },
    ));
  }

  _yorumSatiri(Yorum yorum) {
    return FutureBuilder<Kullanici?>(
        future: FireStoreServisi().kullaniciGetir(yorum.yayinlayanId),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return SizedBox(
              height: 0.0,
            );
          }

          Kullanici? yayinlayan = snapshot.data;

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey,
              //backgroundImage: NetworkImage(yayinlayan!.fotoUrl ?? ''),
              // DOSYADAKİ SARI HATAYI BURDA VERİYOR
              //backgroundImage: yayinlayan!.fotoUrl!.isNotEmpty
              //    ? NetworkImage(yayinlayan.fotoUrl ?? '')
              //    : const AssetImage("assets/images/limon.png")
              //        as ImageProvider,
            ),
            title: RichText(
                text: TextSpan(
                    text: yayinlayan!.kullaniciAdi! + " ",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: [
                  TextSpan(
                    text: yorum.icerik,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14.0,
                    ),
                  )
                ])),
            subtitle: Text(timeago.format(yorum.OlusturulmaZamani!.toDate(),
                locale: "tr")),
          );
        });
  }

  _yorumEkle() {
    return ListTile(
      title: TextFormField(
        controller: _yorumKontrolcusu,
        decoration: InputDecoration(hintText: "Yorumu buraya yazın"),
      ),
      trailing: IconButton(
        icon: Icon(Icons.send),
        onPressed: _yorumGonder,
      ),
    );
  }

  void _yorumGonder() {
    String? aktifKullaniciId =
        Provider.of<YetkilendirmeServisi>(context, listen: false)
            .aktifKullaniciId;

    FireStoreServisi().yorumEkle(
        aktifKullaniciId: aktifKullaniciId,
        gonderi: widget.gonderi,
        icerik: _yorumKontrolcusu.text);

    _yorumKontrolcusu.clear();
  }
}
