import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:innovtion/screens/base.dart';
import 'package:innovtion/screens/page.dart';

import 'item.dart';

var document;

class Status extends StatefulWidget {
  static const routeName = '/Status';

  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit this page'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(Page1.routeName),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      document = ModalRoute.of(context).settings.arguments;
    });
    return WillPopScope(
      onWillPop: _onWillPop,
      child: new StreamBuilder(
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
                      Navigator.of(context).pushNamed(Page1.routeName);
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
          }),
    );
  }
}
