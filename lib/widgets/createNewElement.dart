import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab_mis/model/termin.dart';
import 'package:nanoid/nanoid.dart';

class createNewElement extends StatefulWidget {

  final Function addTermin;
  createNewElement(this.addTermin);

  @override
  State<StatefulWidget> createState() => _NewElementState();
}

class _NewElementState extends State<createNewElement>{

  final _imePredmetController = TextEditingController();
  final _datumController = TextEditingController();

  void _submitData(){
    if(_imePredmetController.text.isEmpty || _datumController.text.isEmpty){
      return ;
    }

    int check1 = '-'.allMatches(_datumController.text).length; //should be 2
    int check2 = ':'.allMatches(_datumController.text).length; //should be 1

    if(_datumController.text.length < 16 || check1 != 2 || check2 != 1){
      print("Please enter date in the right format!");
      return;
    }

    final String stringDate = _datumController.text + ':00';
    DateTime date = DateTime.parse(stringDate);

    final newTermin = Termin(
        id: nanoid(5), 
        name: _imePredmetController.text, 
        date: date, 
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
            controller: _imePredmetController,
            onSubmitted: (_) => _submitData(),
          ),
          TextField(
            decoration: InputDecoration(labelText: "Date (ex. 2022-01-01 15:00)"),
            controller: _datumController,
            onSubmitted: (_) => _submitData(),
          ),
        ],
      )
    );
  }
}