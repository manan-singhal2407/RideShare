import 'package:btp/presentation/screen/driver/driver_settings/driver_settings_view_model.dart';
import 'package:btp/presentation/theme/color.dart';
import 'package:btp/presentation/theme/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../theme/widgets/app_bar.dart';

class DriverSettingsPage extends StatefulWidget {
  const DriverSettingsPage({super.key});

  @override
  State<DriverSettingsPage> createState() => _DriverSettingsPageState();
}

class _DriverSettingsPageState extends State<DriverSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DriverSettingsViewModel>(
      create: (context) => DriverSettingsViewModel(context),
      child: Consumer<DriverSettingsViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: const SecondaryAppBar(
              primaryText: 'Settings',
            ),
            body: Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enable Ride Sharing',
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontSize: 16,
                                color: primaryTextColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Allow multiple passengers to ride with you at once and increase your earnings.',
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                color: secondaryTextColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Text(
                            'By enabling ride sharing, you agree to pick up passengers who are headed in the same direction as you.',
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                color: secondaryTextColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Switch(
                      value: viewModel.isSharingOnByDriver,
                      onChanged: (bool value) {
                        viewModel.onSwitchClick();
                      },
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 52,
                ),
                PrimaryAppButton(
                  width: MediaQuery.of(context).size.width - 30,
                  text: 'Save',
                  onPressed: viewModel.saveDataToDatabase,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
