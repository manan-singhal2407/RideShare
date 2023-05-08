import 'package:btp/presentation/extension/utils_extension.dart';
import 'package:btp/presentation/screen/driver/driver_settings/arguments/driver_settings_screen_arguments.dart';
import 'package:btp/presentation/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'driver_home_view_model.dart';

// todo on ride going if user click online it goes to ride request page but he should go to rides_screen

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _closeDrawer() {
    _scaffoldKey.currentState?.closeDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DriverHomeViewModel>(
      create: (context) => DriverHomeViewModel(context),
      child: Consumer<DriverHomeViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            key: _scaffoldKey,
            body: _DriverHomePageBodyLayout(
              scaffoldKey: _scaffoldKey,
              viewModel: viewModel,
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
                              child: viewModel.driverProfileUrl == ''
                                  ? const Icon(
                                      Icons.person_rounded,
                                      size: 32,
                                    )
                                  : Image.network(
                                      viewModel.driverProfileUrl,
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
                                  viewModel.driverName,
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
                                  viewModel.driverPhoneNumber,
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
                              '/driver_my_rides_screen',
                              arguments: DriverSettingsScreenArguments(
                                viewModel.driverSharingOn,
                              ),
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
                              '/driver_settings_screen',
                              arguments: DriverSettingsScreenArguments(
                                viewModel.driverSharingOn,
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
                            viewModel.logoutDriver();
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DriverHomePageBodyLayout extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final DriverHomeViewModel viewModel;

  const _DriverHomePageBodyLayout({
    required this.scaffoldKey,
    required this.viewModel,
  });

  @override
  State<_DriverHomePageBodyLayout> createState() =>
      _DriverHomePageBodyLayoutState();
}

class _DriverHomePageBodyLayoutState extends State<_DriverHomePageBodyLayout> {
  @override
  void dispose() {
    widget.viewModel.disposeScreen();
    super.dispose();
  }

  void _openDrawer() {
    widget.scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              GoogleMap(
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: widget.viewModel.driverLocation,
                  zoom: 16,
                ),
                onMapCreated: (GoogleMapController controller) {
                  widget.viewModel.controller.complete(controller);
                },
                markers: {
                  if (widget.viewModel.sourcePosition != null)
                    widget.viewModel.sourcePosition!
                },
              ),
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
                  ],
                ),
              ),
              if (widget.viewModel.driverOffline) ...[
                Positioned(
                  bottom: 20,
                  left: MediaQuery.of(context).size.width / 2 - 40,
                  right: MediaQuery.of(context).size.width / 2 - 40,
                  child: GestureDetector(
                    onTap: widget.viewModel.onClickGoButton,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'GO',
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
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
              ] else ...[
                Positioned(
                  bottom: 20,
                  left: MediaQuery.of(context).size.width / 2 - 80,
                  right: MediaQuery.of(context).size.width / 2 - 80,
                  child: GestureDetector(
                    onTap: widget.viewModel.onClickSetOfflineButton,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Set Offline',
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
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
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: GestureDetector(
            onTap: !widget.viewModel.driverOffline
                ? widget.viewModel.onClickNextButton
                : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.viewModel.driverOffline
                      ? 'You\'re offline'
                      : 'You\'re online',
                  style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (!widget.viewModel.driverOffline) ...[
                  const SizedBox(
                    width: 12,
                  ),
                  const Icon(
                    Icons.navigate_next_rounded,
                    size: 24,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
