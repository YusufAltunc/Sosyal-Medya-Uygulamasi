import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_medya/modeller/kullanici.dart';
import 'package:sosyal_medya/servisler/yetkilendirmeservisi.dart';

class SifreDegisiklik extends StatefulWidget {
  final Kullanici? profilID;
  const SifreDegisiklik({super.key, this.profilID});

  @override
  State<SifreDegisiklik> createState() => _SifreDegisiklikState();
}

class _SifreDegisiklikState extends State<SifreDegisiklik> {
  bool yukleniyor = false;
  final _formAnahtari = GlobalKey<FormState>();
  final _scaffoldAnahtari = GlobalKey<ScaffoldState>();
  late String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldAnahtari,
      appBar: AppBar(
        title: Text("Şifremi değiştir"),
      ),
      body: ListView(
        children: [
          yukleniyor
              ? LinearProgressIndicator()
              : SizedBox(
                  height: 0.0,
                ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
                key: _formAnahtari,
                child: Column(
                  children: <Widget>[
                    Text(
                      "Kullanıcı Adı : ${widget.profilID!.kullaniciAdi}",
                      style: TextStyle(fontSize: 15.0),
                    ),
                    SizedBox(height: 23.0),
                    Text(
                      "Hakkımda : ${widget.profilID!.hakkinda}",
                      style: TextStyle(fontSize: 15.0),
                    ),
                    SizedBox(height: 23.0),
                    TextFormField(
                      //widget.profili cekerken profili boş veriyor bunu profildeki profilsahibi değişkeninden diye cek
                      initialValue: widget.profilID!.email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Mail:",
                        errorStyle: TextStyle(fontSize: 16.0),
                        prefix: Icon(Icons.mail),
                      ),
                      validator: (girienDeger) {
                        if (girienDeger!.isEmpty) {
                          return "Email alanı boş bırakılamaz";
                        } else if (!girienDeger.contains("@")) {
                          return "Girilen değer mail formatında olmalı!";
                        } else if (girienDeger.trim().length <= 3) {
                          return "Kullanıcı adı en az 4 karakter olmalı";
                        }
                        return null;
                      },
                      onSaved: (girilenDeger) => email = girilenDeger!,
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Container(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: _sifreyiSifirla,
                        child: Text(
                          "Şifremi Sıfırla",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  void _sifreyiSifirla() async {
    final _yetkilendirmeServisi =
        Provider.of<YetkilendirmeServisi>(context, listen: false);

    var _formState = _formAnahtari.currentState!;

    if (_formState.validate()) {
      _formState.save();
      setState(() {
        yukleniyor = true;
      });
      try {
        await _yetkilendirmeServisi.sifremiSifirla(email);
        Navigator.pop(context);
      } catch (hata) {
        setState(() {
          yukleniyor = false;
        });
        //uyariGoster(hatakodu: hata.hashCode);
      }
    }
  }

  // uyariGoster({hatakodu}) {
  //   String? hataMesaji;

  //   if (hatakodu == "error-invalid-email") {
  //     hataMesaji = "Girdiğiniz mail adresi geçersizdir";
  //   } else if (hatakodu == "error-user-not-found") {
  //     hataMesaji = "Girdiğiniz mail kayitlidir";
  //   }
  //   //print(hataMesaji);
  //   // ScaffoldMessenger.of(context).showSnackBar(
  //   //   SnackBar(
  //   //     content: Text("$hataMesaji"),
  //   //     action: SnackBarAction(
  //   //       label: 'OK',
  //   //       onPressed: () {},
  //   //     ),
  //   //   ),
  //   // );
  //   //var alert = AlertDialog(content: Text(hataMesaji!));
  //   //var snackBar = SnackBar(content: Text(hataMesaji));
  //   _scaffoldAnahtari.currentState;
  // }
}
