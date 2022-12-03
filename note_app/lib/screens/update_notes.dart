import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app/screens/splash_screen.dart';

class UpdateNote extends StatefulWidget {
  const UpdateNote({super.key});

  @override
  State<UpdateNote> createState() => _UpdateNoteState();
}

class _UpdateNoteState extends State<UpdateNote> {
  TextEditingController _addcoursename = TextEditingController();
  TextEditingController _addcoursefee = TextEditingController();
  XFile? _courseImage;
  String? _imgUrl;
  chooseImageFromCG() async {
    ImagePicker _picker = ImagePicker();
    _courseImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  sendData() async {
    // File _imageFile = File(_courseImage!.path);
    // FirebaseStorage _storage = FirebaseStorage.instance;
    // UploadTask _uploadTask =
    //     _storage.ref('courses').child(_courseImage!.name).putFile(_imageFile);
    // TaskSnapshot _snapshot = await _uploadTask;
    // _imgUrl = await _snapshot.ref.getDownloadURL();
    CollectionReference _course =
        await FirebaseFirestore.instance.collection('courses');
    _course.add(({
      '_courseName': _addcoursename.text,
      '_courseFee': _addcoursefee.text,
      // 'img': _imgUrl
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.50,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _addcoursename,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  hintText: 'Title',
                  prefixIcon: Icon(Icons.text_format)),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _addcoursefee,
              decoration: InputDecoration(
                  hintText: 'Description',
                  prefixIcon: Icon(Icons.text_fields),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15))),
            ),
            SizedBox(
              height: 10,
            ),
            // Expanded(
            //     child: _courseImage == null
            //         ? IconButton(
            //             icon: Icon(Icons.camera),
            //             onPressed: () {
            //               chooseImageFromCG();
            //             },
            //           )
            //         : Image.file(File(_courseImage!.path))),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 202, 200, 200)),
                onPressed: () {
                  sendData();
                  setState(() {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SplashScreen()));
                  });
                },
                child: Text(
                  'Update Note',
                  style: TextStyle(color: Colors.black),
                ))
          ],
        ),
      ),
    );
  }
}
