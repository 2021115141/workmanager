import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '/base/base_state.dart';

class ProjectModel extends Equatable {
  final String id;
  final String name;
  final String idAuthor;
  final int indexColor;
  final DateTime timeCreate;
  final List<String> listTask;

  const ProjectModel({
    this.id = '',
    required this.name,
    required this.idAuthor,
    required this.indexColor,
    required this.listTask,
    required this.timeCreate,
  });

  factory ProjectModel.fromFirestore(DocumentSnapshot doc) {
    List<String> list = [];
    for (int i = 0; i < doc["list_task"].length; i++) {
      list.add(doc["list_task"][i]);
    }
    return ProjectModel(
      id: doc.id,
      name: doc['name'],
      idAuthor: doc['id_author'],
      indexColor: doc['index_color'],
      timeCreate: DateFormat("yyyy-MM-dd hh:mm:ss").parse(
        doc['time_create'],
      ),
      listTask: list,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'id_author': idAuthor,
        'index_color': indexColor,
        'time_create': DateFormat("yyyy-MM-dd hh:mm:ss").format(timeCreate),
      };

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'id_author': idAuthor,
        'index_color': indexColor,
        'time_create': DateFormat("yyyy-MM-dd hh:mm:ss").format(timeCreate),
        "list_task": listTask,
      };

  @override
  List<Object?> get props => [id];
}
