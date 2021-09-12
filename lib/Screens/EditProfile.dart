import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freelance_booking_app_service/Models/User.dart';
import 'package:freelance_booking_app_service/Providers/database.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String name = "", phoneNumber = "", imageUrl = "";
  bool isLoaded = false;

  _fetchData() async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    FirebaseFirestore.instance
        .collection("ServiceProviders")
        .doc(uid)
        .get()
        .then((value) {
      setState(() {
        name = value.data()["name"];
        phoneNumber = value.data()["number"];
        imageUrl = value.data()["image"];
        isLoaded = true;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return !isLoaded
        ? Scaffold(
            body: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                'Edit Profile',
                style: TextStyle(color: Colors.black),
              ),
              leading: BackButton(color: Colors.black),
              actions: [
                FlatButton(
                    onPressed: () {
                      DatabaseService()
                          .updateServiceProviderInfo(name, phoneNumber);
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Color(0xff5D5FEF)),
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Text('Save'),
                    ))
              ],
            ),
            body: SingleChildScrollView(
                child: Column(
              children: [
                SizedBox(
                  height: 50.0,
                ),
                Center(
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        margin: EdgeInsets.all(20.0),
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.fitHeight,
                            height: 150,
                            width: 150,
                            placeholder: (context, url) =>
                                new Image.asset('assets/doctor.png'),
                            errorWidget: (context, url, error) => new Stack(
                              fit: StackFit.expand,
                              children: [
                                Icon(Icons.hide_image, size: 40),
                                ClipRRect(
                                  // Clip it cleanly.
                                  child: Container(
                                    color: Colors.grey[100].withOpacity(0.1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.all(10.0),
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.blue, shape: BoxShape.circle),
                          child: Center(
                            child: IconButton(
                              onPressed: () {
                                print('functionality to be added');
                              },
                              icon: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  margin: EdgeInsets.all(20.0),
                  child: TextFormField(
                    initialValue: name,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: -20),
                        // hintText: 'Name',
                        hintStyle: TextStyle(fontSize: 12)),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      name = value;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20.0),
                  child: TextFormField(
                      initialValue: phoneNumber,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: -20),
                          // hintText: 'Phone Number',
                          hintStyle: TextStyle(fontSize: 12)),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your number';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        phoneNumber = value;
                      }),
                ),
              ],
            )),
          );
  }
}
