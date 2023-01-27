// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../model/termin.dart';

class CalendarScreen extends StatelessWidget{
  static const String idScreen = "calendarScreen";
  final List<Termin> _termini;

  CalendarScreen(this._termini);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Calendar"),
      ),
      body: Container(
        child: SfCalendar(
          view: CalendarView.month,
          dataSource: MeetingDataSource(_getDataSource(_termini)),
          monthViewSettings: MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment
          ),
          firstDayOfWeek: 1,
          showDatePickerButton: true,
        ),
      )
    );
  }
}

List<Termin> _getDataSource(List<Termin> _termini) {
  final List<Termin> scheduledExams = _termini;
  return scheduledExams;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Termin> source) {
    appointments = source;
  }

  @override
  String getSubject(int index) {
    return appointments![index].name;
  }

  @override
  DateTime getStartTime(int index){
    return appointments![index].date;
  }
  @override
  DateTime getEndTime(int index) {
    return appointments![index].date;
  }

}


