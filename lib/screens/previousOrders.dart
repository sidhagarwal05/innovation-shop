import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;
int sort = 0;
String userId;
var reference;

class PreviousOrders extends StatefulWidget {
  static const routeName = '/previousOrders';

  @override
  _PreviousOrdersState createState() => _PreviousOrdersState();
}

class _PreviousOrdersState extends State<PreviousOrders>
    with SingleTickerProviderStateMixin {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String messageText;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        setState(() {
          userId = user.uid;
        });
        print('user:' + userId);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 5,
        title: FittedBox(
          fit: BoxFit.contain,
          child: RichText(
            text: TextSpan(
                text: "Previous",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    letterSpacing: 1,
                    color: Colors.white),
                children: <TextSpan>[
                  TextSpan(
                      text: " Orders",
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
      stream: _firestore
          .collection('Users/$userId/orders')
          .orderBy('Order Time', descending: true)
          .snapshots(),
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
          final order = message.data['order'];
          final price = message.data['Price'];
          final time = message.data['Order Time'];
          final outlet = message.data['Outlet'];
          final reference = message.data['reference'];
          print(" hi $order");
          final messageBubble = MessageBubble(
            price: price,
            order: order,
            time: time,
            outlet: outlet,
            reference: reference,
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
    this.order,
    this.price,
    this.time,
    this.outlet,
    this.reference,
  });

  final price;
  final order;
  final time;
  final reference;
  final outlet;
  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          reference = widget.reference;
        });
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return Column(
                children: <Widget>[
                  MessagesStream1(),
                  StreamBuilder(
                      stream: widget.reference.snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return new Text("Loading");
                        }
                        var userDocument = snapshot.data;
                        return Text(userDocument["Place"]);
                      }),
                ],
              );
            });
      },
      child: Card(
          color: Colors.white,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 8, left: 8, bottom: 15, right: 8),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      child: Text(
                        widget.order,
                        style: TextStyle(fontSize: 20),
                      ),
                      width: MediaQuery.of(context).size.width * 0.5,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    child: Text(
                      'Price ₹' + widget.price.toString(),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class MessagesStream1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: reference.collection("Item").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        final messages = snapshot.data.documents;

//
        List<MessageBubble1> messageBubbles1 = [];
        for (var message in messages) {
          final name = message.data['Name'];
          final price = message.data['Price'];
          final imageurl = message.data['image'];
          final quantity = message.data['Quantity'];
          final messageBubble1 = MessageBubble1(
            name: name,
            price: price,
            image: imageurl,
            quantity: quantity,
          );
          messageBubbles1.add(messageBubble1);
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
  MessageBubble1({this.name, this.image, this.price, this.quantity});

  final String name;
  final price;
  final String image;
  final quantity;
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
                        ? null
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Text(
                  'x' + widget.quantity.toString(),
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                ),
                Text(
                  '₹ ' + widget.price.toString(),
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
