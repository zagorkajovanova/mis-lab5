// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab_mis/model/exam.dart';
import 'package:lab_mis/model/location.dart';
import 'package:nanoid/nanoid.dart';

class createNewElement extends StatefulWidget {

  final Function addTermin;
  createNewElement(this.addTermin);

  @override
  State<StatefulWidget> createState() => _NewElementState();
}

class _NewElementState extends State<createNewElement>{

  final _subjectNameController = TextEditingController();
  final _dateController = TextEditingController();
  String dropdownValue = 'FINKI';
  late Location location;

  Future? _submitData(BuildContext context){
    if(_subjectNameController.text.isEmpty || _dateController.text.isEmpty){
      return showDialog(
        context: context, 
        builder: (ctx) => AlertDialog(
        title: Text('Please fill in all the fields!'),
        actions: <Widget>[
              TextButton(
                onPressed: (() {
                  Navigator.of(context).pop();
                }), 
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text("OK"),
                )
              )
          ],
        ),
      );
    }

    int check1 = '-'.allMatches(_dateController.text).length; //should be 2
    int check2 = ':'.allMatches(_dateController.text).length; //should be 1

    if(_dateController.text.length < 16 || check1 != 2 || check2 != 1){
      print("Please enter date in the right format!");
      return showDialog(
        context: context, 
        builder: (ctx) => AlertDialog(
        title: Text('Invalid date format!'),
        content: SingleChildScrollView(
          child: Text("Please enter date in the right format."),
        ),
        actions: <Widget>[
              TextButton(
                onPressed: (() {
                  Navigator.of(context).pop();
                }), 
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text("OK"),
                )
              )
          ],
      ));
    }

    final String stringDate = _dateController.text + ':00';
    DateTime date = DateTime.parse(stringDate);

    if(dropdownValue == "FINKI"){
       location = Location(latitude: 42.0043165, longitude: 21.4096452);
    }else if(dropdownValue == "FEIT"){
       location = Location(latitude: 42.004400, longitude: 21.408918);
    }else {
       location = Location(latitude: 42.004906, longitude: 21.409890);
    }

    final newTermin = Exam(
        id: nanoid(5), 
        name: _subjectNameController.text, 
        date: date, 
        location: location
      );
      widget.addTermin(newTermin);
      Navigator.of(context).pop(); 

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(labelText: "Subject name"),
            controller: _subjectNameController,
            // onSubmitted: (_) => _submitData(),
            textInputAction: TextInputAction.next,
          ),
          TextField(
            decoration: InputDecoration(labelText: "Date (ex. 2022-01-01 15:00)"),
            controller: _dateController,
            // onSubmitted: (_) => _submitData(),
            textInputAction: TextInputAction.next,
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: Text("Location", style: TextStyle(color: Colors.grey[600], fontSize: 15, ),),
              ),
              DropdownButton(
                value: dropdownValue,
                items: <String>['FINKI', 'TMF', 'FEIT'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String> (
                    value: value,
                    child: Text(value, textAlign: TextAlign.center,),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                  print("submitted");
                  _submitData(context);
                }
                )
            ],
          )
        ],
      )
    );
  }
}