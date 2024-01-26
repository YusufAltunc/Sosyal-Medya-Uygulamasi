import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
//import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_medya/modeller/gonderi.dart';
import 'package:sosyal_medya/modeller/kullanici.dart';
import 'package:sosyal_medya/sayfalar/profiliduzenle.dart';
import 'package:sosyal_medya/sayfalar/ayarlarliste.dart';
import 'package:sosyal_medya/servisler/firestoreservisi.dart';
import 'package:sosyal_medya/servisler/yetkilendirmeservisi.dart';
import 'package:sosyal_medya/widgetlar/gonderikarti.dart';

class Profil extends StatefulWidget {
  final String? profilSahibiId;
  const Profil({super.key, required this.profilSahibiId});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  int _gonderiSayisi = 0;
  int _takipci = 0;
  int _takipEdilen = 0;
  List<Gonderi?> _gonderiler = [];
  String? gonderiStili = "liste";
  String? _aktifKullaniciId;
  Kullanici? _profilSahibi;
  bool _takipEdildi = false;

  _takipciSayisiGetir() async {
    int takipciSayisi =
        await FireStoreServisi().takipciSayisi(widget.profilSahibiId);
    if (mounted) {
      setState(() {
        _takipci = takipciSayisi;
      });
    }
  }

  _takipEdilenSayisiGetir() async {
    int takipEdilenSayisi =
        await FireStoreServisi().takipEdilenSayisi(widget.profilSahibiId);
    if (mounted) {
      setState(() {
        _takipEdilen = takipEdilenSayisi;
      });
    }
  }

