import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:smart_home_app/features/settings/widgets/change_password_app_bar.dart';
import 'package:smart_home_app/features/settings/providers/settings_provider.dart';
import 'package:smart_home_app/utils/managers/asset_manager.dart';
import 'package:smart_home_app/utils/managers/color_manager.dart';
import 'package:smart_home_app/utils/managers/font_manager.dart';
import 'package:smart_home_app/utils/managers/string_manager.dart';
import 'package:smart_home_app/utils/managers/value_manager.dart';
import 'package:smart_home_app/utils/widgets/lime_green_rounded_button.dart';
import 'package:smart_home_app/utils/widgets/text_field_widget.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    Future<void> changePassword() async {
      if (isValid) {
        try {
          await settingsProvider.changePassword(
            context: context,
            email: _emailController.text,
            oldPassword: _oldPasswordController.text,
            newPassword: _newPasswordController.text,
          );
        } catch (e) {
          print(e);
        }
      }
    }

    return Scaffold(
      backgroundColor: ColorManager.darkGrey,
      appBar: const PreferredSize(
        preferredSize: Size(
          double.infinity,
          SizeManager.s60,
        ),
        child: ChangePasswordPageAppBar(),
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
                  StringsManager.changePWtext,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorManager.white,
                    fontWeight: FontWightManager.bold,
                    letterSpacing: SizeManager.s3,
                    fontSize: FontSize.s25,
                  ),
                ),
              ),
              TextFieldWidget(
                controller: _emailController,
                labelHint: StringsManager.emailHint,
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
              ),
              TextFieldWidget(
                controller: _oldPasswordController,
                labelHint: StringsManager.oldPasswordHint,
                obscureText: true,
                keyboardType: TextInputType.emailAddress,
              ),
              TextFieldWidget(
                controller: _newPasswordController,
                labelHint: StringsManager.newPasswordHint,
                obscureText: true,
                keyboardType: TextInputType.emailAddress,
              ),
              LimeGreenRoundedButtonWidget(
                onTap: changePassword,
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

  bool get isValid {
    return _emailController.text.isNotEmpty ||
        _oldPasswordController.text.isNotEmpty ||
        _newPasswordController.text.isNotEmpty ||
        _oldPasswordController != _newPasswordController;
  }
}
