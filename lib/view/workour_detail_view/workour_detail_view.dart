import 'package:flutter_application_1/common_widgets/round_gradient_button.dart';
import 'package:flutter_application_1/utils/app_colors.dart';
import 'package:flutter_application_1/view/on_boarding/start_screen.dart';
import 'package:flutter_application_1/view/workour_detail_view/widgets/exercises_set_section.dart';
import 'package:flutter_application_1/view/workour_detail_view/widgets/icon_title_next_row.dart';
import 'package:flutter_application_1/view/workout_schedule_view/workout_schedule_view.dart';
import 'package:flutter/material.dart';
import 'start_workout.dart';
import '../../common_widgets/round_button.dart';
import 'exercises_stpe_details.dart';

class WorkoutDetailView extends StatefulWidget {
  final Map dObj;
  const WorkoutDetailView({Key? key, required this.dObj}) : super(key: key);

  @override
  State<WorkoutDetailView> createState() => _WorkoutDetailViewState();
}

class _WorkoutDetailViewState extends State<WorkoutDetailView> {
  // This list holds all possible exercises, structured by workout type
  List exercisesArr = [
    {
      "name": "Set 1",
      "set": [
        {
          "image": "assets/images/img_1.png",
          "title": "Jumping Jacks",
          "value": "3sets\n12x",
        },
        {
          "image": "assets/images/img_2.png",
          "title": "Lunges",
          "value": "3sets\n12x",
        },
        {
          "image": "assets/images/img_1.png",
          "title": "Push-Ups",
          "value": "3sets\n12x",
        },
        {"image": "assets/images/img_2.png", "title": "Squats", "value": "20x"},
        {
          "image": "assets/images/img_1.png",
          "title": "Plank",
          "value": "3sets\n12x",
        },
        {
          "image": "assets/images/img_2.png",
          "title": "Glute Bridges",
          "value": "02:00",
        },
      ],
    },
    {
      "name": "Set 2",
      "set": [
        {
          "image": "assets/images/img_1.png",
          "title": "Mountain Climbers",
          "value": "3sets\n12x",
        },
        {
          "image": "assets/images/img_2.png",
          "title": "Daimoind Push Up",
          "value": "3sets\n12x",
        },
        {
          "image": "assets/images/img_1.png",
          "title": "Lateral Raises",
          "value": "3sets\n12x",
        },
        {"image": "assets/images/img_2.png", "title": "Squats", "value": "20x"},
        {
          "image": "assets/images/img_1.png",
          "title": "Superman Hold",
          "value": "3sets\n12x",
        },
        {
          "image": "assets/images/img_2.png",
          "title": "Burpees",
          "value": "3sets\n12x",
        },
      ],
    },
        {
      "name": "Lower Body Workout", 
      "set": [
        {
          "image": "assets/images/img_1.png",
          "title": "Squats",
          "value": "3sets\n20x",
        },
        {
          "image": "assets/images/img_2.png",
          "title": "Lunges",
          "value": "3sets\n15x",
        },
        {
          "image": "assets/images/img_1.png",
          "title": "Leg Press",
          "value": "3sets\n15x",
        },
        {
          "image": "assets/images/img_2.png",
          "title": "Calf Raises",
          "value": "3sets\n20x",
        },
        {
          "image": "assets/images/img_1.png",
          "title": "Glute Bridges",
          "value": "3sets\n20x",
        },
        {
          "image": "assets/images/img_2.png",
          "title": "Hamstring Curls",
          "value": "3sets\n15x",
        },
        {
          "image": "assets/images/img_1.png",
          "title": "Step-Ups",
          "value": "3sets\n20x",
        },
        {
          "image": "assets/images/img_2.png",
          "title": "Leg Extensions",
          "value": "3sets\n15x",
        },
        {
          "image": "assets/images/img_1.png",
          "title": "Bulgarian Split Squat",
          "value": "3sets\n12x",
        },
        {
          "image": "assets/images/img_2.png",
          "title": "Deadlifts",
          "value": "3sets\n15x",
        },
        {
          "image": "assets/images/img_1.png",
          "title": "Sumo Squats",
          "value": "3sets\n20x",
        },
        {
          "image": "assets/images/img_2.png",
          "title": "Hip Thrusts",
          "value": "3sets\n15x",
        },
      ],
    },
    {
      "name": "Abs Workout", // Corresponds to "AB Workout" in ActivityScreen
      "set": [
        {
          "image": "assets/images/img_1.png",
          "title": "Crunches",
          "value": "3sets\n15x",
        },
        {
          "image": "assets/images/img_2.png",
          "title": "Leg Raises",
          "value": "3sets\n15x",
        },
        {
          "image": "assets/images/img_1.png",
          "title": "Plank",
          "value": "1:00",
        },
        {
          "image": "assets/images/img_2.png",
          "title": "Bicycle Crunches",
          "value": "3sets\n15x",
        },
        {
          "image": "assets/images/img_1.png",
          "title": "Russian Twists",
          "value": "3sets\n20x",
        },
        {
          "image": "assets/images/img_2.png",
          "title": "Mountain Climbers",
          "value": "3sets\n20x",
        },
        {
          "image": "assets/images/img_1.png",
          "title": "Side Plank",
          "value": "0:30",
        },
        {
          "image": "assets/images/img_2.png",
          "title": "Flutter Kicks",
          "value": "3sets\n20x",
        },
        {
          "image": "assets/images/img_1.png",
          "title": "V-Ups",
          "value": "3sets\n15x",
        },
        {
          "image": "assets/images/img_2.png",
          "title": "Toe Touches",
          "value": "3sets\n20x",
        },
        {
          "image": "assets/images/img_1.png",
          "title": "Reverse Crunches",
          "value": "3sets\n15x",
        },
        {
          "image": "assets/images/img_2.png",
          "title": "Leg Scoops",
          "value": "3sets\n15x",
        },
      ],
    },
  ];

