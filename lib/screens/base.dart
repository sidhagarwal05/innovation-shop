import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:innovtion/screens/item.dart';
import 'package:innovtion/screens/user_info.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../providers/auth.dart';
import 'home.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;
int sort = 0;

class Base extends StatefulWidget {
  static const routeName = '/base-screen';

  @override
  _BaseState createState() => _BaseState();
}

class _BaseState extends State<Base> with SingleTickerProviderStateMixin {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String messageText;

  AnimationController _animationController;
  Animation<double> _animation;
  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInCirc);
    _animation.addListener(() => this.setState(() {}));
    _animationController.forward();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  String dropdownValue = '';
  var _items = [
    'userprofile',
    'logout',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.yellowAccent,
        elevation: 0,
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              DropdownButton(
                underline: Container(),
                onChanged: (value) async {
                  setState(() {
                    dropdownValue = value;
                  });
                  if (dropdownValue == 'logout') {
                    final signoutResult = await Auth().signOut();
                    if (signoutResult) {
                      Navigator.of(context)
                          .pushReplacementNamed(HomeScreen.routeName);
                    }
                  }
                  if (dropdownValue == 'userprofile') {
                    Navigator.of(context)
                        .pushNamed(UserInfoScreen.routeName, arguments: true);
                  }
                },
                icon: Icon(
                  Icons.access_alarm,
                ),
                items: _items.map((e) {
                  return DropdownMenuItem(
                    child: Text(e),
                    value: e,
                  );
                }).toList(),
              ),
            ],
          ),
        ],
        title: FittedBox(
          fit: BoxFit.contain,
          child: RichText(
            text: TextSpan(
                text: "It",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    letterSpacing: 1,
                    color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text: "ems",
                      style: TextStyle(
                          letterSpacing: 1,
                          fontSize: 35,
                          color: Colors.grey[500],
                          fontFamily: "Sans Serif"))
                ]),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MessagesStream(),
            ],
          ),
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('Outlet').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.documents;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final name = message.data['name'];
          final image = message.data['image'];
          final document = message.documentID;
          final messageBubble = MessageBubble(
            name: name,
            image: image,
            document: document,
          );
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatefulWidget {
  MessageBubble({
    this.name,
    this.image,
    this.document,
  });

  final String name;
  final String image;
  final String document;

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(Item.routeName, arguments: widget.document);
      },
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey[300],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            color: Colors.transparent,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.image),
                  backgroundColor: Colors.transparent,
                  radius: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Container(
                    child: Text(widget.name),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
