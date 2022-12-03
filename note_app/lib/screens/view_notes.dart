import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:note_app/screens/add_notes.dart';
import 'package:note_app/screens/update_notes.dart';

class ViewNotes extends StatefulWidget {
  const ViewNotes({super.key});

  @override
  State<ViewNotes> createState() => _ViewNotesState();
}

class _ViewNotesState extends State<ViewNotes> {
  addnewCourse() {
    return showModalBottomSheet(
        context: context,
        builder: (context) => AddNote(),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  updatenewCourse() {
    return showModalBottomSheet(
        context: context,
        builder: (context) => UpdateNote(),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  Stream<QuerySnapshot> _courseStream =
      FirebaseFirestore.instance.collection("courses").snapshots();

  deleteData(selectedData) {
    return FirebaseFirestore.instance
        .collection('courses')
        .doc(selectedData)
        .delete()
        .then((value) => print('Data is deleted'));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "View Notes",
              style: TextStyle(color: Colors.black, fontSize: 25),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            // backgroundColor: Color.fromARGB(255, 182, 120, 28),
          ),
          floatingActionButton: FloatingActionButton(
            // backgroundColor: Color.fromARGB(255, 182, 120, 28),
            backgroundColor: Color.fromARGB(255, 104, 158, 106),
            onPressed: () => addnewCourse(),
            child: Icon(Icons.add),
          ),
          body: StreamBuilder(
              stream: _courseStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text("Something is Wrong");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView(
                  children: snapshot.data!.docs.map(
                    (DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return Container(
                        height: 300,
                        child: Card(
                          elevation: 5,
                          child: Stack(children: [
                            Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      child: Stack(
                                        children: [
                                          // Image.network(
                                          //   data["img"],
                                          //   height: 300,
                                          //   width: double.infinity,
                                          //   fit: BoxFit.cover,
                                          // ),
                                          Positioned(
                                            child: Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  MaterialButton(
                                                    color: Colors.white,
                                                    height: 40,
                                                    minWidth: 40,
                                                    onPressed: (() {
                                                      updatenewCourse();
                                                    }),
                                                    child: Icon(
                                                      Icons.edit,
                                                      size: 25,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  MaterialButton(
                                                    color: Colors.white,
                                                    height: 40,
                                                    minWidth: 40,
                                                    onPressed: (() {
                                                      deleteData(document.id);
                                                    }),
                                                    child: Icon(
                                                      Icons.delete,
                                                      size: 25,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 50,
                                  width: 250,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color:
                                          Color.fromARGB(255, 123, 136, 135)),
                                  child: Center(
                                    child: Text(
                                      'Title: ' + data["_courseName"],
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 30),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 50,
                                  width: 250,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color:
                                          Color.fromARGB(255, 123, 136, 135)),
                                  child: Center(
                                    child: Text(
                                      'Description: ' + data["_courseFee"],
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 30),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ]),
                        ),
                      );
                    },
                  ).toList(),
                );
              })),
    );
  }
}
