import 'package:flutter/material.dart';

class MyCourses extends StatefulWidget {
  @override
  _MyCoursesState createState() => _MyCoursesState();
}

class _MyCoursesState extends State<MyCourses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.lightBlue),
        automaticallyImplyLeading: true,
        elevation: 0,
        title: Text('My Courses',style: TextStyle(color: Colors.lightBlue),),
      ),
    );
  }
}
