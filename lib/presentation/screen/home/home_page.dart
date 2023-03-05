import 'package:btp/presentation/extension/utils_extension.dart';
import 'package:btp/presentation/screen/search/arguments/search_screen_arguments.dart';
import 'package:btp/presentation/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'home_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    Navigator.pushNamed(
      context,
      '/search_screen',
      arguments: SearchScreenArguments(
        'pickup',
      ),
    );
    // _scaffoldKey.currentState?.openDrawer();
  }

  void _closeDrawer() {
    _scaffoldKey.currentState?.closeDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (context) => HomeViewModel(context),
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            key: _scaffoldKey,
            body: Stack(
              children: [
                // GoogleMap(
                //   zoomControlsEnabled: false,
                //   initialCameraPosition: CameraPosition(
                //     target: destLocation!,
                //     zoom: 16,
                //   ),
                //   onCameraMove: (CameraPosition? position) {
                //     if (destLocation != position!.target) {
                //       setState(() {
                //         destLocation = position.target;
                //       });
                //     }
                //   },
                //   onCameraIdle: () {
                //     getAddressFromLatLng();
                //   },
                //   onTap: (latLng) {
                //
                //   },
                //   onMapCreated: (GoogleMapController controller) {
                //     _controller.complete(controller);
                //   },
                // ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: _openDrawer,
              child: const Icon(Icons.menu),
            ),
            drawer: Drawer(
              child: ListView(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 8,
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.green,
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 32,
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'User Name',
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                color: primaryTextColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Phone Number',
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                color: secondaryTextColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Divider(
                    height: 0,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ListTile(
                    onTap: () {
                      _closeDrawer();
                      showScaffoldMessenger(context, 'My Rides', primaryTextColor);
                    },
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.grey.shade500,
                      ),
                      child: const Icon(
                        Icons.timelapse_rounded,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      'My Rides',
                      style: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                          color: secondaryTextColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      _closeDrawer();
                      showScaffoldMessenger(context, 'Settings', primaryTextColor);
                    },
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.red.shade500,
                      ),
                      child: const Icon(
                        Icons.settings_rounded,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      'Settings',
                      style: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                          color: secondaryTextColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      _closeDrawer();
                      showScaffoldMessenger(context, 'Support', primaryTextColor);
                    },
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.orange.shade500,
                      ),
                      child: const Icon(
                        Icons.support_rounded,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      'Support',
                      style: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                          color: secondaryTextColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
