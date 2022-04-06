import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_app/ui/size_config.dart';
import 'package:to_do_app/ui/theme.dart';

import '../../../models/task.dart';

class TaskTile extends StatelessWidget {
  const TaskTile(this.task);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(
          SizeConfig.orientation == Orientation.landscape ? 8 : 15,
        ),
      ),
      width: SizeConfig.orientation == Orientation.landscape
          ? SizeConfig.screenWidth / 2
          : SizeConfig.screenWidth,
      margin: EdgeInsets.only(bottom: getProportionateScreenHeight(12)),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _getBGColor(task.color),
        ),
        child: Row(
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title!,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey[500],
                        size: 18,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Text(
                        '${task.startTime} - ${task.endTime},',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[300],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      IconButton(
                          onPressed: () {
                           // dialogeToUpdate(task);
                          },
                          icon: const Icon(Icons.edit))
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    (task.note!).toString(),
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            )),
            //As A divider
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 60,
              width: .5,
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                task.isCompleted == 0 ? 'TODO' : 'COMPLETED',
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void dialogeToUpdate(Task task) {
  //
  //    Get.defaultDialog(
  //       title:"Update",
  //       titlePadding: const EdgeInsets.all(10),
  //       content: Column(children:  [
  //         InputField(label: 'Title', note:task.title ),
  //         InputField(label: 'Note', note: task.note,),
  //
  //       ],),
  //       contentPadding: const EdgeInsets.all(10),
  //       onCancel: (){()=>Get.back();},
  //     onConfirm: ()async{
  //         var db=TaskController();
  //        await db.updateAll(task:Task(title: ,note: ,color: task.color,date:task.repeat,endTime:task.endTime ,isCompleted: ,remind: ,repeat: ,startTime: ,));
  //     }
  //   );
  // }

  _getBGColor(int? color) {
    switch (color) {
      case 0:
        return bluishClr;
      case 1:
        return pinkClr;
      case 2:
        return orangeClr;
      default:
        return bluishClr;
    }
  }
}
