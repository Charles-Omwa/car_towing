
import 'package:cartowing/model/user_model.dart';
import 'package:cartowing/resources/firestore_provider.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'map.dart';

class Adduser extends StatefulWidget {
  @override
  _AdduserState createState() => _AdduserState();
}

class _AdduserState extends State<Adduser> {
  String selectedvalue;
  String locationName = 'Location';
  bool isLoading = false;
  UserModel user = UserModel(
      id: "", name: "", town: "", contact: "", longitude: 0, latitude: 0);
  static const town = <String>['Eldoret', 'Kisumu', 'Nairobi', 'Nakuru', 'Kericho', 'Mombasa'];
  final List<DropdownMenuItem<String>> _towns = town
      .map(
        (String value) => DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            ),
      )
      .toList();
  @override

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Toring Services')),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 88,
                  ),
                  Padding(padding: EdgeInsets.all(20)),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        user.name = value;
                      });
                    },
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                        labelText: 'Name',
                        hintText: 'Enter your name',
                        filled: true),
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        prefixIcon: Icon(MdiIcons.water)),
                    value: selectedvalue,
                    hint: Text('Town'),
                    items: _towns,
                    onChanged: ((String newvalue) {
                      setState(() {
                        selectedvalue = newvalue;

                        user.town = selectedvalue;
                      });
                    }),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.grey.shade100,
                    ),
                    height: 55,
                    child: RaisedButton(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.location_on),
                          Text(locationName)
                        ],
                      ),
                      onPressed: () async {
                        var loc = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Maps()));
                        if (loc != null) {
                          setState(() {
                            locationName = "${loc.latitude},${loc.longitude}";
                          });
                          user.latitude = loc.latitude;
                          user.longitude = loc.longitude;
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        user.contact = value;
                      });
                    },
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                        prefixText: '+254',
                        labelText: 'Contact',
                        hintText: '723874532',
                        filled: true),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    child: RaisedButton(
                      color: Colors.red.shade900,
                      child: isLoading
                          ? CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            )
                          : Text(
                              'Post service',
                              style: TextStyle(color: Colors.white),
                            ),
                      onPressed: () async {
                        if (user.name.isNotEmpty &&
                            user.town.isNotEmpty &&
                            user.contact.isNotEmpty &&
                            user.longitude != null &&
                            user.latitude != null) {
                          setState(() {
                            isLoading = true;
                          });
                          FirestoreProvider().addUser(user).then((response) => {
                                setState(() {
                                  isLoading = false;
                                }),
                                showSuccessDialog()
                              });
                        } else {
                          showErrorDialog();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  showErrorDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content:
                  Text('Enter the fields', style: TextStyle(color: Colors.red)),
              actions: <Widget>[
                FlatButton(
                  child: Text('ok'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
              title: Text('Error'));
        });
  }

  showSuccessDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: Text('Details submitted',
                  style: TextStyle(color: Colors.green)),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
              title: Text('Success'));
        });
  }
}
