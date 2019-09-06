import 'dart:ui' as prefix0;
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter/widgets.dart';
import 'services/crud.dart';
import 'single.dart';

import 'dart:async';
import 'dart:core';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Travel Portal",
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Ubuntu',
      ),
      home: MyApp(),
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController textEditingController = TextEditingController();
  Icon _searchIcon = Icon(Icons.search);
  Widget _appBarTitle = Text("Easy Travel Guide");
  Stream places;
  MethodsCollec crudObj = new MethodsCollec();

  @override
  void initState() {
    crudObj.getData().then((results) {
      setState(() {
        places = results;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.zero,
              child: Image.asset(
                "images/visit.jpg",
                fit: BoxFit.cover,
              ),
              decoration: BoxDecoration(
                color: Colors.indigo,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: RefreshIndicator(
          child: _placesList(),
          onRefresh: () {
            return crudObj.getData().then((result) {
              setState(() {
                places = result;
              });
            });
          },
        ),
      ),
    );
  }

  Widget _placesList() {
    if (places != null) {
      return StreamBuilder(
        stream: places,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return GridView.builder(
              itemCount: snapshot.data.documents.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              padding: EdgeInsets.all(7.0),
              itemBuilder: (context, i) {
                return InkWell(
                  child: Card(
                    elevation: 4.0,
                    clipBehavior: prefix0.Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    margin: EdgeInsets.all(7.0),
                    child: Column(
                      children: <Widget>[
                        Image.network(snapshot.data.documents[i].data['url']),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          snapshot.data.documents[i].data['title'],
                          style: TextStyle(fontSize: 15.0),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return DetailsPage(
                          snapshot.data.documents[i].documentID,
                          snapshot.data.documents[i].data['title'],
                          snapshot.data.documents[i].data['desc'],
                          snapshot.data.documents[i].data['url'],
                          snapshot.data.documents[i].data['latLng']);
                    }));
                  },
                );
              },
            );
          }
        },
      );
    } else {
      return Center(
        child: Text(
          'Loading... please wait!',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: 20.0,
          ),
        ),
      );
    }
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: _appBarTitle,
      actions: <Widget>[
        IconButton(
          icon: _searchIcon,
          onPressed: _searchPressed,
        ),
      ],
    );
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = Icon(Icons.close);
        this._appBarTitle = TypeAheadField(
          suggestionsBoxDecoration: SuggestionsBoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
          ),
          hideOnError: true,
          //hideOnEmpty: true,
          loadingBuilder: (_) {
            return Image.asset(
              'images/loading.gif',
              height: 55,
              width: double.infinity,
            );
          },
          noItemsFoundBuilder: (_) {
            return Image.asset(
              'images/loading.gif',
              height: 55,
              width: double.infinity,
            );
          },
          textFieldConfiguration: TextFieldConfiguration(
            autofocus: true,
            controller: textEditingController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              contentPadding: EdgeInsets.only(top: 10.0),
              hintText: 'Search...',
              filled: true,
              fillColor: Colors.white,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              focusedBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
          ),
          suggestionsCallback: (pattern) async {
            return await crudObj.getSuggestions(pattern);
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              leading: Icon(
                Icons.place,
                color: Colors.indigo,
              ),
              title: Text(suggestion['title']),
            );
          },
          onSuggestionSelected: (suggestion) {
            setState(() {
              textEditingController.clear();
              this._searchIcon = Icon(Icons.search);
              this._appBarTitle = Text('Travel Portal');
            });
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return DetailsPage(suggestion.documentID, suggestion['title'],
                  suggestion['desc'], suggestion['url'], suggestion['latLng']);
            }));
          },
        );
      } else {
        textEditingController.clear();
        this._searchIcon = Icon(Icons.search);
        this._appBarTitle = Text('Travel Portal');
      }
    });
  }
}
