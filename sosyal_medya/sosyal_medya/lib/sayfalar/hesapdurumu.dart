import 'package:flutter/material.dart';
import 'package:sosyal_medya/modeller/kullanici.dart';

class HesapDurumu extends StatefulWidget {
  final Kullanici? profilIDyeni;
  const HesapDurumu({super.key, this.profilIDyeni});

  @override
  State<HesapDurumu> createState() => _HesapDurumuState();
}

class _HesapDurumuState extends State<HesapDurumu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hesap Durumu"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue[300],
                    radius: 50.0,
                    backgroundImage: widget.profilIDyeni!.fotoUrl!.isNotEmpty
                        ? NetworkImage(widget.profilIDyeni!.fotoUrl ?? '')
                        : const AssetImage("assets/images/limon.png")
                            as ImageProvider,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "${widget.profilIDyeni!.kullaniciAdi}",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 5.0),
                    child: Text(
                      "Hesabın veya içeriklerin kurallarımıza uymadığında uygulamanın gerçekleştirdiği işlemleri gör.",
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  ListTile(
                    leading: Icon(Icons.photo),
                    title: Text("Hesap Durumu"),
                    trailing: Icon(Icons.check_circle),
                  ),
                  ListTile(
                    leading: Icon(Icons.messenger_outline),
                    title: Text("Hesap Durumu"),
                    trailing: Icon(Icons.check_circle),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
