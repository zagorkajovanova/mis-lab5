// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../model/exam.dart';

class CalendarScreen extends StatelessWidget{
  static const String idScreen = "calendarScreen";
  final List<Exam> _termini;

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

List<Exam> _getDataSource(List<Exam> _termini) {
  final List<Exam> scheduledExams = _termini;
  return scheduledExams;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Exam> source) {
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