  _gonderileriGetir() async {
    try {
      List<Gonderi> gonderiler =
          await FireStoreServisi().gonderileriGetir(widget.profilSahibiId);
      if (mounted) {
        setState(() {
          _gonderiler = gonderiler;
          _gonderiSayisi = _gonderiler.length;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  _takipKontrol() async {
    bool takipVarMi = await FireStoreServisi().takipKontrol(
        profilSahibiId: widget.profilSahibiId,
        aktifKullaniciId: _aktifKullaniciId);
    setState(() {
      _takipEdildi = takipVarMi;
    });
  }

  @override
  void initState() {
    super.initState();
    _takipciSayisiGetir();
    _takipEdilenSayisiGetir();
    _gonderileriGetir();
    _aktifKullaniciId =
        Provider.of<YetkilendirmeServisi>(context, listen: false)
            .aktifKullaniciId;
    _takipKontrol();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profil",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
        actions: <Widget>[
          widget.profilSahibiId == _aktifKullaniciId
              ? IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () => gonderiSecenekleri(),
                )
              : SizedBox(
                  height: 0.0,
                )
        ],
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<Object?>(
          future: FireStoreServisi().kullaniciGetir(widget.profilSahibiId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            _profilSahibi = snapshot.data as Kullanici?;

            return ListView(
              children: <Widget>[
                _profilDetaylari(snapshot.data as Kullanici?),
                _gonderileriGoster(snapshot.data as Kullanici?),
              ],
            );
          }),
    );
  }

//asagıda liste gorunumu ve ızgara gorunumu ayarlanmamıs sadece liste gorunumu oluyor onu duzelt
  Widget _gonderileriGoster(Kullanici? profilData) {
    if (gonderiStili == "liste") {
      return ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: _gonderiler.length,
        itemBuilder: (context, index) {
          return GonderiKarti(
            gonderi: _gonderiler[index],
            yayinlayan: profilData,
          );
        },
      );
    } else {
      List<GridTile> fayanslar = [];
      _gonderiler.forEach((gonderi) {
        fayanslar.add(_fayansOlustur(gonderi!));
      });

      return GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          mainAxisSpacing: 2.0,
          crossAxisSpacing: 2.0,
          childAspectRatio: 1.0,
          physics: NeverScrollableScrollPhysics(),
          children: fayanslar);
    }
  }

  GridTile _fayansOlustur(Gonderi gonderi) {
    return GridTile(
        child: Image.network(
      gonderi.gonderiResmiUrl ?? '',
      fit: BoxFit.cover,
    ));
  }

  Widget _profilDetaylari(Kullanici? profilData) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.blue[300],
                radius: 50.0,
                backgroundImage: profilData!.fotoUrl!.isNotEmpty
                    ? NetworkImage(profilData.fotoUrl ?? '')
                    : const AssetImage("assets/images/limon.png")
                        as ImageProvider,

                //BURDA ASSETS KULLANIMINI DENEDİM İLKİN YAPAMADIM AMA SONRASINDA HALLETTİM ASAGIDAKI KODLAR BOŞTUR YUKARDA HALLETTİM ZATEN
                //profilData!.fotoUrl!.isNotEmpty ? NetworkImage(profilData.fotoUrl ?? '') : const AssetImage("assets/images/galatasaray.png"),
                //NetworkImage(profilData!.fotoUrl ?? ''),
                //AssetImage("assets/images/galatasaray.png"),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _sosyalSayac(baslik: "Gönderiler", sayi: _gonderiSayisi),
                    _sosyalSayac(baslik: "Takipçi", sayi: _takipci),
                    _sosyalSayac(baslik: "Takip", sayi: _takipEdilen),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            profilData.kullaniciAdi ?? '',
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(profilData.hakkinda ?? ''),
          SizedBox(
            height: 25.0,
          ),
          widget.profilSahibiId == _aktifKullaniciId
              ? profiliDuzenleButon()
              : _takipButonu(),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 10.0),
                IconButton(
                    iconSize: 30.0,
                    onPressed: () {
                      setState(() {
                        gonderiStili = "liste";
                      });
                    },
                    icon: Icon(Icons.list)),
                Text("|"),
                IconButton(
                    iconSize: 30.0,
                    onPressed: () {
                      setState(() {
                        gonderiStili = "izgara";
                      });
                    },
                    icon: Icon(Icons.apps_outlined)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _takipButonu() {
    return _takipEdildi ? _takiptenCikButonu() : _takipEtButonu();
  }

  Widget _takipEtButonu() {
    return Container(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          FireStoreServisi().takipEt(
              profilSahibiId: widget.profilSahibiId,
              aktifKullaniciId: _aktifKullaniciId);
          setState(() {
            _takipEdildi = true;
            _takipci = _takipci + 1;
          });
        },
        child: Text(
          "Takip Et",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
        ),
      ),
    );
  }

  Widget _takiptenCikButonu() {
    return Container(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          FireStoreServisi().takiptenCik(
              profilSahibiId: widget.profilSahibiId,
              aktifKullaniciId: _aktifKullaniciId);
          setState(() {
            _takipEdildi = false;
            _takipci = _takipci - 1;
          });
        },
        child: Text(
          "Takipten Çık",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget profiliDuzenleButon() {
    return Container(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfiliDuzenle(
                        profil: _profilSahibi,
                      )));
        },
        child: Text("Profili Düzenle"),
      ),
    );
  }

  Widget _sosyalSayac({required String baslik, required int sayi}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          sayi.toString(),
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 2.0,
        ),
        Text(
          baslik,
          style: TextStyle(fontSize: 15.0),
        ),
      ],
    );
  }

  void _cikisyap() {
    Provider.of<YetkilendirmeServisi>(context, listen: false).cikisYap();
  }

  gonderiSecenekleri() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Seçiminiz nedir?"),
            children: [
              SimpleDialogOption(
                child: Text("Ayarlar menüsü"),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Ayarlar(
                                profilSahipID: _profilSahibi,
                              )));
                  //Navigator.pop(context);
                },
              ),
              SimpleDialogOption(
                child: Text(
                  "Çıkış Yap",
                ),
                onPressed: () {
                  Provider.of<YetkilendirmeServisi>(context, listen: false)
                      .cikisYap();
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
}
