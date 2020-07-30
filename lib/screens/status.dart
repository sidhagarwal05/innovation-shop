import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innovtion/screens/base.dart';

var document;

class Status extends StatefulWidget {
  static const routeName = '/Status';

  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  @override
  Widget build(BuildContext context) {
    setState(() {
      document = ModalRoute.of(context).settings.arguments;
    });
    return new StreamBuilder(
        stream: Firestore.instance
            .collection('Order')
            .document(document)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Text("Loading");
          }
          var userDocument = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                GestureDetector(
                  child: Icon(
                    Icons.clear,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(Base.routeName);
                  },
                ),
              ],
              elevation: 0,
              backgroundColor: Colors.white,
              leading: Icon(
                Icons.clear,
                color: Colors.transparent,
              ),
            ),
            backgroundColor: Colors.white,
            body: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
//                  Align(
//                    child:
//                    alignment: Alignment.topRight,
//                  ),
                  Image(
                    image: AssetImage('images/23.jpg'),
                  ),
                  Text(
                    userDocument["Accepted"] == false ||
                            userDocument["Accepted"] == null
                        ? userDocument["Cancelled"] == false ||
                                userDocument["Cancelled"] == null
                            ? 'Waiting for the Restaurant to Accept the Order'
                            : "Order has been cancelled due to unavailability of item/ Restaurant has been closed"
                        : 'Order Accepted',
                    style: TextStyle(fontSize: 30, color: Colors.blue[700]),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  userDocument['deliveryTime'] == null ||
                          userDocument['deliveryTime'] == ""
                      ? Container()
                      : Text(
                          'Order will reach you in ${userDocument['deliveryTime']} minutes',
                          style: TextStyle(fontSize: 18),
                        )
                ],
              ),
            ),
          );
        });
  }
}
