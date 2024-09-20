import 'package:empire_app/constants.dart';
import 'package:empire_app/widget/drop_down.dart';
import 'package:flutter/material.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

// ignore: must_be_immutable
class DropDayTime extends StatefulWidget {
  DropDayTime({
    super.key,
    required this.valueDay1,
    required this.valueDay2,
    required this.timeDay1,
    required this.timeDay2,
    required this.onChangedTime1,
    required this.onChangedTime2,
    required this.onChangedDay1,
    required this.onChangedDay2,
    required this.initTime1,
    required this.initTime2,
  });
  String? valueDay1;
  String? valueDay2;
  DateTime timeDay1;
  DateTime timeDay2;
  final void Function(DateTime?)? onChangedTime1;
  final void Function(DateTime?)? onChangedTime2;
  final void Function(String?)? onChangedDay1;
  final void Function(String?)? onChangedDay2;
  final DateTime? initTime1;
  final DateTime? initTime2;
  @override
  State<DropDayTime> createState() => _DropDayTimeState();
}

class _DropDayTimeState extends State<DropDayTime> {
  @override
  Widget build(BuildContext context) {
    double hight = MediaQuery.sizeOf(context).height;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TimePickerSpinnerPopUp(
                use24hFormat: false,
                initTime: widget.initTime1,
                onChange: widget.onChangedTime1,
              ),
              DropDown(
                items: kDayList,
                value: widget.valueDay1,
                onChanged: widget.onChangedDay1,
                selectItemName: 'اليوم',
                width: 125,
              ),
            ],
          ),
          SizedBox(
            height: hight / 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TimePickerSpinnerPopUp(
                use24hFormat: false,
                initTime: widget.initTime2,
                onChange: widget.onChangedTime2,
              ),
              DropDown(
                items: kDayList,
                value: widget.valueDay2,
                onChanged: widget.onChangedDay2,
                selectItemName: 'اليوم',
                width: 125,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
