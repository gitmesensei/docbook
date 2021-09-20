import 'package:flutter/material.dart';


class Notify extends StatefulWidget {
  @override
  _NotifyState createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.lightBlue),
        automaticallyImplyLeading: true,
        elevation: 0,
        title: Text('Notifications',style: TextStyle(color: Colors.lightBlue),),
      ),
    );
  }
}
