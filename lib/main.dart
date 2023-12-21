
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'view/map_screen.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
  //FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Map Osrm Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.teal,
      ),
      home: const FlutterMapOsrmExample(),
    );
  }
}

class FlutterMapOsrmExample extends StatelessWidget {

  const FlutterMapOsrmExample({
    super.key,
  });

  Widget _panel() {
    return  const DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 20.0, top: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 4,
                  child: SizedBox(
                    width: 10,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: 35,
                    child: Divider(
                      color: Colors.grey,
                      thickness: 5,
                    ),
                  ),
                ),
                Expanded(
                flex: 4,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                ),
                ),
              ],
            ),
          ),
          Align(
              alignment: Alignment.topLeft,
              child:  Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                    'Select your Pick and Drop location',
                style: TextStyle(

                ),
                ),
              ),
          ),
          TabBar(
            tabs: [
              Tab(child: Text('Jeddah')),
              Tab(child: Text('Riyad')),
              Tab(child: Text('Al Madinah')),
            ],
          ),
          Expanded(
            child: SizedBox(
              height: 350,
              child: TabBarView(
                children: [
                  MapScreen(),
                  MapScreen(),
                  MapScreen(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Position> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

 /* void initiateEmergencyCall() async {
    const String phoneNumber = 'tel:+03323222729'; // Replace with your local emergency number

    if (await canLaunch(phoneNumber )) {
      await launch(phoneNumber);
    } else {
      // Handle error
      print('Could not launch $phoneNumber');
    }
  }*/
  void initiateEmergencyCall()  {
     FlutterPhoneDirectCaller.callNumber('911');
  }

  Future<void> autoEmergencyCallAndLocationSharing() async {
    try {
      LocationPermission permission; permission = await Geolocator.requestPermission();
      // Get current location
      final Position currentLocation = await getCurrentLocation();

      // Send the location to a server or handle as needed
      if (kDebugMode) {
        print('Current Location: ${currentLocation.latitude}, ${currentLocation.longitude}');
      }

      // Initiate emergency call
      initiateEmergencyCall();
    } catch (e) {
      // Handle errors, such as location services not available
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    /*  body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          SlidingUpPanel(
            *//* panel: const SizedBox(
            width: 10,
            child: Divider(
              height: 10,
              color: Colors.black,
              thickness: 2.5,
            ),
          ),*//*
            panelSnapping: false,
            maxHeight: 600,
            minHeight: 30,
            parallaxEnabled: true,
            parallaxOffset: .5,
            body: _body(),
            panelBuilder: (sc) => _panel(sc),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0)),
            onPanelSlide: (double pos) => setState(() {

            }),
          ),
          //the SlidingUpPanel Title
          Positioned(
            top: 52.0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24.0, 18.0, 24.0, 18.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.0),
                boxShadow: const [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, .25), blurRadius: 16.0)
                ],
              ),
              child: const Text(
                "Map time/distance demo",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),*/

      backgroundColor: Colors.white,
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              child: const Text(
                'Show modal bottom sheet',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                showModalBottomSheet<void>(
                 // showDragHandle: true,
                  context: context,
                    useSafeArea: true,
                    isScrollControlled:true,
                  // TODO: Remove when this is in the framework https://github.com/flutter/flutter/issues/118619
                 // constraints: const BoxConstraints(maxWidth: 640),
                  builder: (context) {
                    return SizedBox(
                        height: MediaQuery.of(context).copyWith().size.height * (4 / 5),
                        child: _panel(),
                    );
                  },
                );
              },
            ),
            TextButton(
              child: const Text(
                'Emergency Call',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                autoEmergencyCallAndLocationSharing();
              },
            ),
          ],
        ),
      ),

    );
  }
}

