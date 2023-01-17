import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:workmanager/models/note_model.dart';

// ignore: must_be_immutable
class QuickNoteModel extends Equatable {
  String id;
  final String content;
  final int indexColor;
  final DateTime time;
  List<NoteModel> listNote;
  bool isSuccessful;

  QuickNoteModel({
    this.id = '',
    required this.content,
    required this.indexColor,
    required this.time,
    this.isSuccessful = false,
    this.listNote = const [],
  });

  factory QuickNoteModel.fromJson(Map<String, dynamic> json) {
    List<NoteModel> list = [];
    for (int i = 0; i < (json['list.length'] ?? 0); i++) {
      list.add(
        NoteModel(
            id: i,
            text: json['list.data_$i.note'],
            check: json['list.data_$i.check']),
      );
    }
    return QuickNoteModel(
      id: json['id'],
      content: json['content'],
      indexColor: json['index_color'],
      time: DateFormat("yyyy-MM-dd hh:mm:ss").parse(json['time']),
      isSuccessful: json['is_successful'],
      listNote: list,
    );
  }

  factory QuickNoteModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<NoteModel> list = [];

    for (int i = 0; i < (doc['list.length'] ?? 0); i++) {
      list.add(
        NoteModel(
          id: i,
          text: doc['list.data_$i.note'],
          check: doc['list.data_$i.check'],
        ),
      );
    }

    return QuickNoteModel(
      id: doc.id,
      content: data['content'],
      indexColor: data['index_color'],
      time: DateFormat("yyyy-MM-dd hh:mm:ss").parse(data['time']),
      isSuccessful: data['is_successful'],
      listNote: list,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'index_color': indexColor,
        'time': DateFormat("yyyy-MM-dd hh:mm:ss").format(time),
        'is_successful': isSuccessful,
        'list': {
          'length': listNote.length,
          for (int i = 0; i < listNote.length; i++)
            'data_$i': {
              'note': listNote[i].text,
              'check': listNote[i].check,
            }
        }
      };

  Map<String, dynamic> toFirestore() => {
        'content': content,
        'index_color': indexColor,
        'time': DateFormat("yyyy-MM-dd hh:mm:ss").format(time),
        'is_successful': isSuccessful,
        'list': {
          'length': listNote.length,
          for (int i = 0; i < listNote.length; i++)
            'data_$i': {
              'note': listNote[i].text,
              'check': listNote[i].check,
            }
        }
      };

  @override
  List<Object?> get props => [id];
}
