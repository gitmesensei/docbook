import 'package:docbook/feedpagecomp/posts/addnewposts.dart';
import 'package:docbook/learn/mycourses.dart';
import 'package:docbook/settings.dart';
import 'package:docbook/onboardingcomp/intropage.dart';
import 'package:docbook/onboardingcomp/splash.dart';
import 'package:docbook/chatpagecomp/userchats.dart';
import 'package:docbook/shopcomp/shoppage.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:dynamic_theme/theme_switcher_widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unicorndial/unicorndial.dart';
import 'profilecomp/edit_profile.dart';
import 'friendsandrequest/friends&request.dart';
import 'feedpagecomp/news/news.dart';
import 'learn/learnpage.dart';
import 'profilecomp/currentprofilepage.dart';
import 'feedpagecomp/homepage.dart';
import 'package:flutter/material.dart';
import 'customIcons.dart';
import 'dart:ui';
import 'appheaderwidgets/searchusers.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    ));
  });
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  MyApp({this.icons, this.onIconTapped});
  final List<IconData> icons;
  ValueChanged<int> onIconTapped;
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  int bottomSelectedIndex = 0;

  PageController pageController = PageController(
    initialPage: 0,
  );
  FirebaseUser currentuser;

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        HomePage(),
        LearnPage(),
        FirstPage(),
        FourthPage(),
      ],
    );
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 100), curve: Curves.easeIn);
    });
  }

  void _loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        this.currentuser = user;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    var childButtons = List<UnicornButton>();
    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
      heroTag: "learn",
      elevation: 10,
      backgroundColor: Colors.redAccent,
      mini: true,
      child: Icon(
        Icons.local_library,
        size: 30,
      ),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyCourses()));
      },
    )));

    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
      heroTag: "shop",
      elevation: 10,
      backgroundColor: Colors.greenAccent,
      mini: true,
      child: Icon(
        Icons.shopping_cart,
        size: 30,
      ),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ShopPage()));
      },
    )));

    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
      backgroundColor: Colors.blueAccent,
      mini: true,
      elevation: 10,
      child: Icon(
        Icons.edit,
        size: 30,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddPost()),
        );
      },
    )));

    return Container(
        //color: Colors.white,
        child: SafeArea(
            bottom: true,
            child: Scaffold(
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                bottomNavigationBar: new BottomAppBar(
                  elevation: 0,
                  shape: CircularNotchedRectangle(),
                  notchMargin: -10.0,
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        iconSize: 25.0,
                        padding: EdgeInsets.only(left: 28.0),
                        icon: Icon(
                          FontAwesomeIcons.clinicMedical,
                          color: bottomSelectedIndex == 0
                              ? Colors.pinkAccent
                              : Colors.lightBlue,
                        ),
                        onPressed: () {
                          setState(() {
                            bottomSelectedIndex = 0;
                            pageController.animateToPage(0,
                                duration: Duration(milliseconds: 100),
                                curve: Curves.easeIn);
                          });
                        },
                      ),
                      IconButton(
                        iconSize: 25.0,
                        padding: EdgeInsets.only(right: 28.0),
                        icon: Icon(
                          FontAwesomeIcons.bookMedical,
                          color: bottomSelectedIndex == 1
                              ? Colors.pinkAccent
                              : Colors.lightBlue,
                        ),
                        onPressed: () {
                          setState(() {
                            bottomSelectedIndex = 1;
                            pageController.animateToPage(1,
                                duration: Duration(milliseconds: 100),
                                curve: Curves.easeIn);
                          });
                        },
                      ),
                      IconButton(
                        iconSize: 25.0,
                        padding: EdgeInsets.only(left: 28.0),
                        icon: Icon(
                          FontAwesomeIcons.userFriends,
                          color: bottomSelectedIndex == 2
                              ? Colors.pinkAccent
                              : Colors.lightBlue,
                        ),
                        onPressed: () {
                          setState(() {
                            bottomSelectedIndex = 2;
                            pageController.animateToPage(2,
                                duration: Duration(milliseconds: 100),
                                curve: Curves.easeIn);
                          });
                        },
                      ),
                      IconButton(
                        iconSize: 25.0,
                        padding: EdgeInsets.only(right: 28.0),
                        icon: Icon(
                          FontAwesomeIcons.userGraduate,
                          color: bottomSelectedIndex == 3
                              ? Colors.pinkAccent
                              : Colors.lightBlue,
                        ),
                        onPressed: () {
                          setState(() {
                            bottomSelectedIndex = 3;
                            pageController.animateToPage(3,
                                duration: Duration(milliseconds: 100),
                                curve: Curves.easeIn);
                          });
                        },
                      )
                    ],
                  ),
                ),
                floatingActionButton: Container(
                  width: 224.0,
                  height: 300.0,
                  child: UnicornDialer(
                      hasNotch: true,
                      //hasBackground: false,
                      backgroundColor: Color.fromRGBO(255, 255, 255, 0.0),
                      parentButtonBackground: Colors.pinkAccent,
                      orientation: UnicornOrientation.VERTICAL,
                      parentButton: Icon(Icons.add),
                      childButtons: childButtons),
                ),
                body: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverAppBar(
                          floating: true,
                          pinned: true,
                          automaticallyImplyLeading: false,
                          snap: true,
                          backgroundColor: Theme.of(context).canvasColor,
                          title: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    CustomIcons.menu,
                                    color: Colors.lightBlue,
                                    size: 30.0,
                                  ),
                                  onPressed: () {
                                    _settingModalBottomSheet(context);
                                  },
                                ),
                                Row(
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(
                                        Icons.search,
                                        color: Colors.lightBlue,
                                        size: 30.0,
                                      ),
                                      onPressed: () {
                                        showSearch(
                                            context: context,
                                            delegate: SearchUsers(
                                                currentuser.uid.toString()));
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.notifications_none,
                                        color: Colors.lightBlue,
                                        size: 30.0,
                                      ),
                                      onPressed: () {
                                        //Navigator.push(context, MaterialPageRoute(builder: (context) => Notify()),);
                                        showChooser();
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.chat,
                                        color: Colors.lightBlue,
                                        size: 30.0,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UserChats()),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                      ];
                    },
                    body: Container(
                      child: buildPageView(),
                    )))));
  }

  void showChooser() {
    showDialog<void>(
        context: context,
        builder: (context) {
          return BrightnessSwitcherDialog(
            onSelectedTheme: (brightness) {
              DynamicTheme.of(context).setBrightness(brightness);
            },
          );
        });
  }
}

