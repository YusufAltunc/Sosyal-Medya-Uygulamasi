import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:provider/provider.dart';
import 'package:sosyal_medya/sayfalar/konusmasayfasi.dart';

class MesajSayfasi extends StatefulWidget {
  final String? profilSahibiId;
  const MesajSayfasi({super.key, this.profilSahibiId});

  @override
  State<MesajSayfasi> createState() => _MesajSayfasiState();
}

class _MesajSayfasiState extends State<MesajSayfasi> {
  final String userId = "7nWQ24790dapHfD18TcbZF9TlXs1";
  @override
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Mesajlar",
      theme: ThemeData(primaryColor: Theme.of(context).primaryColor),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Mesajlar"),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("mesajlar")
                .where("members", arrayContains: userId)
                .snapshots(),
            builder:
                ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.data == null) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading...");
              }

              //_profilSahibi = snapshot.data as Kullanici?;

              return ListView(
                children: snapshot.data!.docs
                    .map((doc) => ListTile(
                          // leading: CircleAvatar(
                          //   backgroundImage: NetworkImage(
                          //       "https://reqres.in/img/faces/8-image.jpg"),
                          // ),
                          title: Text("Oguz Baran"),
                          //doc["name"]doc["message"]
                          subtitle: Text(doc["displayMessage"]),
                          trailing: Column(
                            children: [
                              //Text("19:30"),
                              // Container(
                              //   width: 20,
                              //   height: 20,
                              //   margin: EdgeInsets.only(top: 8),
                              //   decoration: BoxDecoration(
                              //       shape: BoxShape.circle,
                              //       color: Colors.blue[800]),
                              //   child: Center(
                              //     child: Text(
                              //       "1",
                              //       textScaleFactor: 0.8,
                              //       style: TextStyle(
                              //           fontWeight: FontWeight.bold,
                              //           color: Colors.white),
                              //     ),
                              //   ),
                              // )
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) => KonusmaSayfasi(
                                          userId: userId,
                                          mesajId: doc.id,
                                        )));
                          },
                        ))
                    .toList(),
              );
            })),
      ),
    );
  }
}
