import 'package:firestore_city_demo/event_details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var db = Firestore.instance;
  TextEditingController seachCityControleller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 40.0,
              left: 8.0,
              right: 8.0,
              bottom: 8.0,
            ),
            child: TextField(
              onChanged: (value) {
                // filterSearchResults(value);
              },
              controller: seachCityControleller,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                labelText: "Search",
                hintText: "Search City",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
            ),
          ),
          populateCityData(),
        ],
      )),
    );
  }

  Widget populateCityData() {
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 10,
        right: 10,
      ),
      child: StreamBuilder<QuerySnapshot>(
        //to get the snapshot of the documents
        stream: db.collection("cities").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data.documents);
            //  return  Text('hello harsh');

            return Column(
                children: snapshot.data.documents
                    .map(
                      (doc) => Card(
                        elevation: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blue,
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      EventDetails(
                                    doc.data['city_name'],
                                    doc.documentID,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.only(
                                top: 20,
                                bottom: 20,
                              ),
                              child: Text(
                                doc.data['city_name'],
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList());
          } else {
            return SizedBox();
          }
          // print(snapshot.data.documents);
          // return  Text('hello harsh');
        },
      ),
    );
  }
}
