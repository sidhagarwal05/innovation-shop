import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;
int sort = 0;
String document;

class Item extends StatefulWidget {
  static const routeName = '/item';
  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> with SingleTickerProviderStateMixin {
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
  var _items = ['userprofile', 'logout'];

  @override
  Widget build(BuildContext context) {
    setState(() {
      document = ModalRoute.of(context).settings.arguments;
    });
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey[300],
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
        for (var message in messages) {
          final name = message.data['Name'];
          final price = message.data['Price'];
          final imageurl = message.data['imageurl'];
          final messageBubble = MessageBubble(
            name: name,
            price: price,
            image: imageurl,
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
    this.price,
  });

  final String name;
  final price;
  final String image;
  int count = 0;
  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    return Row(
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
                    print(widget.count.toString());
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
                      widget.count == 0 ? '  Add  ' : widget.count.toString(),
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
                    print(widget.count.toString());
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
    );
  }
}
