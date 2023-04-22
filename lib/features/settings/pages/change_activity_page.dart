import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:smart_home_app/features/home/providers/home_provider.dart';
import 'package:smart_home_app/features/settings/widgets/change_password_app_bar.dart';
import 'package:smart_home_app/features/settings/providers/settings_provider.dart';
import 'package:smart_home_app/utils/managers/color_manager.dart';
import 'package:smart_home_app/utils/managers/font_manager.dart';
import 'package:smart_home_app/utils/managers/string_manager.dart';
import 'package:smart_home_app/utils/managers/style_manager.dart';
import 'package:smart_home_app/utils/managers/value_manager.dart';
import 'package:smart_home_app/utils/widgets/lime_green_rounded_button.dart';
import 'package:smart_home_app/utils/widgets/neu_dark_container_widget.dart';

class ChangeActivityPage extends StatefulWidget {
  const ChangeActivityPage({super.key});

  @override
  State<ChangeActivityPage> createState() => _ChangeActivityPageState();
}

class _ChangeActivityPageState extends State<ChangeActivityPage> {
  String? _valueActivity;
  void _onChangedActivity(Object? selectedActivityValue) {
    if (selectedActivityValue is String) {
      setState(() {
        _valueActivity = selectedActivityValue;
      });
    }
  }

  Future<void> changeActivity() async {
    final settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    try {
      await homeProvider
          .getUsersBMR(
            gender: homeProvider.userData['gender'],
            weight: homeProvider.userData['weight'],
            height: homeProvider.userData['height'],
            age: homeProvider.userData['age'],
            activity: _valueActivity!,
            goal: homeProvider.userData['goal'],
          )
          .then((_) => settingsProvider.changeUsersActivity(
              bmr: homeProvider.userBMRwithGoal,
              activity: _valueActivity!,
              context: context))
          .then((_) => Navigator.of(context).pop());
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.darkGrey,
      appBar: const PreferredSize(
        preferredSize: Size(
          double.infinity,
          SizeManager.s60,
        ),
        child: ChangeDataPagesAppBar(),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(PaddingManager.p28),
                child: Text(
                  StringsManager.changeActivityText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorManager.white,
                    fontWeight: FontWightManager.bold,
                    letterSpacing: SizeManager.s3,
                    fontSize: FontSize.s25,
                  ),
                ),
              ),
              NeuButton(
                width: SizeManager.s400,
                height: SizeManager.s70,
                radius: RadiusManager.r15,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    dropdownDecoration: BoxDecoration(
                      color: ColorManager.darkGrey,
                      borderRadius: BorderRadius.circular(
                        RadiusManager.r15,
                      ),
                    ),
                    onChanged: _onChangedActivity,
                    value: _valueActivity,
                    iconSize: SizeManager.s0,
                    hint: const Text(
                      StringsManager.activityHint,
                      style: StyleManager.registerTextfieldTextStyle,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: StringsManager.activityLowHint,
                        child: Text(
                          StringsManager.activityLowHint,
                          style: StyleManager.registerTextfieldTextStyle,
                        ),
                      ),
                      DropdownMenuItem(
                        value: StringsManager.activityLightHint,
                        child: Text(
                          StringsManager.activityLightHint,
                          style: StyleManager.registerTextfieldTextStyle,
                        ),
                      ),
                      DropdownMenuItem(
                        value: StringsManager.activityModerateHint,
                        child: Text(
                          StringsManager.activityModerateHint,
                          style: StyleManager.registerTextfieldTextStyle,
                        ),
                      ),
                      DropdownMenuItem(
                        value: StringsManager.activityHighHint,
                        child: Text(
                          StringsManager.activityHighHint,
                          style: StyleManager.registerTextfieldTextStyle,
                        ),
                      ),
                      DropdownMenuItem(
                        value: StringsManager.activityVeryHighHint,
                        child: Text(
                          StringsManager.activityVeryHighHint,
                          style: StyleManager.registerTextfieldTextStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              LimeGreenRoundedButtonWidget(
                onTap: changeActivity,
                title: StringsManager.procede,
              )
            ],
          ),
        ),
      )),
    ).animate().fadeIn(
          duration: 500.ms,
        );
  }
}