///
//Stack(
//                     children: [
//                       FlutterMap(
//                         options: MapOptions(
//                           onTap:
//                           // use [isPairly] to switch between [from] and [to]
//                               (_, point) {
//                             if (isPairly) {
//                               to = point;
//                             } else {
//                               from = point;
//                             }
//                             isPairly = !isPairly;
//                             setState(() {});
//                             getRoute();
//                           },
//                           initialCenter: const LatLng(24.8879221, 67.0583741),
//                           minZoom: 13.0,
//                         ),
//                         /*  nonRotatedChildren: [
//               RichAttributionWidget(
//                 animationConfig:
//                 const ScaleRAWA(), // Or `FadeRAWA` as is default
//                 attributions: [
//                   TextSourceAttribution(
//                     'OpenStreetMap contributors',
//                     onTap: () => launchUrl(
//                         Uri.parse('https://openstreetmap.org/copyright')),
//                   ),
//                   /// @mohamadlounnas
//                   TextSourceAttribution(
//                     'Mohamad Lounnas',
//                     onTap: () => launchUrl(
//                         Uri.parse('mailto:mohamadlounnas@gmail.com')),
//                   ),
//                 ],
//               ),
//                             ],*/
//                         children: [
//                           TileLayer(
//                             urlTemplate:
//                             "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//                             //subdomains: const ['a', 'b', 'c'],
//                           ),
//
//                           /// [PolylineLayer] draw the route between two coordinates [from] and [to]
//                           PolylineLayer(
//                             polylines: [
//                               Polyline(
//                                 points: points,
//                                 strokeWidth: 6.0,
//                                 color: Colors.red,
//                               ),
//                             ],
//                           ),
//
//                           /// [MarkerLayer] draw the marker on the map
//                           MarkerLayer(
//                             markers: [
//                               Marker(
//                                 width: 80.0,
//                                 height: 80.0,
//                                 point: from,
//                                 child:  const Icon(
//                                   Icons.circle,
//                                   color: Colors.blue,
//                                 ),
//                               ),
//                               Marker(
//                                 width: 80.0,
//                                 height: 80.0,
//                                 point: to,
//                                 child: const Icon(
//                                   Icons.circle,
//                                   color: Colors.red,
//                                 ),
//                               ),
//
//                               /// in the middle of [points] list we draw the [Marker] shows the distance between [from] and [to]
//                               if (points.isNotEmpty)
//                                 Marker(
//                                   rotate: true,
//                                   width: 80.0,
//                                   height: 30.0,
//                                   point: points[math.max(0, (points.length / 2).floor())],
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: Center(
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: Text(
//                                           '${distance.toStringAsFixed(2)} m',
//                                           style: const TextStyle(
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                           // copy right text
//                         ],
//                       ),
//
//                       /// [Form] with two [TextFormField] to get the coordinates [from] and [to]
//                       Align(
//                         alignment: Alignment.topRight,
//                         child: Card(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           margin: const EdgeInsets.all(20),
//                           child: Container(
//                             width: 500,
//                             padding: const EdgeInsets.all(20),
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 TextFormField(
//                                     initialValue: from.toSexagesimal(),
//                                     onChanged: (value) {
//                                       from = LatLng.fromSexagesimal(value);
//                                       setState(() {});
//                                     },
//                                     decoration: InputDecoration(
//                                       prefixIcon: const Icon(Icons.location_on),
//                                       prefix: const Text('From: '),
//                                       border: const OutlineInputBorder().copyWith(
//                                         borderSide: const BorderSide(
//                                           color: Colors.grey,
//                                         ),
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                     )),
//                                 const SizedBox(height: 20),
//                                 TextFormField(
//                                     initialValue: to.toSexagesimal(),
//                                     onChanged: (value) {
//                                       to = LatLng.fromSexagesimal(value);
//                                       setState(() {});
//                                     },
//                                     decoration: InputDecoration(
//                                       prefixIcon: const Icon(Icons.location_on),
//                                       prefix: const Text('To: '),
//                                       border: const OutlineInputBorder().copyWith(
//                                         borderSide: const BorderSide(
//                                           color: Colors.grey,
//                                         ),
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                     )),
//                                 const SizedBox(height: 20),
//                                 Row(
//                                   children: [
//                                     FilledButton.icon(
//                                       icon: const Icon(Icons.directions),
//                                       onPressed: () {
//                                         getRoute();
//                                       },
//                                       label: const Text('Get Route'),
//                                     ),
//                                     const SizedBox(width: 20),
//                                     // grey text display the duration between [from] and [to] and the distance
//                                     Center(
//                                       child: Text(
//                                         // km and hour
//                                         '| ${(duration / 60).toStringAsFixed(2)} h - ${(distance / 1000).toStringAsFixed(2)} km',
//                                         style: const TextStyle(
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   )
