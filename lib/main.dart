import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  // Import JSON file from URL & Store it in a object with values as per our requirement.

  Future<List<User>> _getData() async {
    var data = await http.get(
        "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=2020-08-08&minmagnitude=2");
    var jsonData = json.decode(data.body);

    List<User> users = [];
    for (var u in jsonData['features']) {
      if (u['properties']['mag'] >= 2) {
        User user = User(
            u['properties']['place'],
            u['properties']['mag'],
            u['properties']['type'],
            u['properties']['title']);
        users.add(user);
      } else {}
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('EarthQuake'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Container(
        child: FutureBuilder(
          future: _getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: SpinKitRotatingCircle(
                    color: Colors.teal
                  ),
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(top: 2.0, right: 2, left: 2),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text('Title'),
                                      Text('Place'),
                                      Text('Type'),
                                      Text('Magnitude'),
                                    ],
                                  ),
                                  SizedBox(width: 15),
                                  Container(
                                    width: 300,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('${snapshot.data[index].title}'),
                                        Text('${snapshot.data[index].place}'),
                                        Text('${snapshot.data[index].type}'),
                                        Text(
                                            '${snapshot.data[index].mag.toString()}'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }
          },
        ),
      ),
    );
  }
}


// Create a class that
class User {
  final String place;
  final String type;
  var mag;
  final String title;

  User(this.place, this.mag, this.type, this.title);
}
