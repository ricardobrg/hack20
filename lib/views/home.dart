import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter95/flutter95.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:hack20/widgets/alertDialog95.dart';

import 'channels.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home> {

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int repeat = 0;
  int du = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold95(
      title: "90s IRC",
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Button95(
              child: Image.asset("assets/img/du.png"),
                onTap: () => _handleSignIn()
            )
          ]
        )
      );
  }

  _handleSignIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    FirebaseUser firebaseUser = (await _auth.signInWithCredential(credential)).user;
    _loginAndgotoChannels(firebaseUser);
  }

  void _loginAndgotoChannels(FirebaseUser firebaseUser) {

    List dialWidgets = [
      Image.asset('assets/img/du1.png'),
      Image.asset('assets/img/du2.png'),
      Image.asset('assets/img/du3.png'),
      Image.asset('assets/img/du4.png'),
    ];

    StateSetter _setState;

    showDialog(
        context: context,
        builder: (BuildContext context){
      return AlertDialog95(
        title: "Conecting...",
        body: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            _setState = setState;
            return Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    dialWidgets[du],
                    Text("Connecting...")
                  ],
                )
            );
          })
      );
    });
    Future.delayed(Duration(milliseconds: 500), () =>
        firebaseUser == null ?
        AudioCache().play("assets/sound/dial-up-modem-busy.mp3") :
        AudioCache().play("assets/sound/dial-up-modem-01.mp3")
    );
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      if(repeat <= 3) {
        if(du == 4) {
          du = 0;
          repeat++;
        }
        _setState(() {
          du++;
        });
      }else{
        firebaseUser == null ?
          Navigator.of(context). pop() :
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Channels(user: firebaseUser)
          ));
        timer.cancel();
      }
    });
  }
}