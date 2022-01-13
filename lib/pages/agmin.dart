import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class adminPage extends StatefulWidget {
  const adminPage({Key? key}) : super(key: key);

  @override
  _adminPageState createState() => _adminPageState();
}

class _adminPageState extends State<adminPage> {
  createWordCard(message) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(100),
        onTap: () {
          debugPrint('Card tapped.');
        },
        child: SizedBox(
          width: 700,
          height: 500,
          child: Text(
            "$message",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    late TextEditingController wordController = TextEditingController();
    late TextEditingController meaningController = TextEditingController();
    CollectionReference wordCards =
        FirebaseFirestore.instance.collection('wordCards');
    return Scaffold(
      backgroundColor: Colors.indigoAccent,
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: Text("admin"),
      ),
      body: Center(
            child: Flex(
              crossAxisAlignment: CrossAxisAlignment.center,
              direction: Axis.vertical,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(30),
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: InkWell(
                        splashColor: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: 500.0,
                              height: 60.0,
                              child: TextField(
                                controller: wordController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                    ),
                                    labelText: 'word',
                                    hintText: 'add new word to cards'),
                              ),
                            ),
                            SizedBox(
                              width: 500.0,
                              height: 60.0,
                              child: TextField(
                                controller: meaningController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                  ),
                                  labelText: 'meaning',
                                  hintText: 'the word' 's meaning',
                                ),
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(16.0),
                                primary: Colors.blue,
                                textStyle: const TextStyle(fontSize: 20),
                              ),
                              onPressed: () async {
                                wordCards
                                    .add({
                                  'word': wordController.text,
                                  'meaning': meaningController.text,
                                })
                                    .then((value) => print("User Added"))
                                    .catchError((error) =>
                                    print("Failed to add user: $error"));
                                wordController.clear();
                                meaningController.clear();
                                setState(() {});
                              },
                              child: const Text('create card'),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<QuerySnapshot>(
                    future: wordCards.get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        Text("wrong");
                      }
                      if (snapshot.connectionState == ConnectionState.done) {
                        var docs = snapshot.data;
                        if (docs == null) {
                          Text("null data");
                        } else {
                          var data = docs.docs.length;
                          return ListView.separated(
                              scrollDirection: Axis.vertical,
                              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                              shrinkWrap: true,
                              itemCount: data,
                              itemBuilder:
                                  (BuildContext context, int wordIndex) {
                                return Card(
                                  color: Colors.deepPurple,
                                  child: InkWell(
                                    onTap: () async {
                                      String id = docs.docs[wordIndex].id;
                                      wordCards.doc(id).delete();
                                      setState(() {});
                                    },
                                    child: ListTile(
                                      title: Text(
                                        'word : ${docs.docs[wordIndex]['word']} meaning : ${docs.docs[wordIndex]['meaning']}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }, separatorBuilder: (BuildContext context, int index) => const Divider()
                          );
                        }
                      }
                      return Text("loading");
                    },
                  ),
                )
              ],
            ),
          ),
    );
  }
}
