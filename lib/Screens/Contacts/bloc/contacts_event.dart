part of 'contacts_bloc.dart';

@immutable
abstract class ContactsEvent {}

class FetchContactsEvent extends ContactsEvent {
  bool startPage;
  FetchContactsEvent({this.startPage});
}
