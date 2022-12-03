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
            leading: Text(''),
            title: Text(
              "View Notes",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            backgroundColor: Color.fromARGB(255, 104, 158, 106),
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
                        height: 310,
                        child: Card(
                          elevation: 5,
                          child: Stack(children: [
                            Column(
                              children: [
                                Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 280,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Color.fromARGB(
                                                255, 219, 219, 219)),
                                        child: Center(
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'Title: ' +
                                                        data["_courseName"],
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 40),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'Description: ' +
                                                        data["_courseFee"],
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 30),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
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
                                                color: Colors.green,
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
                                // SizedBox(
                                //   height: 10,
                                // ),
                                // Container(
                                //   height: 50,
                                //   width: 250,
                                //   decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(15),
                                //       color:
                                //           Color.fromARGB(255, 123, 136, 135)),
                                //   child: Center(
                                //     child: Text(
                                //       'Description: ' + data["_courseFee"],
                                //       style: TextStyle(
                                //           color: Colors.white, fontSize: 30),
                                //     ),
                                //   ),
                                // )
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
