import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
// osrm
import 'package:osrm/osrm.dart';
import 'dart:math' as math;
// flutter_map
import 'package:flutter_map/flutter_map.dart';


class MapScreen extends StatefulWidget {

  const MapScreen({
    super.key,
  });

  @override
  State<MapScreen> createState() => _FlutterMapOsrmExampleState();
}

class _FlutterMapOsrmExampleState extends State<MapScreen> {
// chaseup north nazma
  var from = const LatLng(24.8785711, 67.0615239);

  var to = // Agha Khan
  const LatLng(24.8901719, 67.0688426);
  //gym
  var gym = const LatLng(24.8758659, 67.0623789);

  var dilkushan = const LatLng(24.8785711, 67.0615239);
  var mPalace = const LatLng(25.1932024, 67.1554619);
  var points = <LatLng>[];

  @override
  void initState() {
    super.initState();
    getRoute();
  }

  /// [distance] the distance between two coordinates [from] and [to]
  num distance = 0.0;

  /// [duration] the duration between two coordinates [from] and [to]
  num duration = 0.0;

  /// [distance] the distance between two coordinates [from] and [to]
  num distance_gym = 0.0;

  /// [duration] the duration between two coordinates [from] and [to]
  num duration_gym = 0.0;

  /// [distance] the distance between two coordinates [from] and [to]
  num distance_mPL = 0.0;

  /// [duration] the duration between two coordinates [from] and [to]
  num duration_mPL = 0.0;
  /// [getRoute] get the route between two coordinates [from] and [to]
  Future<void> getRoute() async {

    final osrm = Osrm(
      source: OsrmSource(
        serverBuilder: OpenstreetmapServerBuilder().build,
      ),
    );
    // get the route
    final options = RouteRequest(
      coordinates: [
        (dilkushan.longitude, dilkushan.latitude),
        (to.longitude, to.latitude),
      ],
      geometries: OsrmGeometries.geojson,
      overview: OsrmOverview.full,
      alternatives: OsrmAlternative.number(2),
      annotations: OsrmAnnotation.true_,
      steps: false,
    );

    final route = await osrm.route(options);
    distance = route.routes.first.distance! /1000;
    duration = route.routes.first.duration! / 60;

    //for gym
    final options_gym = RouteRequest(
      coordinates: [
        (dilkushan.longitude, dilkushan.latitude),
        (gym.longitude, gym.latitude),
      ],
      geometries: OsrmGeometries.geojson,
      overview: OsrmOverview.full,
      alternatives: OsrmAlternative.number(2),
      annotations: OsrmAnnotation.true_,
      steps: false,
    );

    final route_gym = await osrm.route(options_gym);
    distance_gym = route_gym.routes.first.distance! /1000;
    duration_gym = route_gym.routes.first.duration! / 60;

    //for MPla
    final options_mPL = RouteRequest(
      coordinates: [
        (dilkushan.longitude, dilkushan.latitude),
        (mPalace.longitude, mPalace.latitude),
      ],
      geometries: OsrmGeometries.geojson,
      overview: OsrmOverview.full,
      alternatives: OsrmAlternative.number(2),
      annotations: OsrmAnnotation.true_,
      steps: false,
    );

    final route_mPL = await osrm.route(options_mPL);
    distance_mPL = route_mPL.routes.first.distance! /1000;
    duration_mPL = route_mPL.routes.first.duration! / 60;

    points = route.routes.first.geometry!.lineString!.coordinates.map((e) {
      var location = e.toLocation();
      return LatLng(location.lat, location.lng);
    }).toList();
    if (kDebugMode) {
      //print(points);
    }
    setState(() {});
  }

