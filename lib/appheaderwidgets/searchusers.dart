import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docbook/friendsandrequest/profilepage.dart';
import 'package:docbook/progress.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchUsers extends SearchDelegate<String> {
  String currentuser;

  SearchUsers(this.currentuser);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      )
    ];

  }


  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('Users')
            .where('name', isGreaterThanOrEqualTo: query)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
          if (!snap.hasData)
            return  Align(
              alignment: Alignment.topCenter,
              child: linearProgress(),
            );

          return ListView.builder(
              itemCount: snap.data.documents.length,
              scrollDirection: Axis.vertical,
              primary: false,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                DocumentSnapshot user = snap.data.documents[index];
                String userid = snap.data.documents[index].documentID;
                return Align(
                    alignment: Alignment.topCenter,
                    child: ListTile(
                            leading: ClipOval(
                              child: user['image']!=''?Image.network(user['image'],fit: BoxFit.cover,):Image.asset('assets/heart.gif',fit: BoxFit.cover,),
                            ),
                            title: Text(user['name'].toString().toUpperCase()),
                            subtitle: user['status']!=''?Text(user['status']):Text(''),

                            trailing: Icon(Icons.arrow_forward_ios),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage(userid)));

                      },
                          ),
                    );
              });
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('Users')
            .where('name', isGreaterThanOrEqualTo: query)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
          if (!snap.hasData)
            return Align(
              alignment: Alignment.topCenter,
              child: linearProgress(),
            );

          return ListView.builder(
              itemCount: snap.data.documents.length,
              scrollDirection: Axis.vertical,
              primary: false,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                DocumentSnapshot user = snap.data.documents[index];
                String userid = snap.data.documents[index].documentID;
                return Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Material(
                      elevation: 4,
                      child: InkWell(
                          onTap: (){

                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage(userid)));
                          },
                          child: ListTile(
                            leading: ClipOval(
                              child: user['image']!=''?Image.network(user['image'],fit: BoxFit.cover,):Image.asset('assets/heart.gif',fit: BoxFit.cover,),
                            ),
                            title: Text(user['name'].toString().toUpperCase()),
                            subtitle: user['status']!=''?Text(user['status']):Text(''),
                            trailing: Icon(Icons.arrow_forward_ios),
                          )),
                    )));
              });
        });
  }

}
