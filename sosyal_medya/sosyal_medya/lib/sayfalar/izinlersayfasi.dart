import 'package:flutter/material.dart';

class Izinler extends StatefulWidget {
  const Izinler({super.key});

  @override
  State<Izinler> createState() => _IzinlerState();
}

class _IzinlerState extends State<Izinler> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cihaz İzinleri"),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text("Kamera"),
            subtitle: Text("İzin verildi"),
            trailing: Icon(Icons.check_circle),
          ),
          ListTile(
            title: Text("Bildirimler"),
            subtitle: Text("İzin verildi"),
            trailing: Icon(Icons.check_circle),
          ),
          ListTile(
            title: Text("Fotoğraflar"),
            subtitle: Text("İzin verildi"),
            trailing: Icon(Icons.check_circle),
          ),
        ],
      ),
    );
  }
}