void _settingModalBottomSheet(context) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          color: Colors.black54,
          child: new Container(
            height: 400,
            alignment: Alignment(0, 0),
            child: _elementsOfBottomSheet(context),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
                shape: BoxShape.rectangle,
                color: Colors.white),
          ),
        );
      });
}

ListView _elementsOfBottomSheet(context) {
  return ListView(
    scrollDirection: Axis.vertical,
    children: <Widget>[
      new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Center(
                child: Container(
                    height: 300,
                    width: 500,
                    margin: EdgeInsets.only(top: 50, left: 20, right: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.lightBlue,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 1.0,
                              color: Colors.black12,
                              spreadRadius: 2.0)
                        ])),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 15.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.lightBlue,
                      border: Border.all(
                          width: 2.0,
                          color: Colors.white,
                          style: BorderStyle.solid),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 1.0,
                            color: Colors.black12,
                            spreadRadius: 4.0)
                      ]),
                  child: ImageIcon(
                    new AssetImage('assets/logo.png'),
                    color: Colors.white,
                    size: 70.2,
                  ),
                ),
              ),
              Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 120,
                    height: 40,
                    margin: EdgeInsets.only(right: 165, top: 100),
                    child: FlatButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfile()),
                          );
                        },
                        color: Colors.lightBlue,
                        padding: EdgeInsets.only(left: 7),
                        icon: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        label: Text(
                          'profile',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                  ),
                  Container(
                      width: 120,
                      height: 40,
                      margin: EdgeInsets.only(right: 170, top: 10.0),
                      child: FlatButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewsShow()),
                            );
                          },
                          color: Colors.lightBlue,
                          padding: EdgeInsets.only(left: 1),
                          icon: Icon(
                            Icons.local_library,
                            color: Colors.white,
                          ),
                          label: Text(
                            'news',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ))),
                  Container(
                      width: 160,
                      height: 40,
                      margin: EdgeInsets.only(
                        right: 130,
                        top: 10.0,
                      ),
                      child: FlatButton.icon(
                          onPressed: () {},
                          color: Colors.lightBlue,
                          icon: Icon(
                            Icons.favorite,
                            color: Colors.white,
                          ),
                          label: Text(
                            'favourites',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ))),
                  Container(
                      width: 120,
                      height: 40,
                      margin: EdgeInsets.only(right: 165, top: 10.0),
                      child: FlatButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Settings()),
                            );
                          },
                          color: Colors.lightBlue,
                          icon: Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.only(left: 16),
                          label: Text(
                            'settings',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ))),
                  Container(
                      width: 120,
                      height: 40,
                      margin: EdgeInsets.only(left: 210, right: 30),
                      child: FlatButton.icon(
                          onPressed: () {
                            LinearProgressIndicator();
                            FirebaseAuth.instance.signOut();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => IntroPage()),
                            );
                          },
                          color: Colors.lightBlue,
                          icon: Icon(
                            Icons.exit_to_app,
                            color: Colors.white,
                          ),
                          label: Text(
                            'logout',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ))),
                ],
              ))
            ],
          )
        ],
      ),
    ],
  );
}
