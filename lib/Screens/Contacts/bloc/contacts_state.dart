part of 'contacts_bloc.dart';

@immutable
abstract class ContactsState {}

class ContactsLoading extends ContactsState {}

class ContactsLoaded extends ContactsState {
  List contactsData;
  bool isLoading;
  ContactsLoaded({this.contactsData,this.isLoading});
}
