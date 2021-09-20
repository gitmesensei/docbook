import 'dart:async';

import 'package:flutter/material.dart';


class WebViewPage extends StatefulWidget {

  String link;


  WebViewPage(this.link);
  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebViewPage> {

  final _key = UniqueKey();
  bool _isLoadingPage;

  //Completer<WebViewController> _controller = Completer<WebViewController>();


  @override
  void initState() {
    super.initState();
    _isLoadingPage = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.lightBlue),
          automaticallyImplyLeading: true,
          elevation: 0,
    ),
      body: Container()
    );
  }
}
