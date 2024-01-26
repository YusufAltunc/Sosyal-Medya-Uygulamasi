import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
//import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_medya/servisler/yetkilendirmeservisi.dart';

class SifremiUnuttum extends StatefulWidget {
  const SifremiUnuttum({super.key});

  @override
  State<SifremiUnuttum> createState() => _SifremiUnuttumState();
}

class _SifremiUnuttumState extends State<SifremiUnuttum> {
  bool yukleniyor = false;
  final _formAnahtari = GlobalKey<FormState>();
  final _scaffoldAnahtari = GlobalKey<ScaffoldState>();
  late String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldAnahtari,
      appBar: AppBar(
        title: Text("Şifremi Sıfırla"),
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
                      height: 50.0,
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
  //   var alert = AlertDialog(content: Text(hataMesaji!));
  //   var snackBar = SnackBar(content: Text(hataMesaji));
  //   _scaffoldAnahtari.currentState;
  // }
}
