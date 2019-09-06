import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class DetailsPage extends StatefulWidget {
  final String docID;
  final String title;
  final String desc;
  final String imgUrl;
  final String latLng;

  DetailsPage(this.docID, this.title, this.desc, this.imgUrl, this.latLng);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  String appBarTitle = "About ";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2)
      ..addListener(() {
        setState(() {
          switch (_tabController.index) {
            case 0:
              appBarTitle = "About ";
              break;
            case 1:
              appBarTitle = "Location of ";
              break;
            default:
              appBarTitle = widget.title;
          }
        });
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle + widget.title),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.home)),
            Tab(icon: Icon(Icons.location_on))
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          firstScreen(),
          secondScreen(),
        ],
      ),
    );
  }

  Widget firstScreen() {
    return ListView(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          ),
          child: Image.network(
            widget.imgUrl.toString(),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 7.0,
          ),
          child: Text(
            widget.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(7.0),
          child: Text(
            widget.desc,
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 17.0,
            ),
          ),
        )
      ],
    );
  }

  Widget secondScreen() {
    var loc = widget.latLng.split(',');
    double lat = double.parse(loc[0]);
    double lng = double.parse(loc[1]);

    return new FlutterMap(
      options: new MapOptions(
        center: new LatLng(lat, lng),
        minZoom: 4.0,
        maxZoom: 18.0
      ),
      layers: [
        new TileLayerOptions(
          urlTemplate: "https://api.tiles.mapbox.com/v4/"
              "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
          additionalOptions: {
            'accessToken': 'pk.eyJ1Ijoic3VnYW1iYXNrb3RhIiwiYSI6ImNqejJkMHY0MTA0bngzY3J3Mm84eWFwZTQifQ.FQZ2enpJquhgXj-TLYp5uw',
            'id': 'mapbox.streets',
          },
        ),
        new MarkerLayerOptions(
          markers: [
            new Marker(
              width: 90.0,
              height: 90.0,
              point: new LatLng(lat, lng),
              builder: (ctx) =>
              IconButton(
                alignment: Alignment.topCenter,
                icon: Icon(Icons.location_on),
                color: Colors.red,
                iconSize: 40.0,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ],
    );


    // return FlutterMap(
    //     options: new MapOptions(
    //       center: new LatLng(lat, lng),
    //       minZoom: 4.0,
    //       maxZoom: 18.0,
    //     ),
    //     layers: [
    //       new TileLayerOptions(
    //           urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
    //           subdomains: ['a', 'b', 'c']),
    //       new MarkerLayerOptions(markers: [
    //         new Marker(
    //           width: 90.0,
    //           height: 90.0,
    //           point: new LatLng(lat, lng),
    //           builder: (context) => IconButton(
    //             alignment: Alignment.topCenter,
    //             icon: Icon(Icons.location_on),
    //             color: Colors.red,
    //             iconSize: 40.0,
    //             onPressed: () {},
    //           ),
    //         ),
    //       ])
    //     ]);

  }
}