  // This list will hold the exercises for the currently selected workout
  List filteredExercises = [];

  @override
  void initState() {
    super.initState();
    // Filter exercises when the widget is initialized
    filterExercises();
  }

  void filterExercises() {
    // Get the title of the selected workout from the passed object
    String selectedWorkoutTitle = widget.dObj["title"].toString();

    // Clear the previously filtered list
    filteredExercises.clear();

    // Logic to filter exercises based on the selected workout title
    if (selectedWorkoutTitle == "Fullbody Workout") {
      // Add exercises from "Set 1" and "Set 2" for Fullbody Workout
      for (var workoutSet in exercisesArr) {
        if (workoutSet["name"] == "Set 1" || workoutSet["name"] == "Set 2") {
          filteredExercises.add(workoutSet);
        }
      }
    } else if (selectedWorkoutTitle == "Lowebody Workout") {
      // Add exercises from "Lower Body Workout"
      for (var workoutSet in exercisesArr) {
        if (workoutSet["name"] == "Lower Body Workout") {
          filteredExercises.add(workoutSet);
        }
      }
    } else if (selectedWorkoutTitle == "AB Workout") {
      // Add exercises from "Abs Workout"
      for (var workoutSet in exercisesArr) {
        if (workoutSet["name"] == "Abs Workout") {
          filteredExercises.add(workoutSet);
        }
      }
    }

    // Update the state to rebuild the UI with filtered exercises
    setState(() {});
  }


  List youArr = [
    {"image": "assets/icons/barbell.png", "title": "Barbell"},
    {"image": "assets/icons/skipping_rope.png", "title": "Skipping Rope"},
    {"image": "assets/icons/bottle.png", "title": "Bottle 1 Liters"},
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: AppColors.primaryG),
      ),
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
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
                    "assets/icons/back_icon.png",
                    width: 15,
                    height: 15,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              actions: [
                InkWell(
                  onTap: () {},
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
                      "assets/icons/more_icon.png",
                      width: 15,
                      height: 15,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
            SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
              leadingWidth: 0,
              leading: Container(),
              expandedHeight: media.width * 0.5,
              flexibleSpace: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/detail_top.png",
                  width: media.width * 0.75,
                  height: media.width * 0.8,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ];
        },
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        width: 50,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.grayColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      SizedBox(height: media.width * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.dObj["title"].toString(),
                                  style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  "${widget.dObj["exercises"].toString()} | ${widget.dObj["time"].toString()} | 320 Calories Burn",
                                  style: TextStyle(
                                    color: AppColors.grayColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Image.asset(
                              "assets/icons/fav_icon.png",
                              width: 15,
                              height: 15,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: media.width * 0.05),
                      IconTitleNextRow(
                        icon: "assets/icons/time_icon.png",
                        title: "Schedule Workout",
                        time: "5/27, 09:00 AM",
                        color: AppColors.primaryColor2.withOpacity(0.3),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            WorkoutScheduleView.routeName,
                          );
                        },
                      ),
                      SizedBox(height: media.width * 0.02),
                      IconTitleNextRow(
                        icon: "assets/icons/difficulity_icon.png",
                        title: "Difficulity",
                        time: "Beginner",
                        color: AppColors.secondaryColor2.withOpacity(0.3),
                        onPressed: () {},
                      ),
                      SizedBox(height: media.width * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "You'll Need",
                            style: TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "${youArr.length} Items",
                              style: TextStyle(
                                color: AppColors.grayColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.5,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: youArr.length,
                          itemBuilder: (context, index) {
                            var yObj = youArr[index] as Map? ?? {};
                            return Container(
                              margin: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: media.width * 0.35,
                                    width: media.width * 0.35,
                                    decoration: BoxDecoration(
                                      color: AppColors.lightGrayColor,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      yObj["image"].toString(),
                                      width: media.width * 0.2,
                                      height: media.width * 0.2,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      yObj["title"].toString(),
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: media.width * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Exercises",
                            style: TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            // Display the number of filtered sets
                            child: Text(
                              "${filteredExercises.length} Sets",
                              style: TextStyle(
                                color: AppColors.grayColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Use the filteredExercises list for the ListView
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: filteredExercises.length,
                        itemBuilder: (context, index) {
                          var sObj = filteredExercises[index] as Map? ?? {};
                          return ExercisesSetSection(
                            sObj: sObj,
                            onPressed: (obj) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          ExercisesStepDetails(eObj: obj),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      SizedBox(height: media.width * 0.1),
                    ],
                  ),
                ),
                SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RoundGradientButton(
                        title: "Start Workout",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => WorkoutTimerScreen(
                                workoutExercises: filteredExercises
                                    .expand((set) => set["set"] as List<Map>)
                                    .toList(),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
