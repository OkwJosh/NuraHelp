import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/common/custom_switch/custom_switch.dart';
import 'package:nurahelp/app/features/main/screens/symptom_insights/widget/symptom_dropdown.dart';
import 'package:nurahelp/app/features/main/screens/symptom_insights/widget/symptoms_trend_chart.dart';
import 'package:nurahelp/app/utilities/constants/colors.dart';
import 'package:nurahelp/app/utilities/constants/icons.dart';
import 'package:nurahelp/app/utilities/constants/svg_icons.dart';
import 'package:nurahelp/app/utilities/validators/validation.dart';
import '../../../../common/appbar/appbar_with_bell.dart';
import '../../controllers/symptom_insight_controller/symptom_insight_controller.dart';

class SymptomInsightsScreen extends StatelessWidget {
  const SymptomInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _controller = Get.put(SymptomInsightController());
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: AppBarWithBell(showSearchBar: true),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Log Today's Symptoms
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              elevation: 0.1,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 15,
                ),
                child: Column(
                  children: [
                    Text(
                      'Log Today\'s Symptoms',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Poppins-SemiBold',
                      ),
                    ),
                    const SizedBox(height: 15),
                    Obx(
                      () => ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _controller
                            .uniqueSymptoms
                            .length, // Use unique symptoms
                        separatorBuilder: (_, __) => SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final symptom = _controller
                              .uniqueSymptoms[index]; // Use unique symptoms
                          return SymptomDropdown(
                            symptomName: symptom.symptomName,
                            selectedValue: symptom.value.toString(),
                            menuItems: [
                              '0',
                              '1',
                              '2',
                              '3',
                              '4',
                              '5',
                              '6',
                              '7',
                              '8',
                              '9',
                              '10',
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                // Find and update ALL instances of this symptom name
                                for (
                                  int i = 0;
                                  i < _controller.symptoms.length;
                                  i++
                                ) {
                                  if (_controller.symptoms[i].symptomName ==
                                      symptom.symptomName) {
                                    _controller.symptoms[i].value = int.parse(
                                      value,
                                    );
                                  }
                                }
                                _controller.symptoms.refresh();

                                _controller.generateSpots(_controller.symptoms);
                              }
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => addNewSymptom(context, _controller),
                          icon: Icon(
                            Icons.add,
                            color: AppColors.secondaryColor,
                          ),
                          label: Text(
                            'Add',
                            style: TextStyle(
                              color: AppColors.secondaryColor,
                              fontFamily: 'Poppins-Medium',
                              fontSize: 16,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.secondaryColor),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => _controller.logSymptoms(),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Symptom Trends
            Material(
              elevation: 1,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Symptom Trends',
                              style: TextStyle(
                                fontFamily: 'Poppins-Medium',
                                fontSize: 20,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 35,
                            width: 90,
                            child: CustomSwitch(
                              firstOptionText: '1W',
                              secondOptionText: '1M',
                              onChanged: (option) {
                                // option 1 = 1W (daily), option 2 = 1M (monthly)
                                _controller.isMonthlyView.value = (option == 2);
                                _controller.generateSpots(_controller.symptoms);
                                _controller.chartTrigger.value++;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SymptomTrendChart(controller: _controller),
                    const SizedBox(height: 5),
                    _buildTrendLegend(context, controller: _controller),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // // Symptom Insights List
            // Material(
            //   elevation: 1,
            //   borderRadius: BorderRadius.circular(10),
            //   child: Container(
            //     padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //     child: Column(
            //       children: const [
            //         SymptomInsightListTile(),
            //         SymptomInsightListTile(),
            //         SymptomInsightListTile(),
            //         SymptomInsightListTile(showBottomBorder: false),
            //       ],
            //     ),
            //   ),
            // ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendLegend(
    BuildContext context, {
    required SymptomInsightController controller,
  }) {
    return Obx(
      () => GridView.builder(
        shrinkWrap: true,

        physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        itemCount: controller.uniqueSymptoms.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 130,
          mainAxisSpacing: 10,
          childAspectRatio: 5,
        ),
        itemBuilder: (context, index) {
          final symptom = controller.uniqueSymptoms[index].symptomName;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!controller.symptomColors.containsKey(symptom)) {
              controller.symptomColors[symptom] = controller
                  .assignColorForSymptom(symptom);
              controller.symptomColors.refresh();
            }
          });
          return Obx(
            () => Row(
              children: [
                CircleAvatar(
                  radius: 7,
                  backgroundColor:
                      controller.symptomColors[symptom] ?? Colors.grey,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    symptom,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins-Regular',
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

void addNewSymptom(BuildContext context, SymptomInsightController controller) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        elevation: 2,
        insetPadding: const EdgeInsets.symmetric(horizontal: 26),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [SvgIcon(AppIcons.health)]),
                const SizedBox(height: 8),
                Text(
                  'Add Symptom',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.black,
                    fontFamily: 'Poppins-SemiBold',
                  ),
                ),
                SizedBox(height: 30),
                Form(
                  key: controller.symptomKey,
                  child: TextFormField(
                    controller: controller.symptomText,
                    validator: (value) =>
                        AppValidator.validateTextField('Symptom', value),
                    cursorColor: Colors.black,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 14,
                      fontFamily: 'Poppins-ExtraLight',
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Symptom name',
                      hintStyle: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          overlayColor: AppColors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => controller.addSymptom(),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        child: const Text(
                          'Add Symptom',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
