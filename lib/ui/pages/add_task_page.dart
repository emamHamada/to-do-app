import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../theme.dart';
import '../widgets/reused/button.dart';
import '../widgets/reused/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final  _taskController = Get.put(TaskController());
  final  _titleController = TextEditingController();
  final  _noteController = TextEditingController();

  DateTime _selectedDateTime = DateTime.now();
  String startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();
  int _selectedRemind = 5;
  final List<int> _remindList = [5, 10, 15, 20];
  String _selectedRepeat = 'None';
  final List<String> _repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  int _selectedColor = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _buildAppBar(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "Add Task",
                  style: semiLargeHeadingStyle,
                ),
                InputField(
                  label: ' Title',
                  note: 'Enter Title',
                  controller: _titleController,
                ),
                InputField(
                  label: ' Note',
                  note: 'Enter your Note',
                  controller: _noteController,
                ),
                InputField(
                  label: ' Date',
                  note: DateFormat.yMd().format(_selectedDateTime),
                  widget: IconButton(
                    onPressed: () => _getDateFromUser(),
                    icon: const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: InputField(
                        label: 'Start Time',
                        note: startTime,
                        widget: IconButton(
                          onPressed: () => _getTimeFromUser(isStartTime: true),
                          icon: const Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: InputField(
                        label: 'End Time',
                        note: endTime,
                        widget: IconButton(
                          onPressed: () => _getTimeFromUser(isStartTime: false),
                          icon: const Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                InputField(
                  label: ' Remind',
                  note: '${_selectedRemind.toString()}   minutes early',
                  widget: DropdownButton(
                    borderRadius: BorderRadius.circular(15),
                    dropdownColor: Colors.blueGrey,
                    onChanged: (int? newValue) {
                      setState(() {
                        _selectedRemind = newValue!;
                      });
                    },
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                      size: 26,
                    ),
                    underline: Container(
                      height: 0,
                    ),
                    elevation: 4,
                    items: _remindList
                        .map(
                          (valueReminded) => DropdownMenuItem(
                            value: valueReminded,
                            child: Text("$valueReminded", style: headingStyle),
                          ),
                        )
                        .toList(),
                  ),
                ),
                InputField(
                  label: 'Repeat',
                  note: '${_selectedRepeat.toString()} ',
                  widget: DropdownButton(
                    borderRadius: BorderRadius.circular(15),
                    dropdownColor: Colors.blueGrey,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRepeat = newValue!;
                      });
                    },
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                      size: 26,
                    ),
                    underline: Container(
                      height: 0,
                    ),
                    elevation: 4,
                    items: _repeatList
                        .map(
                          (valueReminded) => DropdownMenuItem(
                            value: valueReminded,
                            child: Text(valueReminded, style: headingStyle),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    colorPalette(),
                    MyButton(
                      onTap: () {
                        // setState(() {
                        _validateData();
                        //   if (_formKey.currentState!.validate()) {}
                        // });
                      },
                      label: 'Create Task',
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? _pickedTime = await showTimePicker(
      helpText: "ادخل الوقت لتحرير التذكير",
      cancelText: "خروج",
      confirmText: "تأكيد",
      minuteLabelText: "دقائق",
      hourLabelText: "ساعات",
      errorInvalidText: "تاكد من ان الوقت الذي ادخلته صحيح",
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(
              DateTime.now().add(
                const Duration(minutes: 15),
              ),
            ),
    );
    String _formatedTime = _pickedTime!.format(context);
    if (isStartTime) {
      setState(() {
        startTime = _formatedTime;
      });
    } else if (!isStartTime) {
      setState(() {
        endTime = _formatedTime;
      });
    } else {
      debugPrint("it's null or something wrong!");
    }
  }

  _getDateFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(3000));
    if (_pickedDate != null) {
      setState(() {
        _selectedDateTime = _pickedDate;
      });
    } else {
      debugPrint("it's null or something wrong!");
    }
  }

  AppBar _buildAppBar() => AppBar(
        //to go back just use GET X expressions to do this easy.
        //catch this error in your mind just you must put the get in the place to hold the hole project material app of the all project
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Get.isDarkMode ? Colors.white : darkGreyClr,
            )),
        backgroundColor: context.theme.backgroundColor,
        elevation: 0,
        actions: const [
          CircleAvatar(
            backgroundImage: AssetImage("assets/icons/icons/a1024.png"),
            radius: 24,
          ),
          SizedBox(
            width: 10,
          )
        ],
      );

  _validateData() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTasksToDatabase();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar("Required", "All fields are required",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.white,
          colorText: pinkClr,
          icon: const Icon(
            Icons.warning_amber_outlined,
            size: 25,
            color: Colors.red,
          ));
    } else {
      debugPrint("SOME THING GO WRONG!!");
    }
  }

  _addTasksToDatabase() async{
    //الفاليو هو الاي دي هنا
    int? value =await _taskController.addTask(
      task: Task(
        title:  _titleController.text,
        note: _noteController.text,
        isCompleted: 0,
        date: DateFormat.yMd().format(_selectedDateTime),
        startTime: startTime,
        endTime: endTime,
        color: _selectedColor,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
      ),
    );
    debugPrint("id ==>$value");
  }

  Column colorPalette() {
    return Column(
      crossAxisAlignment:CrossAxisAlignment.start ,
      children: [
        Text(
          "Color",
          style: titleStyle,
        ),
        const SizedBox(
          height: 8,
        ),
        Wrap(
          children: List<Widget>.generate(
            3,
            (index) => Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = index;
                  });
                },
                child: CircleAvatar(
                  radius: 15,
                  child: _selectedColor == index
                      ? const Icon(
                          Icons.done,
                          color: Colors.white,
                        )
                      : null,
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                          ? pinkClr
                          : orangeClr,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
