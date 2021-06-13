import 'dart:io';

import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_contact_app/Constants/font_family.dart';

import 'package:shimmer/shimmer.dart';

import 'bloc/contacts_bloc.dart';

class Contacts extends StatefulWidget {
  const Contacts({Key key}) : super(key: key);

  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  ContactsBloc contactsBloc = ContactsBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    contactsBloc.add(FetchContactsEvent(startPage: true));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    contactsBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactsBloc, ContactsState>(
      cubit: contactsBloc,
      builder: (context, state) {
        if (state is ContactsLoading) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              // backgroundColor: Colors.blue,
              automaticallyImplyLeading: false,
              title: Text(
                "Contacts",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: AppFontFamily.fontProductSans,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
              ),
              elevation: 0,
            ),
            body: Container(
              child: ListView.builder(
                  itemCount: 8,
                  itemBuilder: (context, int) => Padding(
                        padding: const EdgeInsets.only(
                            left: 18.0, right: 18, top: 10, bottom: 10),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[400],
                          child: Container(
                            width: 150,
                            height: 50,
                            color: Colors.grey,
                          ),
                        ),
                      )),
            ),
          );
        } else if (state is ContactsLoaded) {
          // String data;
          // List<String> dataList = [];
          // for (int i = 0; i < state.contactsData.length; i++) {
          //   data = state.contactsData[i]['fname'];
          //   dataList.add(data);
          // }
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Contacts",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: AppFontFamily.fontProductSans,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            body: WillPopScope(
              onWillPop: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text("Do yo want exit?"),
                        actions: <Widget>[
                          TextButton(
                            child: new Text("Yes",
                                style: TextStyle(color: Colors.blue)),
                            onPressed: () {
                              exit(0);
                            },
                          ),
                          TextButton(
                            child: new Text("No",
                                style: TextStyle(color: Colors.blue)),
                            onPressed: () async {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              },
              child: Column(
                children: [
                  Expanded(
                    child: NotificationListener(
                      onNotification: (ScrollNotification scrollState) {
                        FocusScope.of(context).unfocus();
                        if (scrollState.metrics.pixels ==
                            scrollState.metrics.maxScrollExtent) {
                          if (state.isLoading == false) {
                            contactsBloc
                                .add(FetchContactsEvent(startPage: false));
                          }
                        }
                      },
                      child: AlphabetScrollView(
                        list: state.contactsData
                            .map((e) => AlphaModel(e['fname']))
                            .toList(),
                        isAlphabetsFiltered: true,
                        alignment: LetterAlignment.right,
                        itemExtent: 50,
                        unselectedTextStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                        selectedTextStyle: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                        overlayWidget: (value) => Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.star,
                              size: 50,
                              color: Colors.red,
                            ),
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '$value'.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        itemBuilder: (_, k, id) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(right: 20, bottom: 5),
                            child: ListTile(
                              title: Text('${id}'),
                              subtitle:
                                  Text('${state.contactsData[k]['pNum']}'),
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue,
                                radius: 20.0,
                                child: Icon(
                                  Icons.person,
                                  size: 22.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
