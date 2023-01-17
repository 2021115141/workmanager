import '/base/base_view_model.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel(ref) : super(ref);

  void initMessingToken() {
    firestoreMessagingService.getToken();
  }

  void initMessagingChannel() {}

  void logOut() {
    auth.signOut();
  }
}
