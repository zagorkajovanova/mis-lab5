import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lab_mis/model/location.dart';
import 'package:lab_mis/screens/calendar_screen.dart';
import 'package:lab_mis/screens/signin_screen.dart';
import 'package:lab_mis/screens/google_map_screen.dart';
import 'package:lab_mis/services/notification_service.dart';

import '../model/exam.dart';
import '../widgets/createNewElement.dart';
import 'package:firebase_auth/firebase_auth.dart';


class HomeScreen extends StatefulWidget{
  static const String idScreen = "mainScreen";

  @override
  _HomeScreenState createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen>{

  late final NotificationService service;

  @override
  void initState(){
    service = NotificationService();
    service.initialize();
    super.initState();
  }

  final List<Exam> _exams = [
    Exam(
        id: "1",
        name: "MIS Mobile information systems",
        date:  DateTime.parse("2022-12-29 15:00:00"),
        location: Location(latitude: 42.0043165, longitude: 21.4096452)),
    Exam(
        id: "2",
        name: "HCI Design of human-computer interaction",
        date: DateTime.parse("2023-03-20 15:00:00"),
        location: Location(latitude: 42.004400, longitude: 21.408918)),
    Exam(
        id: "4",
        name: "DS Data Science",
        date: DateTime.parse("2023-03-03 13:30:00"),
        location: Location(latitude: 42.004906, longitude: 21.409890)),
  ];


  void _showModal(BuildContext ctx){
    showModalBottomSheet(
      context: ctx, 
      builder: (_){
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: createNewElement(_addNewExam),
        );
      }
    );
  }

  void _addNewExam(Exam termin){
    setState(() {
      _exams.add(termin);
    });
  }

  void _deleteTermin(String id){
    setState(() {
      _exams.removeWhere((termin) => termin.id == id);
    });
  }

  String _modifySubtitle(DateTime date, Location location){
    String subjectLocation = '';

    if(location.latitude == 42.0043165 && location.longitude == 21.4096452){
       subjectLocation = "FINKI";
    }else if(location.latitude == 42.004400 && location.longitude == 21.408918){
       subjectLocation = "FEIT";
    }else {
       subjectLocation = "TMF";
    }

    String dateString = DateFormat("yyyy-MM-dd HH:mm:ss").format(date);
    List<String> dateParts = dateString.split(" ");
    String modifiedTime = dateParts[1].substring(0,5);

    return dateParts[0] + ' | ' + modifiedTime + 'h | ' + subjectLocation;
  }

  Future _signOut() async{
    try {
      await FirebaseAuth.instance.signOut().then((value) {
        print("User signed out");
        Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));
      });
    } on FirebaseAuthException catch (e){
        print("ERROR HERE");
        print(e.message);
    }
  }

  PreferredSizeWidget _createAppBar(BuildContext context){
    //final user = FirebaseAuth.instance.currentUser?.email;
    return AppBar(
        title: Text("Upcoming exams"),
        actions:[
          IconButton(
            icon: Icon(Icons.add_box_outlined),
            onPressed: () => _showModal(context),),
          ElevatedButton(
            child: Text("Sign out"),
            onPressed: _signOut,
          )
        ],
      );
  }

  Widget _createBody(BuildContext context){
    return Container(
      child: SingleChildScrollView(
        child: Column(
        children: <Widget>[
          Center(
          child: _exams.isEmpty
              ? Text("No exams scheduled")
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _exams.length,
                  itemBuilder: (ctx, index) {
                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                      child: ListTile(
                        tileColor: Colors.green[100],
                        title: Text(
                          _exams[index].name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          _modifySubtitle(_exams[index].date, _exams[index].location),
                          style: TextStyle(color: Colors.grey),
                        ),
                        trailing: IconButton(
                          onPressed: () => _deleteTermin(_exams[index].id),
                          icon: Icon(Icons.delete_outline)),
                      ),
                    );
                  },
                ),
              ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.all(5),
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.calendar_month_outlined, size: 30,),
                      label: Text("Calendar", style: TextStyle(fontSize: 20),),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(10),
                      ),
                      onPressed: (){
                        Navigator.push(context, 
                        MaterialPageRoute(builder: (context) => CalendarScreen(_exams)));
                      },
                   ),
                  ),
                Container(
                   margin: EdgeInsets.all(5),
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.map_outlined, size: 30,),
                    label: Text("Show Map", style: TextStyle(fontSize: 20),),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(10),
                    ),
                    onPressed: (){
                      Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => MapScreen(_exams)));
                    },
                  ),
                )
              ],
              ),
            ),
            ElevatedButton.icon(
                icon: Icon(Icons.notifications, size: 30,),
                label: Text("Show Local Notification", style: TextStyle(fontSize: 20),),
                onPressed: () async{
                  await service.showNotification(id: 0, title: 'You have upcoming exams', body: 'Check your calendar');
                },
            ),
            ElevatedButton.icon(
                icon: Icon(Icons.notifications_paused_sharp, size: 30,),
                label: Text("Schedule Notification", style: TextStyle(fontSize: 20),),
                onPressed: () async{
                  //notification appears after 4 seconds
                  await service.showScheduledNotification(id: 0, title: 'You have upcoming exams', body: 'Check your calendar', seconds: 4);
                },
              ),
        ],
      ),
      )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _createAppBar(context),
      body: _createBody(context),
    );
  }
}