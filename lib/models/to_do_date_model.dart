import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class ToDoDateModel extends Equatable {
  final DateTime day;
  bool isTask = false, isMonth;
  ToDoDateModel({required this.day, this.isMonth = true});

  @override
  String toString() {
    return day.toString() + isTask.toString() + isMonth.toString();
  }

  @override
  List<Object?> get props => [day];
}
