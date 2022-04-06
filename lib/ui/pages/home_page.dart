import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/db/db_helper.dart';
import 'package:to_do_app/services/theme_services.dart';
import 'package:to_do_app/ui/size_config.dart';
import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../../services/notification_services.dart';
import '../theme.dart';
import '../widgets/reused/button.dart';
import '../widgets/reused/task_tile.dart';
import 'add_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var icon = const Icon(Icons.light_mode);
  final TaskController _taskController = Get.put(TaskController());
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotifyHelper().initializeNotification();
    _taskController.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor:
          Get.isDarkMode ? context.theme.backgroundColor : Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _addTaskBar(),
              _addDateBar(),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: _showTasks(),
              )
            ],
          ),
        ),
      ),
    );
  }

  _showBottomSheet(Task task, BuildContext context) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 5),
          width: SizeConfig.screenWidth,
          height: (SizeConfig.orientation == Orientation.landscape)
              ? SizeConfig.screenHeight * .6
              : SizeConfig.screenHeight * .30,
          color: Get.isDarkMode ? darkHeaderClr : Colors.white,
          child: Column(
            children: [
              Flexible(
                child: Container(
                  height: 6,
                  width: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:
                          Get.isDarkMode ? Colors.grey[600] : Colors.grey[500]),
                ),
              ),
              task.isCompleted == 1
                  ? _buildButtonsForBottomSheet(
                      onTap: () {
                        setState(() {
                          DBHelper.x = 0;
                          _taskController.updateTasks(task.id!);
                        });
                        Get.back();
                      },
                      clr: primaryClr,
                      label: 'To Do',
                    )
                  : _buildButtonsForBottomSheet(
                      onTap: () {
                        setState(() {
                          DBHelper.x = 1;
                          _taskController.updateTasks(task.id!);
                        });
                        Get.back();
                      },
                      clr: primaryClr,
                      label: 'Task Completed',
                    ),
              _buildButtonsForBottomSheet(
                onTap: () {
                  Get.defaultDialog(
                      title: "warning",
                      middleText: "you will delete a task!",
                      backgroundColor: Colors.grey,
                      titleStyle: const TextStyle(color: Colors.white),
                      middleTextStyle: const TextStyle(color: Colors.white),
                      textConfirm: "Confirm",
                      textCancel: "Cancel",
                      cancelTextColor: Colors.white,
                      confirmTextColor: Colors.white,
                      buttonColor: Colors.red,
                      radius: 50,
                      onCancel: () => Get.back(),
                      onConfirm: () {
                        _taskController.deleteTask(task);
                        NotifyHelper().cancelNotification(task);
                        Get.to(const HomePage());
                        Get.snackbar(
                            "hint", "you deleted a task from your tasks",
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.white,
                            colorText: pinkClr,
                            icon: const Icon(
                              Icons.flag,
                              size: 25,
                              color: Colors.red,
                            ));
                      });
                },
                clr: Colors.red[800],
                label: 'Delete Task ',
              ),
              // Divider(color: Colors.red[300]),
              // _buildButtonsForBottomSheet(
              //   onTap: () {
              //     Get.back();
              //   },
              //   clr: primaryClr,
              //   label: 'Cancel',
              // ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    _taskController.getTasks();
  }

  _showTasks() {
    return Obx(() {
      return RefreshIndicator(
        semanticsLabel: "refresh",
        displacement: 60,
        onRefresh: _onRefresh,
        edgeOffset: 30,
        backgroundColor: Colors.grey,
        child: ListView.builder(
          //to adjust the scroll direction
          scrollDirection: SizeConfig.orientation == Orientation.landscape
              ? Axis.horizontal
              : Axis.vertical,
          //to have the number of items
          itemCount: _taskController.taskList.length,

          itemBuilder: (BuildContext context, int index) {
            var task = _taskController.taskList[index];
            if (task.repeat == 'Daily' ||
                task.date == DateFormat.yMd().format(_selectedDate) ||
                (task.repeat == 'Weekly' &&
                    _selectedDate
                                .difference(DateFormat.yMd().parse(task.date!))
                                .inDays %
                            7 ==
                        0) ||
                (task.repeat == 'Monthly' &&
                    DateFormat.yMd().parse(task.date!).day ==
                        _selectedDate.day)) {
              // var hour = task.startTime.toString().split(':')[0];
              // var minutes = task.startTime.toString().split(':')[1];
              // debugPrint("hours $hour");
              // debugPrint("minutes $minutes");
              var date = DateFormat.jm().parse(task.startTime!);
              var myTime = DateFormat('HH:MM').format(date);
              debugPrint("my time $myTime");
              NotifyHelper().scheduledNotification(
                int.parse(myTime.toString().split(':')[0]),
                int.parse(myTime.toString().split(':')[1]),
                task,
              );
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 1500),
                child: SlideAnimation(
                  horizontalOffset: 300,
                  verticalOffset: 300,
                  child: FadeInAnimation(
                    curve: Curves.easeInOutCirc,
                    child: GestureDetector(
                      onTap: () {
                        _showBottomSheet(task, context);
                      },
                      child: TaskTile(
                        task,
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      );
    });
  }

  _buildButtonsForBottomSheet({
    required String label,
    required Function() onTap,
    required Color? clr,
    bool isClose = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Center(
          child: Text(
            label,
            style:
                isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: SizeConfig.screenWidth * .9,
        decoration: BoxDecoration(
          border: Border.all(
              width: 2,
              color: isClose
                  ? Get.isDarkMode
                      ? Colors.grey[600]!
                      : Colors.grey[300]!
                  : clr!),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
        ),
      ),
    );
  }

  _noTaskMSG() {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 2000),
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const SizedBox(height: 150),
                  SvgPicture.asset(
                    "assets/icons/icons/task.svg",
                    height: 200,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    width: 100,
                    semanticsLabel: "Task",
                    color: primaryClr?.withOpacity(.5),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10.0),
                    child: Text(
                      "You Don't have any tasks yet \n Go and add tasks !",
                      style: subtitleStyle,
                    ),
                  ),
                ],
                direction: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _addTaskBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat.yMMMMd().format(
                DateTime.now(),
              ),
              style: subHeadingStyle,
            ),
            Text(
              "ToDay",
              style: headingStyle,
            ),
          ],
        ),
        MyButton(
          //علشان يستني اللي يروح يضيف تاسك ويرجع اول ما يرجع يسمع التغيير برا وينضاف التاس للتعامل مع الداتا بيز
          onTap: () async {
            await Get.to(() => const AddTaskPage());
            _taskController.getTasks();
          },
          label: '+ Add Task',
        ),
      ],
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 8, left: 20),
      child: DatePicker(
        DateTime.now(),
        initialSelectedDate: _selectedDate,
        monthTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.blueGrey,
        )),
        dayTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.blueGrey,
        ),
        dateTextStyle: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: Colors.blueGrey,
        ),
        width: 80,
        height: 100,
        selectedTextColor: Colors.white,
        selectionColor: primaryClr!,
        onDateChange: (newDate) {
          setState(() {
            _selectedDate = newDate;
          });
        },
      ),
    );
  }

  AppBar _buildAppBar() => AppBar(
        leading: IconButton(
          onPressed: () {
            setState(() {
              ThemeServices().switchTheme();
            });
          },
          icon: Icon(
            Get.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            size: 24,
            color: Get.isDarkMode ? Colors.white : darkGreyClr,
          ),
        ),
        //to go back just use GET X expressions to do this easy.
        //catch this error in your mind just you must put the get in the place to hold the hole project material app of the all project

        backgroundColor:
            Get.isDarkMode ? context.theme.backgroundColor : Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              _taskController.taskList.isEmpty
                  ? Get.snackbar("hint", "you don't have any tasks to delete!",
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.white,
                      colorText: pinkClr,
                      icon: const Icon(
                        Icons.flag,
                        size: 25,
                        color: Colors.red,
                      ))
                  : Get.defaultDialog(
                      title: "warning",
                      middleText: "you will delete all tasks!",
                      backgroundColor: Colors.grey,
                      titleStyle: const TextStyle(color: Colors.white),
                      middleTextStyle: const TextStyle(color: Colors.white),
                      textConfirm: "Confirm",
                      textCancel: "Cancel",
                      cancelTextColor: Colors.white,
                      confirmTextColor: Colors.white,
                      buttonColor: Colors.red,
                      radius: 50,
                      onCancel: () => Get.back(),
                      onConfirm: () {
                        _taskController.deleteAllTasks();
                        NotifyHelper().cancelAllNotification();
                        Get.back();
                      });
            },
            icon: Icon(
              Icons.cleaning_services_outlined,
              size: 24,
              color: Get.isDarkMode ? Colors.white : darkGreyClr,
            ),
          ),
          const CircleAvatar(
            backgroundImage: AssetImage("assets/icons/icons/a1024.png"),
            radius: 27,
          ),
          const SizedBox(
            width: 15,
          )
        ],
      );
}
