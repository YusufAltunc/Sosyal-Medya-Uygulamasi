//import 'package:flutter/gestures.dart';
import 'package:flutter/src/widgets/framework.dart';
//import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_medya/modeller/kullanici.dart';
import 'package:sosyal_medya/servisler/firestoreservisi.dart';
import 'package:sosyal_medya/servisler/yetkilendirmeservisi.dart';

class HesapOlustur extends StatefulWidget {
  const HesapOlustur({super.key});

  @override
  State<HesapOlustur> createState() => _HesapOlusturState();
}

class _HesapOlusturState extends State<HesapOlustur> {
  bool yukleniyor = false;
  final _formAnahtari = GlobalKey<FormState>();
  final _scaffoldAnahtari = GlobalKey<ScaffoldState>();
  late String kullaniciAdi, email, sifre;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldAnahtari,
      appBar: AppBar(
        title: Text("Hesap Oluştur"),
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
                    TextFormField(
                      autocorrect: true,
                      decoration: InputDecoration(
                        hintText: "Kullanıcı adınızı girin",
                        labelText: "Kullanıcı Adı:",
                        errorStyle: TextStyle(fontSize: 16.0),
                        prefix: Icon(Icons.person),
                      ),
                      validator: (girienDeger) {
                        if (girienDeger!.isEmpty) {
                          return "Kullanıcı adı boş bırakılamaz";
                        } else if (girienDeger.trim().length < 4 ||
                            girienDeger.trim().length > 10) {
                          return "En az 4 en fazla 10 karakter olabilir!";
                        }
                        return null;
                      },
                      onSaved: (girilenDeger) => kullaniciAdi = girilenDeger!,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Email adresinizi girin",
                        labelText: "Mail:",
                        errorStyle: TextStyle(fontSize: 16.0),
                        prefix: Icon(Icons.mail),
                      ),
                      validator: (girienDeger) {
                        if (girienDeger!.isEmpty) {
                          return "Email alanı boş bırakılamaz";
                        } else if (!girienDeger.contains("@")) {
                          return "Girilen değer mail formatında olmalı!";
                        }
                        return null;
                      },
                      onSaved: (girilenDeger) => email = girilenDeger!,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Şifrenizi girin",
                        labelText: "Şifre:",
                        errorStyle: TextStyle(fontSize: 16.0),
                        prefix: Icon(Icons.lock),
                      ),
                      validator: (girienDeger) {
                        if (girienDeger!.isEmpty) {
                          return "Şifre alanı boş bırakılamaz";
                        } else if (girienDeger.trim().length < 4) {
                          return "Şifre 4 karakterden az olamaz";
                        }
                        return null;
                      },
                      onSaved: (girilenDeger) => sifre = girilenDeger!,
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    Container(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: _kullaniciOlustur,
                        child: Text(
                          "Hesap Oluştur",
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

  void _kullaniciOlustur() async {
    final _yetkilendirmeServisi =
        Provider.of<YetkilendirmeServisi>(context, listen: false);

    var _formState = _formAnahtari.currentState!;

    if (_formState.validate()) {
      _formState.save();
      setState(() {
        yukleniyor = true;
      });
      try {
        Kullanici? kullanici =
            await _yetkilendirmeServisi.mailIleKayit(email, sifre);
        if (kullanici != null) {
          FireStoreServisi().kullaniciOlustur(
              id: kullanici.id, email: email, kullaniciAdi: kullaniciAdi);
        }
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

  //   if (hatakodu == "invalid-email") {
  //     hataMesaji = "Girdiğiniz mail adresi geçersizdir";
  //   } else if (hatakodu == "email-already-in-use") {
  //     hataMesaji = "Girdiğiniz mail kayitlidir";
  //   } else if (hatakodu == "weak-password") {
  //     hataMesaji = "Daha zor bir şifre tercih edin";
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
  //   var alert = AlertDialog(content: Text(hataMesaji!));
  //   var snackBar = SnackBar(content: Text(hataMesaji));
  //   _scaffoldAnahtari.currentState;
  // }
}
