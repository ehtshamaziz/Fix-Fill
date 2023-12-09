import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fix_fill/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadDoc extends StatefulWidget {
  const UploadDoc({super.key});

  @override
  State<UploadDoc> createState() => _UploadDocState();
}

class _UploadDocState extends State<UploadDoc> {

  @override
  void initState() {
    super.initState();
    checkGalleryPermission();
  }
  Future<void> requestGalleryPermission() async {
    var status = await Permission.photos.status;
    if (!status.isGranted) {
      await Permission.photos.request();
    }
  }

  void checkGalleryPermission() async {
    var status = await Permission.photos.status;
    if (status.isGranted) {
      getImage();
      // Permission is granted, proceed
    } else {
      // Permission is not granted, request it
      await requestGalleryPermission();
    }
  }

  File? _image;
  final picker = ImagePicker();
  String? _uploadedFileURL;

  Future getImage() async {

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile(String riderId) async {
    if (_image == null) return;
    String fileName = Path.basename(_image!.path);
    Reference storageReference = FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask uploadTask = storageReference.putFile(_image!);

    await uploadTask.whenComplete(() async {
      print('File Uploaded');
      _uploadedFileURL = await storageReference.getDownloadURL();
      await FirebaseFirestore.instance.collection('rider').doc(userCredential.user!.uid).get();

      setState(() {
        // Save URL to Firestore under riders collection
        FirebaseFirestore.instance.collection('riders')
            .doc(riderId) // Replace with the rider's document ID
            .update({'imageURL': _uploadedFileURL})
            .then((_) => print("Image URL added to rider's document"))
            .catchError((error) => print("Failed to add image URL: $error"));
      });
    }).catchError((error) {
      print(error);
    });
  }


  @override
  Widget build(BuildContext context) {
    // requestGalleryPermission();
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
      ),
      drawer: NavBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null ? Text('No image selected.') : Container(
                height:400,
                width: 400,

                child: Image.file(_image!)),
            ElevatedButton(
              onPressed: getImage,
              child: Text('Pick Image'),
            ),
            ElevatedButton(
              onPressed: uploadFile,
              child: Text('Upload Image'),
            ),
            _uploadedFileURL == null ? Container() : Text('Uploaded Image URL: $_uploadedFileURL'),
          ],
        ),
      ),
    );
  }
}
