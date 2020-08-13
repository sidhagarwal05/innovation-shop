import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:innovtion/screens/item.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;
int sort = 0;
PageController pageController;

class Base extends StatefulWidget {
  static const routeName = '/base-screen';

  @override
  _BaseState createState() => _BaseState();
}

class _BaseState extends State<Base> with SingleTickerProviderStateMixin {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String messageText;

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

//  String dropdownValue = '';
//  var _items = [
//    'Previous Orders',
//    'userprofile',
//    'logout',
//  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
//              Row(
//                mainAxisAlignment: MainAxisAlignment.end,
//                children: <Widget>[
//                  DropdownButton(
//                    underline: Container(),
//                    onChanged: (value) async {
//                      setState(() {
//                        dropdownValue = value;
//                      });
//                      if (dropdownValue == 'logout') {
//                        final signoutResult = await Auth().signOut();
//                        if (signoutResult) {
//                          Navigator.of(context)
//                              .pushReplacementNamed(HomeScreen.routeName);
//                        }
//                      }
//                      if (dropdownValue == 'userprofile') {
//                        Navigator.of(context).pushNamed(
//                            UserInfoScreen.routeName,
//                            arguments: true);
//                      }
//                      if (dropdownValue == 'Previous Orders') {
//                        Navigator.of(context)
//                            .pushNamed(PreviousOrders.routeName);
//                      }
//                    },
//                    icon: Icon(
//                      Icons.person,
//                      color: Colors.teal,
//                      size: 40,
//                    ),
//                    items: _items.map((e) {
//                      return DropdownMenuItem(
//                        child: Text(e),
//                        value: e,
//                      );
//                    }).toList(),
//                  ),
//                ],
//              ),
              SizedBox(
                height: 20,
              ),
              Center(
                  child: Text(
                "Restaurants",
                style: TextStyle(
                    color: Colors.teal,
                    fontSize: 50,
                    fontWeight: FontWeight.bold),
              )),
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
          if (message.data['status'] == true) {
            final name = message.data['name'];
            final image = message.data['image'];
            final minimumPrice = message.data['Minimum Order'];
            final discount = message.data['Discount'];
            final deliveryCharge = message.data['Delivery Charge'];
            final document = message.documentID;
            final messageBubble = MessageBubble(
              name: name,
              image: image,
              document: document,
              deliveryCharge: deliveryCharge,
              discount: discount,
              minimum: minimumPrice,
            );
            messageBubbles.add(messageBubble);
          }
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
    this.deliveryCharge,
    this.discount,
    this.minimum,
  });
  final String name;
  final String image;
  final String document;
  final deliveryCharge;
  final minimum;
  final discount;
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 5,
            ),
            Container(
              color: Colors.transparent,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    child: widget.image == null
                        ? null
                        : Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.005),
                            child: Image(
                              image: NetworkImage(widget.image),
                              width: MediaQuery.of(context).size.width * 0.20,
                              height: MediaQuery.of(context).size.width * 0.20,
                            ),
                          ),
                    color: Color.fromRGBO(255, 255, 255, 0.1),
                    width: MediaQuery.of(context).size.width * 0.20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.name,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Free Delivery on orders above ₹" +
                              widget.minimum.toString(),
                          style: TextStyle(color: Colors.teal),
                        ),
                        widget.discount > 0
                            ? Text(
                                widget.discount.toString() + "% " + "Discount",
                                style: TextStyle(
                                  color: Colors.deepOrange,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
