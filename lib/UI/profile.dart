
import 'package:cartowing/model/user_model.dart';
import 'package:cartowing/resources/firebase_auth_provider.dart';
import 'package:cartowing/resources/firestore_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'basescreen.dart';
import 'editProfile.dart';
import 'home.dart';
import 'torermap.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  UserModel torer;
  Animation<double> animation;
  AnimationController animaitonController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    FirestoreProvider().getUser().then((d) {
      setState(() {
        torer = d;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : BaseScreen(
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(context);
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(
                                    MdiIcons.deleteForever,
                                    color: Colors.black,
                                  ),
                                  onPressed: () => showConfirmationDialog(
                                      title: 'Are you sure ?',
                                      body: 'You will no longer be torer',
                                      onYes: () async {
                                        FirebaseAuthProvider().logout();
                                        FirestoreProvider().delete();

                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Home()),
                                                (predicate) => false);
                                      })),
                              IconButton(
                                icon: Icon(
                                  MdiIcons.accountEdit,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditProfile(
                                                userModel: torer,
                                              )));
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Your Profile',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic)),
                            SizedBox(width: 0.0, height: 0.0),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(14),
                                child: Text(
                                  'Name: ${torer.name}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                      // fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  'Phone: ${torer.contact}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 17),
                                ),
                              ),
                            ],
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 5),
                              ),
                              Container(
                                alignment: Alignment.center,
                                // color: Colors.green,
                                child: Icon(
                                  MdiIcons.circle,
                                  color: Colors.yellow,
                                  size: 220,
                                ),
                              ),
                              Text(
                                '${torer.town}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      ),
                      Card(
                          child: Container(
                              child: Column(
                        children: <Widget>[
                          Text(
                            'User Location:',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          TorerMap(
                            isNotExitable: true,
                            toreLocation:
                                LatLng(torer.latitude, torer.longitude),
                            height: 140,
                            width: 350,
                          ),
                        ],
                      )))
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  showConfirmationDialog({
    String title,
    String body,
    VoidCallback onYes,
  }) {
    showDialog(
        context: context,
        builder: (c) {
          return AlertDialog(title: Text(title), content: Text(body), actions: [
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "No",
                style: TextStyle(color: Colors.green),
              ),
            ),
            FlatButton(
              onPressed: onYes,
              child: Text(
                "Yes",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ]);
        });
  }
}
