//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class KonusmaSayfasi extends StatefulWidget {
  final String userId;
  final String mesajId;
  const KonusmaSayfasi(
      {super.key, required this.userId, required this.mesajId});

  @override
  State<KonusmaSayfasi> createState() => _KonusmaSayfasiState();
}

class _KonusmaSayfasiState extends State<KonusmaSayfasi> {
  final TextEditingController _editingController = TextEditingController();
  late CollectionReference _ref;

  @override
  void initState() {
    _ref = FirebaseFirestore.instance
        .collection("mesajlar/${widget.mesajId}/messages");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: -5,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  NetworkImage("https://reqres.in/img/faces/8-image.jpg"),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text("Oguz Baran"),
            )
          ],
        ),
        //sohbet yerinde sag tarafa ıconları koymustum suan kullanmıyorum
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              onTap: () {},
              child: Icon(Icons.phone),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              onTap: () {},
              child: Icon(Icons.camera_alt),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              onTap: () {},
              child: Icon(Icons.more_vert),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage("http://placekitten.com/600/800"))),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: _ref.orderBy("timeStamp").snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    return !snapshot.hasData
                        ? Center(child: CircularProgressIndicator())
                        : ListView(
                            children: snapshot.data!.docs
                                .map((doc) => ListTile(
                                      title: Align(
                                          alignment: widget.userId !=
                                                  doc["senderId"]
                                              ? Alignment.centerLeft
                                              : Alignment.centerRight,
                                          child: Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  borderRadius:
                                                      BorderRadius.horizontal(
                                                          left: Radius.circular(
                                                              10),
                                                          right:
                                                              Radius.circular(
                                                                  10))),
                                              child: Text(
                                                doc["message"],
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ))),
                                    ))
                                .toList(),
                          );
                  }),
            ),
            Row(
              children: [
                Expanded(
                    child: Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(25),
                        right: Radius.circular(25),
                      )),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          child: Icon(
                            Icons.tag_faces,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _editingController,
                          decoration: InputDecoration(
                              hintText: "Type a Message",
                              border: InputBorder.none),
                        ),
                      ),
                      InkWell(
                        child: Icon(
                          Icons.attach_file,
                          color: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    ],
                  ),
                )),
                Container(
                  margin: EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () async {
                      await _ref.add({
                        "senderId": widget.userId,
                        "message": _editingController.text,
                        "timeStamp": DateTime.now(),
                      });
                      _editingController.text = "";
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

/*
ListTile(
                          title: Align(
                              alignment: index % 2 == 0
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular(10),
                                          right: Radius.circular(10))),
                                  child: Text(
                                    "Deneme Mesajı",
                                    style: TextStyle(color: Colors.white),
                                  ))),
                        )

*/
