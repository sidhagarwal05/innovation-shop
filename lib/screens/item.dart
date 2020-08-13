import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:innovtion/screens/loader.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;
int sort = 0;
bool open;
bool loader = true;
var document;
bool cartblock;
Map<String, int> cart = Map();
int finalprice;
int total = 0;
var hostel;
List<MessageBubble1> messageBubbles1 = [];
bool selected = true;
var id;
List<String> depts = [
  "None",
  "Hostel A",
  "Hostel B",
  "Hostel C",
  "Hostel D",
  "Hostel F",
  "Hostel FRA",
  "Hostel FRB",
  "Hostel FRC",
  "Hostel FRD",
  "Hostel FRE",
  "GIRLS Hostel (E,G,I,N)",
  "Hostel H",
  "Hostel J",
  "Hostel K",
  "Hostel L",
  "Hostel M",
  "Hostel PG",
  "New LIBRARY",
  "SBI",
];

class Item extends StatefulWidget {
  static const routeName = '/item';
  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> with SingleTickerProviderStateMixin {
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

  @override
  void dispose() {
    Loader.hide();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      document = ModalRoute.of(context).settings.arguments;
    });

    return Scaffold(
      floatingActionButton: GestureDetector(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                ' View Cart',
                style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.teal,
                border: Border.all(
                  color: Colors.teal,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
        ),
        onTap: () {
          messageBubbles1.removeRange(0, messageBubbles1.length);
          if (hostel == null && selected != false) {
            showDialog(
                context: context,
                child: AlertDialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: Text(
                    "TRY AGAIN",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: Text(
                    "Please Select Your Location",
                  ),
                  actions: <Widget>[
                    Align(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: RaisedButton(
                          color: Colors.teal,
                          child: Text(
                            "Ok",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          elevation: 2,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    )
                  ],
                ));
            print('Select Hostel');
          } else {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return StreamBuilder(
                      stream: Firestore.instance
                          .collection('Outlet')
                          .document('$document')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return new Text("Loading");
                        }
                        var userDocument = snapshot.data;
                        if (finalprice == 0 || finalprice == null) {
                          total = finalprice;
                        } else {
                          if (finalprice < 100 && selected == true) {
                            total = finalprice -
                                ((finalprice * userDocument['Discount']) / 100)
                                    .round() +
                                ((finalprice * userDocument['Tax']) / 100)
                                    .round() +
                                userDocument['Delivery Charge'];
                          } else {
                            total = finalprice -
                                ((finalprice * userDocument['Discount']) / 100)
                                    .round() +
                                ((finalprice * userDocument['Tax']) / 100)
                                    .round();
                          }
                        }

                        return new Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.teal,
                                child: Icon(
                                  Icons.shopping_cart,
                                  size: 40,
                                  color: Colors.black,
                                ),
                                radius: 30,
                              ),
//                      Text(
//                        'Cart',
//                        style: TextStyle(
//                          color: Colors.teal,
//                          fontSize: 40,
//                        ),
//                        textAlign: TextAlign.center,
//                      ),

                              MessagesStream1(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          loader == true
                                              ? 'Total Price: ₹ '
                                              : " ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          ),
                                        ),
                                        Text(
                                          finalprice.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ],
                                    ),
                                    userDocument['Discount'] > 0
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'Discount: ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17,
                                                  color: Colors.teal,
                                                ),
                                              ),
                                              Text(
                                                userDocument['Discount']
                                                    .toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17,
                                                  color: Colors.teal,
                                                ),
                                              ),
                                              Text(
                                                '%',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17,
                                                    color: Colors.teal),
                                              ),
                                            ],
                                          )
                                        : Container(),
                                    userDocument['Tax'] > 0
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'Tax: ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17,
                                                  color: Colors.teal,
                                                ),
                                              ),
                                              Text(
                                                userDocument['Tax'].toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17,
                                                  color: Colors.teal,
                                                ),
                                              ),
                                              Text(
                                                '%',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17,
                                                    color: Colors.teal),
                                              ),
                                            ],
                                          )
                                        : Container(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Delivery Charge: ₹ ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          ),
                                        ),
                                        Text(
                                          finalprice == null
                                              ? ""
                                              : finalprice < 100 &&
                                                      selected == true
                                                  ? userDocument[
                                                          'Delivery Charge']
                                                      .toString()
                                                  : '0',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Final Price: ₹ ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            color: Colors.deepOrange,
                                          ),
                                        ),
                                        Text(
                                          total.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            color: Colors.deepOrange,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    if (finalprice == 0 || finalprice == null) {
                                      showDialog(
                                          context: context,
                                          child: AlertDialog(
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            title: Text(
                                              "TRY AGAIN",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            content: Text(
                                              "Please add atleast 1 item to the cart",
                                            ),
                                            actions: <Widget>[
                                              Align(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: RaisedButton(
                                                    color: Colors.teal,
                                                    child: Text(
                                                      "Ok",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                    elevation: 2,
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ),
                                              )
                                            ],
                                          ));
                                      print('Select Hostel');
                                    } else {
                                      Navigator.of(context).pushNamed(
                                          Screen.routeName,
                                          arguments: messageBubbles1);
                                    }
                                  },
                                  child: Container(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Place Order',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    width: double.infinity,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.teal,
                                        border: Border.all(
                                          color: Colors.teal,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                          ),
                        );
                      });
                });
          }
          for (String key in cart.keys) {
            if (cart[key] > 0) {
              print(key);
            }
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 3,
        title: FittedBox(
          fit: BoxFit.contain,
          child: RichText(
            text: TextSpan(
                text: "It",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    letterSpacing: 1,
                    color: Colors.white),
                children: <TextSpan>[
                  TextSpan(
                      text: "ems",
                      style: TextStyle(
                          letterSpacing: 1,
                          fontSize: 35,
                          color: Colors.white,
                          fontFamily: "Sans Serif"))
                ]),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(
                        color: Colors.grey[300],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(Icons.motorcycle),
                                  Radio(
                                    onChanged: (value) {
                                      setState(() {
                                        selected = true;
                                      });
                                    },
                                    groupValue: true,
                                    value: selected,
                                    activeColor: Colors.teal,
                                  ),
                                  Text('Delivery'),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(Icons.redeem),
                                  Radio(
                                    onChanged: (value) {
                                      setState(() {
                                        selected = false;
                                      });
                                    },
                                    groupValue: false,
                                    value: selected,
                                    activeColor: Colors.teal,
                                  ),
                                  Text('Pick Up'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.teal,
                              border: Border.all(
                                color: Colors.teal[200],
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ),
                              DropdownButton(
                                underline: Container(
                                  color: Colors.tealAccent,
                                ),
                                iconSize: 0,
                                focusColor: Colors.teal[200],
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                                elevation: 2,
                                dropdownColor: Colors.blueGrey[900],
                                hint: Text(
                                  'Location',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ), // Not necessary for Option 1
                                value: hostel,
                                onChanged: (newValue) {
                                  setState(() {
                                    if (newValue == "None") {
                                      hostel = null;
                                    } else {
                                      hostel = newValue;
                                    }
                                  });
                                  print("hostel:" + hostel.toString());
                                },
                                items: depts.map((location) {
                                  return DropdownMenuItem(
                                    child: new Text(location),
                                    value: location,
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
      stream: _firestore.collection("Outlet/$document/Menu").snapshots(),
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
//        messageBubbles.removeRange(0, messageBubbles.length);
        for (var message in messages) {
          if (message.data['Available'] == true) {
            final name = message.data['Name'];
            final price = message.data['Price'];
            final imageurl = message.data['imageurl'];
            final foodid = message.documentID;
            cart[foodid] = 0;
            print(cart[foodid].toString() + '\n');
            final messageBubble = MessageBubble(
              name: name,
              price: price,
              image: imageurl,
              foodid: foodid,
            );
            messageBubbles.add(messageBubble);
          }
        }
        return Expanded(
          child: ListView(
            padding: EdgeInsets.only(top: 20, bottom: 60, left: 10, right: 10),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatefulWidget {
  MessageBubble({this.name, this.image, this.price, this.foodid});

  final String name;
  final price;
  final String image;
  final String foodid;
  int count = 0;
  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: widget.image == null
                        ? Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.005),
                            child: Container(
                              color: Colors.teal,
                              child: Image(
                                image: AssetImage('images/newlogo.png'),
                              ),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.005),
                            child: Image(
                              image: NetworkImage(widget.image),
                            ),
                          ),
                    color: Color.fromRGBO(255, 255, 255, 0.1),
                    width: MediaQuery.of(context).size.width * 0.20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.03),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(widget.name),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.01,
                        ),
                        Container(
                          child: Text('₹ ' + widget.price.toString()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Card(
              elevation: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.count--;
                        if (widget.count < 0) {
                          widget.count = 0;
                        }
                        if (widget.count > 4) {
                          widget.count = 4;
                        }
                        cart.update(widget.foodid, (value) => widget.count);
                        print(cart[widget.foodid].toString() + '\n');
                      });
                    },
                    child: Text(
                      '  -  ',
                      style: TextStyle(
                          backgroundColor: Colors.redAccent,
                          color: Colors.white,
                          fontSize: 25),
                    ),
                  ),
                  widget.count != 0
                      ? Text(
                          "   ${widget.count.toString()}   ",
                          style: TextStyle(
                              backgroundColor: Colors.white,
                              color: Colors.black,
                              fontSize: 25),
                        )
                      : Text(
                          widget.count == 0
                              ? '  Add  '
                              : widget.count.toString(),
                          style: TextStyle(
                              backgroundColor: Colors.white,
                              color: Colors.black,
                              fontSize: 20),
                        ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.count++;
                        if (widget.count < 0) {
                          widget.count = 0;
                        }
                        if (widget.count > 4) {
                          widget.count = 4;
                        }
                        cart.update(widget.foodid, (value) => widget.count);
                        print(cart[widget.foodid].toString() + '\n');
                      });
                    },
                    child: Text(
                      '  + ',
                      style: TextStyle(
                          backgroundColor: Colors.green,
                          color: Colors.white,
                          fontSize: 25),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

class MessagesStream1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection("Outlet/$document/Menu").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        final messages = snapshot.data.documents;
        finalprice = 0;
//

        for (var message in messages) {
          cart.forEach((key, value) {
            if (key == message.documentID && value > 0) {
              final name = message.data['Name'];
              final price = message.data['Price'];
              final imageurl = message.data['imageurl'];
              final foodid = message.documentID;
              final total = value * price;
              finalprice = finalprice + total;
              final messageBubble1 = MessageBubble1(
                name: name,
                price: price,
                image: imageurl,
                foodid: foodid,
                count: value,
                total: total,
              );
              messageBubbles1.add(messageBubble1);
            }
          });
        }
        return Expanded(
          child: ListView(
            padding: EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
            children: messageBubbles1,
          ),
        );
      },
    );
  }
}

class MessageBubble1 extends StatefulWidget {
  MessageBubble1(
      {this.name, this.image, this.price, this.foodid, this.count, this.total});

  final String name;
  final price;
  final total;
  final String image;
  final String foodid;
  int count;
  @override
  _MessageBubbleState1 createState() => _MessageBubbleState1();
}

class _MessageBubbleState1 extends State<MessageBubble1> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: widget.image == null
                        ? Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.005),
                            child: Container(
                              color: Colors.teal,
                              child: Image(
                                image: AssetImage('images/newlogo.png'),
                              ),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.005),
                            child: Image(
                              image: NetworkImage(widget.image),
                            ),
                          ),
                    color: Color.fromRGBO(255, 255, 255, 0.1),
                    width: MediaQuery.of(context).size.width * 0.15,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.03),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(widget.name),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.01,
                        ),
                        Container(
                          child: Text('₹ ' + widget.price.toString()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Text(
                  'x' + widget.count.toString(),
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                ),
                Text(
                  '₹ ' + widget.total.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
