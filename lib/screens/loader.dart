import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:innovtion/screens/status.dart' hide document;
import 'item.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

List<MessageBubble1> messageBubbles1 = [];
final _auth = FirebaseAuth.instance;
final _firestore = Firestore.instance;

class Screen extends StatefulWidget {
  static const routeName = '/screen';
  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Screen> {
  @override
  Widget build(BuildContext context) {
    Future<void> changeScreen() async {
      await sendData();
      Navigator.of(context).pushNamed(Status.routeName, arguments: id);
    }

    setState(() {
      messageBubbles1 = ModalRoute.of(context).settings.arguments;
    });

    changeScreen();
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Image(
              image: AssetImage('images/newlogo.png'),
            ),
          ),
          SpinKitWave(
            color: Colors.white,
            size: 50.0,
          ),
        ],
      ),
    );
  }
}

Future<bool> sendData() async {
  try {
    String order = "";
    for (int i = 1; i < messageBubbles1.length; i++) {
      order = order +
          messageBubbles1[i].name +
          " x " +
          messageBubbles1[i].count.toString() +
          ", ";
      if (i > 0) {
        if (messageBubbles1[0].name == messageBubbles1[i].name) {
          break;
        }
      }
    }
    print('$order');
    final uid = await _auth.currentUser().then((value) => value.uid);
    DocumentReference ref = await _firestore.collection("Order").add({
      'Accepted': false,
      'Order Time': DateTime.now(),
      'Outlet': _firestore.collection("Outlet").document(document),
      'Place': hostel,
      'Price': total,
      'User': _firestore.collection("Users").document(uid),
      'Delivery': selected
    });
    final doc = ref.documentID;
    id = doc;
    for (int i = 1; i < messageBubbles1.length; i++) {
      await _firestore.collection("Order/$doc/Item").add({
        'Name': messageBubbles1[i].name,
        'Quantity': messageBubbles1[i].count,
        'Price': messageBubbles1[i].price,
        'image': messageBubbles1[i].image,
        'reference': _firestore
            .collection("Outlet/document/Menu")
            .document(messageBubbles1[i].foodid),
      });
      if (i > 0) {
        if (messageBubbles1[0].name == messageBubbles1[i].name) {
          break;
        }
      }
    }
    await _firestore.collection("Users/$uid/orders").document("$doc").setData({
      'reference': _firestore.collection("Order").document("$doc"),
      'Outlet': _firestore.collection("Outlet").document("$document"),
      'order': order,
      'Price': total,
      'Order Time': DateTime.now(),
    });
    await _firestore
        .collection("Outlet/$document/orders")
        .document("$doc")
        .setData({
      'reference': _firestore.collection("Order").document("$doc"),
      'user': _firestore.collection("Users").document("$uid"),
      'order': order,
      'Price': total,
      'Order Time': DateTime.now(),
      'New': true,
    });

    return true;
  } catch (e) {
    print(e);
    print('please try again');
    return false;
  }
}
