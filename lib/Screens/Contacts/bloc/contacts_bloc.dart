import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'contacts_event.dart';
part 'contacts_state.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  ContactsBloc() : super(ContactsLoading());

  @override
  Stream<ContactsState> mapEventToState(
    ContactsEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if (event is FetchContactsEvent) {
      yield* mapFetchContactsEventToState(event);
    }
  }

  Stream<ContactsState> mapFetchContactsEventToState(
      FetchContactsEvent event) async* {
    final firestoreInstance = FirebaseFirestore.instance;

    List contacts = [];
    List strList = [];
    bool isLoading = false;

    getContactsList() async {
      if (event.startPage == true) {
        await firestoreInstance
            .collection("contacts")
            .limit(2)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((result) {
            if (result != null &&
                result.data != null &&
                result.data().isNotEmpty) {
              contacts.addAll(result.data()['users']);
            }
          });
        });
      } else {
        if (isLoading == true) {
          return;
        } else if (isLoading == false) {
          isLoading = true;

          await firestoreInstance
              .collection("contacts")
              .limit(6)
              .get()
              .then((querySnapshot) {
            querySnapshot.docs.forEach((result) {
              if (result != null &&
                  result.data != null &&
                  result.data().isNotEmpty) {
                contacts.addAll(result.data()['users']);
                isLoading = false;
              }
            });
          });
        }
      }
    }

    await getContactsList();
    yield ContactsLoaded(contactsData: contacts, isLoading: isLoading);
  }
}
