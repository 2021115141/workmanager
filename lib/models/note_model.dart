import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class NoteModel extends Equatable {
  final int id;
  final String text;
  bool check;

  NoteModel({required this.id, required this.text, this.check = true});

  @override
  List<Object?> get props => [id];
}
