import 'package:btp/presentation/theme/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../extension/utils_extension.dart';
import '../../../theme/color.dart';
import '../../search/arguments/search_screen_arguments.dart';
import '../rider_settings/arguments/rider_settings_screen_arguments.dart';
import 'rider_home_view_model.dart';

class RiderHomePage extends StatefulWidget {
  const RiderHomePage({super.key});

  @override
  State<RiderHomePage> createState() => _RiderHomePageState();
}

class _RiderHomePageState extends State<RiderHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _closeDrawer() {
    _scaffoldKey.currentState?.closeDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RiderHomeViewModel>(
      create: (context) => RiderHomeViewModel(context),
      child: Consumer<RiderHomeViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            key: _scaffoldKey,
            body: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      GoogleMap(
                        zoomControlsEnabled: false,
                        initialCameraPosition: CameraPosition(
                          target: viewModel.pickUpLocation,
                          zoom: 16,
                        ),
                        onCameraMove: (CameraPosition? position) {
                          if (viewModel.pickUpLocation != position!.target) {
                            viewModel.onCameraPositionChange(position.target);
                          }
                        },
                        onCameraIdle: () {
                          if (viewModel.sourcePosition == null) {
                            viewModel.getAddressFromPickUpMovement();
                          }
                        },
                        onMapCreated: (GoogleMapController controller) {
                          viewModel.controller.complete(controller);
                        },
                        markers: {
                          if (viewModel.sourcePosition != null)
                            viewModel.sourcePosition!
                        },
                      ),
                      if (viewModel.sourcePosition == null) ...[
                        const Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 35.0),
                            child: Icon(
                              Icons.location_on,
                              size: 45,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                      Positioned(
                        top: 40,
                        right: 20,
                        left: 20,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: _openDrawer,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: const SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Icon(
                                    Icons.menu,
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  viewModel.getDataFromDatabase('pickup');
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    alignment: Alignment.centerLeft,
                                    height: 50,
                                    child: Text(
                                      viewModel.pickUpLocationAddress ??
                                          'Enter pickup location',
                                      style: GoogleFonts.openSans(
                                        textStyle: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  child: GestureDetector(
                    onTap: () {
                      viewModel.getDataFromDatabase('destination');
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.centerLeft,
                        height: 50,
                        child: Text(
                          'Enter drop location',
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            drawer: Drawer(
              child: Column(
                children: [
                  Expanded(
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
                                color: Colors.purple,
                              ),
                              child: viewModel.riderProfileUrl == ''
                                  ? const Icon(
                                      Icons.person_rounded,
                                      size: 32,
                                    )
                                  : Image.network(
                                      viewModel.riderProfileUrl,
                                      width: 32,
                                      height: 32,
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
                                  viewModel.riderName,
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
                                  viewModel.riderPhoneNumber,
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
                            Navigator.pushNamed(
                              context,
                              '/rider_my_rides_screen',
                            );
                          },
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.orange.shade500,
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
                          onTap: () async {
                            _closeDrawer();
                            Navigator.pushNamed(
                              context,
                              '/rider_settings_screen',
                              arguments: RiderSettingsScreenArguments(
                                (viewModel.users?.isSharingOn)!,
                                (viewModel.users?.tolerance)!.toInt(),
                                (viewModel.users?.amountNeedToSave)!.toInt(),
                              ),
                            );
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
                          onTap: () async {
                            _closeDrawer();
                            redirectUserToEmail();
                          },
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.grey.shade500,
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
                        ListTile(
                          onTap: () async {
                            _closeDrawer();
                            viewModel.logoutUser();
                          },
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.orange.shade500,
                            ),
                            child: const Icon(
                              Icons.logout_rounded,
                              size: 24,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            'Logout',
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
                  GestureDetector(
                    onTap: viewModel.openCaptainVerificationPage,
                    child: Container(
                      height: 50,
                      color: shimmerBaseColor,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Become a Driver',
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
                        ],
                      ),
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
