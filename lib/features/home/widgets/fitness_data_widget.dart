import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:smart_home_app/features/consumption/providers/consumption_provider.dart';
import 'package:smart_home_app/features/home/providers/home_provider.dart';
import 'package:smart_home_app/utils/managers/color_manager.dart';
import 'package:smart_home_app/utils/managers/font_manager.dart';
import 'package:smart_home_app/utils/managers/string_manager.dart';
import 'package:smart_home_app/utils/managers/style_manager.dart';
import 'package:smart_home_app/utils/managers/value_manager.dart';

class FitnessDataWidget extends StatelessWidget {
  const FitnessDataWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    final consumptionProvider =
        Provider.of<ConsumptionProvider>(context, listen: false);
    final deviceWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<Map<String, dynamic>>(
        future: homeProvider.fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SpinKitSpinningLines(color: ColorManager.limerGreen2);
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            double bmr = homeProvider.userData['bmr'];
            double bmi = homeProvider.userData['bmi'];
            Color getProgressColor(double bmi) {
              var isNormalBMI = bmi >= 18.5 && bmi <= 25;
              var isUnderOrOverWeight =
                  (bmi >= 17 && bmi < 18.5) || (bmi > 25 && bmi <= 30);
              if (isNormalBMI) {
                return ColorManager.limerGreen2;
              } else if (isUnderOrOverWeight) {
                return ColorManager.yellow;
              } else {
                return ColorManager.red;
              }
            }

            String getMessage(double bmi) {
              var isNormalBMI = bmi >= 18.5 && bmi <= 25;
              var isUnderWeight = bmi >= 17 && bmi < 18.5;
              var isOverWeight = bmi > 25 && bmi <= 30;
              if (isNormalBMI) {
                return StringsManager.normalBmi;
              } else if (isUnderWeight) {
                return StringsManager.underWeightBmi;
              } else if (isOverWeight) {
                return StringsManager.overWeightBmi;
              } else {
                return StringsManager.dangerousBmi;
              }
            }

            return Padding(
              padding: const EdgeInsets.only(
                left: PaddingManager.p12,
                right: PaddingManager.p12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: deviceWidth / 3 - 16,
                    height: SizeManager.s212,
                    decoration: BoxDecoration(
                      color: ColorManager.black87,
                      borderRadius: BorderRadius.circular(RadiusManager.r15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: PaddingManager.p12,
                            bottom: PaddingManager.p12,
                          ),
                          child: CircularPercentIndicator(
                            circularStrokeCap: CircularStrokeCap.round,
                            radius: RadiusManager.r40,
                            lineWidth: SizeManager.s8,
                            percent: bmi / 40,
                            progressColor: getProgressColor(bmi),
                            backgroundColor: ColorManager.grey3,
                            animateFromLastPercent: true,
                            center: Icon(
                              Icons.favorite_border,
                              color: getProgressColor(bmi),
                              size: SizeManager.s28,
                            ),
                          ),
                        ),
                        Text(
                          'BMI ${bmi.toStringAsFixed(1)}',
                          textAlign: TextAlign.center,
                          style: StyleManager.homePageS20BoldWhite,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: PaddingManager.p12,
                            bottom: PaddingManager.p12,
                          ),
                          child: Text(
                            getMessage(bmi),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: ColorManager.white2,
                              fontSize: FontSize.s12,
                              fontWeight: FontWightManager.regular,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: PaddingManager.p12,
                          bottom: PaddingManager.p12,
                        ),
                        child: Container(
                          height: SizeManager.s100,
                          width: deviceWidth * (2 / 3) - 20,
                          decoration: BoxDecoration(
                            color: ColorManager.limerGreen2,
                            borderRadius: BorderRadius.circular(
                              RadiusManager.r15,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                StringsManager.kcalConsumption,
                                style: StyleManager.homePageS18BoldDarkGrey,
                              ),
                              Text(
                                bmr.toStringAsFixed(0),
                                style: StyleManager.homePageS20BoldDarkGrey,
                              ),
                              const Text(
                                StringsManager.kcalPerDay,
                                style: StyleManager.homePageS16RegularDarkGrey,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: PaddingManager.p12,
                                right: PaddingManager.p12),
                            child: Container(
                              width: deviceWidth / 3 - 16,
                              height: SizeManager.s100,
                              decoration: BoxDecoration(
                                color: ColorManager.black87,
                                borderRadius:
                                    BorderRadius.circular(RadiusManager.r15),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: PaddingManager.p12,
                                      right: PaddingManager.p12,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                          StringsManager.water,
                                          style:
                                              StyleManager.homePageS18BoldWhite,
                                        ),
                                        Icon(
                                          Icons.water_drop_outlined,
                                          size: SizeManager.s28,
                                          color: ColorManager.limerGreen2,
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: PaddingManager.p12,
                                      right: PaddingManager.p12,
                                      top: PaddingManager.p12,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          consumptionProvider.waterADay
                                              .toStringAsFixed(1),
                                          style:
                                              StyleManager.homePageS20BoldWhite,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              left: PaddingManager.p12),
                                          child: Text(
                                            StringsManager.liters,
                                            style: StyleManager
                                                .homePageS12RegularWhite2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: deviceWidth / 3 - 16,
                            height: SizeManager.s100,
                            decoration: BoxDecoration(
                              color: ColorManager.black87,
                              borderRadius:
                                  BorderRadius.circular(RadiusManager.r15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: PaddingManager.p12,
                                    right: PaddingManager.p12,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        StringsManager.calories,
                                        style:
                                            StyleManager.homePageS18BoldWhite,
                                      ),
                                      Icon(
                                        Icons.local_pizza_outlined,
                                        size: SizeManager.s28,
                                        color: ColorManager.limerGreen2,
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: PaddingManager.p12,
                                    right: PaddingManager.p12,
                                    top: PaddingManager.p12,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        consumptionProvider.kCalaDay
                                            .toStringAsFixed(0),
                                        style:
                                            StyleManager.homePageS20BoldWhite,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: PaddingManager.p12),
                                        child: Text(
                                          StringsManager.kcal,
                                          style: StyleManager
                                              .homePageS12RegularWhite2,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        });
  }
}