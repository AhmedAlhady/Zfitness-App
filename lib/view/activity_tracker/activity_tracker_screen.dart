import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_application_1/utils/app_colors.dart';
import 'package:flutter_application_1/view/activity_tracker/widgets/latest_activity_row.dart';
import 'package:flutter_application_1/view/activity_tracker/widgets/today_target_cell.dart';

class ActivityTrackerScreen extends StatefulWidget {
  static String routeName = "/ActivityTrackerScreen";
  const ActivityTrackerScreen({Key? key}) : super(key: key);

  @override
  State<ActivityTrackerScreen> createState() => _ActivityTrackerScreenState();
}

class _ActivityTrackerScreenState extends State<ActivityTrackerScreen> {
  int touchedIndex = -1;
  double waterIntake = 0.0;
  int stepsTaken = 0;
  final int stepsTarget = 10000;

  List<Map<String, String>> latestArr = [
    {
      "image": "assets/images/pic_4.png",
      "title": "Drinking Water",
      "time": "After your workout",
    },
    {
      "image": "assets/images/pic_5.png",
      "title": "Eat Snack (Fitbar)",
      "time": "Between meals",
    },
  ];

  /// Show dialog to add water intake
  void _addWaterIntake() async {
    TextEditingController controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Water Intake'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              hintText: 'Liters (e.g. 0.5)',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    waterIntake += double.tryParse(controller.text) ?? 0.0;
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  /// Show dialog to add steps
  void _addSteps() {
    setState(() {
      stepsTaken += 500;
      if (stepsTaken > stepsTarget) stepsTaken = stepsTarget;
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.lightGrayColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              'assets/icons/back_icon.png',
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: const Text(
          'Activity Tracker',
          style: TextStyle(
            color: AppColors.blackColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          // Water button
          InkWell(
            onTap: _addWaterIntake,
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: AppColors.primaryG),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          child: Column(
            children: [
              // Today Target
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor2.withOpacity(0.3),
                      AppColors.primaryColor1.withOpacity(0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Today Target',
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        // Steps + button
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: AppColors.primaryG),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: MaterialButton(
                              onPressed: _addSteps,
                              padding: EdgeInsets.zero,
                              height: 30,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: TodayTargetCell(
                            icon: 'assets/icons/water_icon.png',
                            value: '${waterIntake.toStringAsFixed(1)}L',
                            title: 'Water Intake',
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: TodayTargetCell(
                            icon: 'assets/icons/foot_icon.png',
                            title: 'Foot Steps',
                            customChild: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$stepsTaken / $stepsTarget',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.blackColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: stepsTaken / stepsTarget,
                                  backgroundColor: AppColors.lightGrayColor,
                                  color: AppColors.primaryColor1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: media.width * 0.1),
              // Rest unchanged...
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Activity Progress',
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    height: 35,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: AppColors.primaryG),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        items: ['Weekly', 'Monthly']
                            .map((name) => DropdownMenuItem(value: name, child: Text(name, style: const TextStyle(color: AppColors.blackColor, fontSize: 14))))
                            .toList(),
                        onChanged: (_) {},
                        icon: const Icon(Icons.expand_more, color: AppColors.whiteColor),
                        hint: const Text('Weekly', style: TextStyle(color: AppColors.whiteColor, fontSize: 12)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: media.width * 0.05),
              Container(
                height: media.width * 0.5,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
                ),
                child: BarChart(
                  BarChartData(
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: Colors.grey,
                        getTooltipItem: (group, _, rod, __) {
                          const days = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];
                          return BarTooltipItem('${days[group.x]}\n', const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), children: [TextSpan(text: '${(rod.toY - 1).toString()}', style: const TextStyle(color: AppColors.whiteColor))]);
                        },
                      ),
                      touchCallback: (event, response) => setState(() => touchedIndex = response?.spot?.touchedBarGroupIndex ?? -1),
                    ),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: getTitles, reservedSize: 38)),
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                    barGroups: showingGroups(),
                  ),
                ),
              ),
              SizedBox(height: media.width * 0.05),
              const Align(alignment: Alignment.centerLeft, child: Text("Don't forget ", style: TextStyle(color: AppColors.blackColor, fontSize: 16, fontWeight: FontWeight.w700))),
              ListView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: latestArr.length,
                itemBuilder: (context, index) => LatestActivityRow(wObj: latestArr[index]),
              ),
              SizedBox(height: media.width * 0.1),
            ],
          ),
        ),
      ),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: AppColors.grayColor, fontWeight: FontWeight.w500, fontSize: 12);
    const days = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];
    return SideTitleWidget(axisSide: meta.axisSide, space: 16, child: Text(days[value.toInt()], style: style));
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
    final values = [5,10.5,5,7.5,15,5.5,8.5];
    final colors = [AppColors.primaryG,AppColors.secondaryG];
    return BarChartGroupData(
      x: i,
      barRods: [
        BarChartRodData(
          toY: touchedIndex == i ? (values[i] + 1).toDouble() : values[i].toDouble(),
          gradient: LinearGradient(colors: colors[i % 2]),
          width: 22,
          borderSide: touchedIndex == i ? const BorderSide(color: Colors.green) : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(show: true, toY: 20, color: AppColors.lightGrayColor),
        ),
      ],
      showingTooltipIndicators: [],
    );
  });
  }