  // pairly
  bool isPairly = false;
  final mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
            children: [
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: 400,
                    height: 500,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      child:  FlutterMap(
                        options: MapOptions(
                          interactionOptions: const InteractionOptions(
                              enableMultiFingerGestureRace: true,
                              flags: InteractiveFlag.scrollWheelZoom
                          ),
                          // use [isPairly] to switch between [from] and [to]
                          /*  onTap: (_, point) {
                      if (isPairly) {
                        to = point;
                      } else {
                        from = point;
                      }
                      isPairly = !isPairly;
                      setState(() {});
                      getRoute();
                    },*/
                          initialZoom: 15.5,

                          initialCenter: dilkushan, //dilkushan

                          onMapReady: () => mapController.mapEventStream.listen((evt) {}),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:   "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            // subdomains: const ['a', 'b', 'c'],

                            /*'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: const ['a', 'b', 'c'],*/
                          ),

                          /// [PolylineLayer] draw the route between two coordinates [from] and [to]
                          /*    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: points,
                          strokeWidth: 6.0,
                          color: Colors.red,
                        ),
                      ],
                    ),*/

                          /// [MarkerLayer] draw the marker on the map
                          MarkerLayer(
                            markers: [
                              /* Marker(
                          width: 140.0,
                          height: 60.0,
                          point: from, //nextGeni
                          child:  ListTile(
                            subtitle:  const Icon(
                              size: 80.0,
                              Icons.location_on,
                              color:  Color(0xFF1A809F),
                            ),
                            title: Container(

                              decoration:  const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/background/mark_top.png"),

                                ),
                              ),
                              child:   Stack(
                                children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                          Row(
                                           //crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 10,
                                                width: 20,
                                                child: SvgPicture.asset(
                                                  'assets/background/Lexus.svg',
                                                ),
                                              ),
                                              const Text('ALJ Motor',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold
                                              ),),
                                            ],
                                          ),
                                           const Text(
                                            //'${distance.toStringAsFixed(2)} km',
                                            '  2.5km | 10min',
                                            style:  TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 10,
                                            ),
                                          ),

                                        *//* Text(
                                          '${duration.toStringAsFixed(2)} min',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),*//*
                                      ],
                                    ),
                                  ),
                                ),
                      ],
                              ),
                            ),
                          ),
                        ),*/
                              Marker(
                                width: 140.0,
                                height: 60.0,
                                point: dilkushan, //nextGeni
                                child:  ListTile(
                                  subtitle:  const Icon(
                                    size: 70.0,
                                    Icons.location_on,
                                    color:  Color(0xFF1A809F),
                                  ),
                                  title: Stack(
                                    children: <Widget>[
                                      SvgPicture.asset(
                                        'assets/background/mark_label.svg',
                                        alignment: Alignment.center,
                                        width: 350,
                                        height: 200,
                                      ),
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                //crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 10,
                                                    width: 20,
                                                    child: SvgPicture.asset(
                                                      'assets/background/toyota.svg',
                                                    ),
                                                  ),
                                                  const Text(
                                                    'ALJ Motor',
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.bold
                                                    ),),
                                                ],
                                              ),
                                              Flexible(
                                                child: Text(
                                                  //'${distance.toStringAsFixed(2)} km',
                                                  '${distance.toStringAsFixed(0)} km | ${duration.toStringAsFixed(0)} min',
                                                  style:  const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: 8,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Marker(
                                width: 140.0,
                                height: 60.0,
                                point: gym, //nextGeni
                                child:  ListTile(
                                  subtitle:  const Icon(
                                    size: 80.0,
                                    Icons.location_on,
                                    color:  Color(0xFF1A809F),
                                  ),
                                  title: Stack(
                                    children:<Widget> [
                                      SvgPicture.asset(
                                        'assets/background/mark_label.svg',
                                        alignment: Alignment.center,
                                        width: 350,
                                        height: 200,
                                      ),
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                //crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 10,
                                                    width: 20,
                                                    child: SvgPicture.asset(
                                                      'assets/background/Lexus.svg',
                                                    ),
                                                  ),
                                                  const Text(
                                                    'ALJ Motor',
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                //'${distance.toStringAsFixed(2)} km',
                                                '${distance_gym.toStringAsFixed(2)} km | ${duration_gym.toStringAsFixed(2)} min',
                                                style:  const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 8,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              /* Marker(
                          width: 140.0,
                          height: 60.0,
                          point: gym,
                          child:  ListTile(
                            subtitle:  const Icon(
                              size: 50.0,
                              Icons.location_on,
                              color:  Color(0xFF1A809F),
                            ),
                            title: Container(
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        '${distance_gym.toStringAsFixed(2)} km',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${duration_gym.toStringAsFixed(2)} min',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),*/
                              /// in the middle of [points] list we draw the [Marker] shows the distance between [from] and [to]
                              /* if (points.isNotEmpty)
                          Marker(
                            rotate: true,
                            width: 100.0,
                            height: 60.0,
                            point: points[math.max(0, (points.length / 2).floor())],
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        '${distance.toStringAsFixed(2)} km',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${duration.toStringAsFixed(2)} min',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),*/
                            ],
                          ),
                          // copy right text
                        ],
                      ),
                    ),
                  )
              ),
              /// [Form] with two [TextFormField] to get the coordinates [from] and [to]
              /*  Align(
              alignment: Alignment.topRight,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                margin: const EdgeInsets.all(20),
                child: Container(
                  width: 500,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                          initialValue: from.toSexagesimal(),
                          onChanged: (value) {
                            from = LatLng.fromSexagesimal(value);
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.location_on),
                            prefix: const Text('From: '),
                            border: const OutlineInputBorder().copyWith(
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          )),
                      const SizedBox(height: 20),
                      TextFormField(
                          initialValue: to.toSexagesimal(),
                          onChanged: (value) {
                            to = LatLng.fromSexagesimal(value);
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.location_on),
                            prefix: const Text('To: '),
                            border: const OutlineInputBorder().copyWith(
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          )),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          FilledButton.icon(
                            icon: const Icon(Icons.directions),
                            onPressed: () {
                              getRoute();
                            },
                            label: const Text('Get Route'),
                          ),
                          const SizedBox(width: 20),
                          // grey text display the duration between [from] and [to] and the distance
                          Center(
                            child: Text(
                              // km and hour
                              '| ${(duration / 60).toStringAsFixed(2)} h - ${(distance / 1000).toStringAsFixed(2)} km',
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),*/
            ],
          ),
    );
  }
}