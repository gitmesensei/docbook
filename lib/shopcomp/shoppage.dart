import 'dart:ui';

import 'package:flutter/material.dart';

class ShopPage extends StatefulWidget {
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = new TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Theme.of(context).brightness==Brightness.dark?Colors.black:Colors.white,
      body: ListView(
        padding: EdgeInsets.only(bottom: 50),
        children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: 250.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage('assets/shopback.jpg'),fit: BoxFit.cover)
                    ),
                  ),

                  BackdropFilter(filter: ImageFilter.blur(sigmaX: 0.5,sigmaY: 0.5),
                    child: Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.45)),),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 15.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(
                              width: MediaQuery.of(context).size.width - 120.0),
                          Container(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: Icon(Icons.shopping_cart),
                              onPressed: () {},
                              color: Colors.white,
                              iconSize: 30.0,
                            ),
                          ),
                          SizedBox(height: 15.0),
                        ],
                      ),
                      SizedBox(height: 50.0),
                      Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text(
                          'Hello',
                          style: TextStyle(
                              fontFamily: 'Quicksand',
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          'What do you want to buy?',
                          style: TextStyle(
                              fontFamily: 'Quicksand',
                              color: Colors.white,
                              fontSize: 23.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 25.0),
                      Padding(
                        padding: EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(5.0),
                          color: Colors.lightBlue.shade200,
                          child: TextFormField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: Icon(Icons.search,
                                      color: Colors.white,
                                      size: 30.0),
                                  contentPadding:
                                  EdgeInsets.only(left: 15.0, top: 15.0),
                                  hintText: 'Search',
                                  hintStyle: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Quicksand'))),
                        ),
                      ),
                      SizedBox(height: 10.0)
                    ],
                  )
                ],
              ),
              SizedBox(height: 10.0),
              Stack(
                children: <Widget>[
                  SizedBox(height: 10.0),
                  Material(
                      elevation: 1.0,
                      child: Container(height: 75.0, color: Colors.white)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        height: 75.0,
                        width: MediaQuery.of(context).size.width / 4,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 50.0,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/books.jpg'))),
                            ),
                            Text(
                              'Books',
                              style: TextStyle(fontFamily: 'Quicksand'),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 75.0,
                        width: MediaQuery.of(context).size.width / 4,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 50.0,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                      AssetImage('assets/accessories.jpg'),)),
                            ),
                            Text(
                              'accessories',
                              style: TextStyle(fontFamily: 'Quicksand'),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 75.0,
                        width: MediaQuery.of(context).size.width / 4,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 50.0,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/clothes.jpg'))),
                            ),
                            Text(
                              'clothes',
                              style: TextStyle(fontFamily: 'Quicksand'),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 75.0,
                        width: MediaQuery.of(context).size.width / 4,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 50.0,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                      AssetImage('assets/equipment.jpg'))),
                            ),
                            Text(
                              'equipment',
                              style: TextStyle(fontFamily: 'Quicksand'),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
          itemCard('Book', 'assets/books.jpg', false),
          itemCard('Equipment', 'assets/equipment.jpg', false),






        ],
      ),
    );
  }

  Widget itemCard(String title, String imgPath, bool isFavorite) {
    return InkWell(
        //onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductPage())),
        child:Padding(
          padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
          child: Container(
            height: 150.0,
            width: double.infinity,
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Container(
                  width: 140.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(imgPath), fit: BoxFit.cover)),
                ),
                SizedBox(width: 4.0),
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          title,
                          style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 45.0),
                        Material(
                          elevation: isFavorite ? 0.0 : 2.0,
                          borderRadius: BorderRadius.circular(20.0),
                          child: Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: isFavorite
                                    ? Colors.grey.withOpacity(0.2)
                                    : Colors.white),
                            child: Center(
                              child: isFavorite
                                  ? Icon(Icons.favorite_border)
                                  : Icon(Icons.favorite, color: Colors.red),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 5.0),
                    Container(
                      width: 175.0,
                      child: Text(
                        'Scandinavian small sized double sofa imported full leather / Dale Italia oil wax leather black',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: 'Quicksand',
                            color: Colors.grey,
                            fontSize: 12.0),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 35.0),
                        Container(
                          height: 40.0,
                          width: 50.0,
                          child: Center(
                            child: Text(
                              '\$248',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Container(
                          height: 40.0,
                          width: 100.0,
                          child: Center(
                            child: Text(
                              'Add to cart',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

