import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_app/ui/theme.dart';

//the page to have notifications
class NotificationScreen extends StatefulWidget {
   const NotificationScreen({required this.payLoad});

  final String payLoad;

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _payload = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //to use variable from the other class you must use widget.the name of the variable .
    _payload = widget.payLoad;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:   context.theme.backgroundColor,
      appBar: AppBar(
        //to go back just use GET X expressions to do this easy.
        //catch this error in your mind just you must put the get in the place to hold the hole project material app of the all project
        leading: IconButton(
            color: Get.isDarkMode ? Colors.white : darkGreyClr,
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios)),
        backgroundColor: context.theme.backgroundColor,
        elevation: 0,
        //we extract from the payload stream the text we want by splitting it with special character and give it an index what we want to use

      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Column(
              children: [
                Text(
                  "Hello Hamada!",
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Get.isDarkMode ? Colors.white : Colors.black),
                ),
                const SizedBox(height: 10),
                Text(
                  "You have new reminder!",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      color: Get.isDarkMode ? Colors.grey[100] : darkGreyClr),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 30, right: 30),
                margin: const EdgeInsets.only(left: 30, right: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: primaryClr,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: const [
                          Icon(
                            Icons.text_format_outlined,
                            color: Colors.white,
                            size: 35,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Title",
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        _payload.toString().split('|')[0],
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: const [
                          Icon(
                            Icons.description,
                            color: Colors.white,
                            size: 35,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Description",
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        _payload.toString().split('|')[1],
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: const [
                          Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.white,
                            size: 35,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Date",
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        _payload.toString().split('|')[2],
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
