import '/models/quick_note_model.dart';

import '/base/base_view_model.dart';

class NewNoteViewModel extends BaseViewModel {
  NewNoteViewModel(ref) : super(ref);

  Future<void> newQuickNote(QuickNoteModel quickNote) async {
    startRunning();
    await firestoreService.addQuickNote(user!.uid, quickNote);
    endRunning();
  }

  Future<void> newTaskNote(QuickNoteModel quickNote, String taskId) async {
    startRunning();
    await firestoreService.addTaskNote(taskId, quickNote);
    endRunning();
  }
}
