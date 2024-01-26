import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
//import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_medya/modeller/gonderi.dart';
import 'package:sosyal_medya/modeller/kullanici.dart';
import 'package:sosyal_medya/sayfalar/profil.dart';
import 'package:sosyal_medya/sayfalar/yorumlar.dart';
import 'package:sosyal_medya/servisler/firestoreservisi.dart';
import 'package:sosyal_medya/servisler/yetkilendirmeservisi.dart';

class GonderiKarti extends StatefulWidget {
  final Gonderi? gonderi;
  final Kullanici? yayinlayan;

  const GonderiKarti(
      {super.key, required this.gonderi, required this.yayinlayan});

  @override
  State<GonderiKarti> createState() => _GonderiKartiState();
}

class _GonderiKartiState extends State<GonderiKarti> {
  int? _begeniSayisi = 0;
  bool _begendin = false;
  String? _aktifKullaniciId;

  @override
  void initState() {
    super.initState();
    _aktifKullaniciId =
        Provider.of<YetkilendirmeServisi>(context, listen: false)
            .aktifKullaniciId;
    _begeniSayisi = int.parse(widget.gonderi!.begeniSayisi ?? '');
    begeniVarmi();
  }

  begeniVarmi() async {
    bool begeniVarmi =
        await FireStoreServisi().begeniVarmi(widget.gonderi, _aktifKullaniciId);
    if (begeniVarmi) {
      if (mounted) {
        setState(() {
          _begendin = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          children: <Widget>[
            _gonderiBasligi(),
            _gonderiResmi(),
            _gonderiAlt(),
          ],
        ));
  }

  gonderiSecenekleri() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Seçiminiz nedir?"),
            children: [
              SimpleDialogOption(
                child: Text("Gonderiyi Sil"),
                onPressed: () {
                  FireStoreServisi().gonderiSil(
                      aktifKullaniciId: _aktifKullaniciId,
                      gonderi: widget.gonderi);
                  Navigator.pop(context);
                },
              ),
              SimpleDialogOption(
                child: Text(
                  "Vazgeç",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Widget _gonderiBasligi() {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Profil(profilSahibiId: widget.gonderi!.yayinlananId)));
          },
          child: CircleAvatar(
            backgroundColor: Colors.blue,
            backgroundImage: NetworkImage(widget.yayinlayan!.fotoUrl ?? ''),
          ),
        ),
      ),
      title: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Profil(profilSahibiId: widget.gonderi!.yayinlananId)));
        },
        child: Text(
          widget.yayinlayan!.kullaniciAdi ?? '',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      trailing: _aktifKullaniciId == widget.gonderi!.yayinlananId
          ? IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () => gonderiSecenekleri(),
            )
          : null,
      contentPadding: EdgeInsets.all(0.0),
    );
  }

  Widget _gonderiResmi() {
    return GestureDetector(
      onDoubleTap: _begeniDegistir,
      child: Image.network(
        widget.gonderi!.gonderiResmiUrl ?? '',
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
    );

    //HATALIK BİR DURUM YOK BURDA SADECE BİR DENEME YAPMIŞIM KOD UZERİNDE
    /*Image.asset(
      "assets/images/galatasaray.png",
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      fit: BoxFit.cover,
    );
    */
    //İnternetten Image.network ile bir resim hata aldığım için asset ile projeye tanımladıgım başka bir resmi
    //kullandm. zaten burası değişecek ve firebaseden gelen resim kullanılacak
    /*Image.network(
      "https://www.google.com/search?q=g%C3%B6rseller&rlz=1C1FKPE_trTR980TR980&sxsrf=AB5stBiM4eFQbRTJMg4bzOLqeSMILDf48w:1688557353897&source=lnms&tbm=isch&sa=X&ved=2ahUKEwjryouqvvf_AhWj7LsIHXZ-CQEQ_AUoAXoECAEQAw&biw=1536&bih=714&dpr=1.25#imgrc=dnMRF3U6SIFb3M",
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      fit: BoxFit.cover,
    );*/
  }

  Widget _gonderiAlt() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            IconButton(
                icon: !_begendin
                    ? Icon(
                        Icons.favorite_border,
                        size: 35.0,
                      )
                    : Icon(
                        Icons.favorite,
                        size: 35.0,
                        color: Colors.red,
                      ),
                onPressed: _begeniDegistir),
            IconButton(
                icon: Icon(
                  Icons.comment,
                  size: 35.0,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Yorumlar(
                                gonderi: widget.gonderi,
                              )));
                }),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text("${_begeniSayisi.toString()} Beğeni",
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              )),
        ),
        SizedBox(
          height: 2.0,
        ),
        widget.gonderi!.aciklama!.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: RichText(
                    text: TextSpan(
                        text: widget.yayinlayan!.kullaniciAdi! + " ",
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        children: [
                      TextSpan(
                        text: widget.gonderi!.aciklama,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                        ),
                      )
                    ])),
              )
            : SizedBox(
                height: 0.0,
              )
      ],
    );
  }

  void _begeniDegistir() {
    if (_begendin) {
      //Kullanıcı gönderiyi beğenmiş durumda, öyleyse beğeniyi kaldıracak kodları çalıştıralım.
      setState(() {
        _begendin = false;
        _begeniSayisi = (_begeniSayisi! - 1);
      });
      FireStoreServisi().gonderiBegeniKaldir(widget.gonderi, _aktifKullaniciId);
    } else {
      //Kullanıcı gönderiyi beğenmemiş, beğeni ekleyen kodları çalıştıralım.
      setState(() {
        _begendin = true;
        _begeniSayisi = (_begeniSayisi! + 1);
      });
      FireStoreServisi().gonderiBegen(widget.gonderi, _aktifKullaniciId);
    }
  }
}
