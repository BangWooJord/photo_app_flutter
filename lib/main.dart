import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List data = [];
  List<String> imgUrl = [];
  List<String> imgAuthor = [];
  List<String> imgDescription = [];
  bool img_loaded = false;
  getData() async {
    http.Response response = await http.get(
        'https://api.unsplash.com/photos/?client_id=ab3411e4ac868c2646c0ed488dfd919ef612b04c264f3374c97fff98ed253dc9');
    data = json.decode(response.body);
    for (int i = 0; i < data.length; ++i) {
      imgUrl.add(data.elementAt(i)["urls"]["regular"]);
      imgAuthor.add(data.elementAt(i)["user"]["first_name"]);
      imgDescription.add(data.elementAt(i)["alt_description"]);
    }
    setState(() {
      img_loaded = true;
    });
    print('Image loaded');
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
        appBar: AppBar(
          title: Text("Photos"),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.black,
                child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return ListElement(index, img_loaded, imgUrl, imgAuthor, imgDescription);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                  itemCount: data.length,
                ),
              ),
            ),
          ],
        ));
  }
}

class ListElement extends StatelessWidget {
  ListElement(this.index, this.img_loaded, List<String> imgUrl, List<String> imgAuthor, List<String> imgDescription)
      : this.imgUrl = imgUrl, this.imgAuthor = imgAuthor, this.imgDescription = imgDescription;
  int index;
  bool img_loaded;
  final List<String> imgUrl;
  final List<String> imgAuthor;
  final List<String> imgDescription;

  @override
  Widget build(BuildContext context) {
    if(imgUrl.isNotEmpty) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: GestureDetector(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: !img_loaded
                        ? CircularProgressIndicator()
                        : Image.network(imgUrl.elementAt(index)),
                  ),
                ),
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              imgAuthor.elementAt(index).isEmpty ? 'author' : imgAuthor.elementAt(index),
                              style: TextStyle(
                                color: Colors.pink,
                              ),
                            ),

                            Text(
                              imgDescription.elementAt(index).isEmpty ? 'description' : imgDescription.elementAt(index),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ])),
                ),
              ],
            ),
          ),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => FullPicture(imgUrl.elementAt(index))));
          },
        ),
      );
    }
    else return LinearProgressIndicator(
    );
  }
}


class FullPicture extends StatelessWidget {
  FullPicture(this.image_src);
  final String image_src;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        child: Center(
          child: Image.network(image_src),
        ),
        onTap: (){
          Navigator.pop(context);
        },
      ),
    );
  }
}
