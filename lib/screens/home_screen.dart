import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lab_mis/screens/calendar_screen.dart';
import 'package:lab_mis/screens/signin_screen.dart';
import 'package:lab_mis/screens/google_map_screen.dart';
import 'package:lab_mis/services/notification_service.dart';

import '../model/termin.dart';
import '../widgets/createNewElement.dart';
import 'package:firebase_auth/firebase_auth.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


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

  final List<Termin> _termini = [
    Termin(
        id: "1",
        name: "MIS Mobile information systems",
        date:  DateTime.parse("2022-12-29 15:00:00")),
    Termin(
        id: "2",
        name: "OOP Object oriented programming",
        date: DateTime.parse("2022-12-13 15:00:00"),),
    Termin(
        id: "3",
        name: "HCI Design of human-computer interaction",
        date: DateTime.parse("2023-03-20 15:00:00"),),
    Termin(
        id: "4",
        name: "DS Data Science",
        date: DateTime.parse("2023-03-03 13:30:00"),)
  ];

  void _showModal(BuildContext ctx){
    showModalBottomSheet(
      context: ctx, 
      builder: (_){
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: createNewElement(_addNewTermin),
        );
      }
    );
  }

  void _addNewTermin(Termin termin){
    setState(() {
      _termini.add(termin);
    });
  }

  void _deleteTermin(String id){
    setState(() {
      _termini.removeWhere((termin) => termin.id == id);
    });
  }

  String _modifyDate(DateTime date){

    String dateString = DateFormat("yyyy-MM-dd HH:mm:ss").format(date);
    List<String> dateParts = dateString.split(" ");
    String modifiedTime = dateParts[1].substring(0,5);

    return dateParts[0] + ' | ' + modifiedTime + 'h';
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
          child: _termini.isEmpty
              ? Text("No exams scheduled")
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _termini.length,
                  itemBuilder: (ctx, index) {
                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                      child: ListTile(
                        tileColor: Colors.green[100],
                        title: Text(
                          _termini[index].name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          _modifyDate(_termini[index].date),
                          style: TextStyle(color: Colors.grey),
                        ),
                        trailing: IconButton(
                          onPressed: () => _deleteTermin(_termini[index].id),
                          icon: Icon(Icons.delete_outline)),
                      ),
                    );
                  },
                ),
              ),
            ElevatedButton.icon(
                icon: Icon(Icons.calendar_month_outlined, size: 30,),
                label: Text("Calendar", style: TextStyle(fontSize: 20),),
                onPressed: (){
                  Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => CalendarScreen(_termini)));
                },
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.map_outlined, size: 30,),
                label: Text("Show Map", style: TextStyle(fontSize: 20),),
                onPressed: (){
                  Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => MapScreen()));
                },
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