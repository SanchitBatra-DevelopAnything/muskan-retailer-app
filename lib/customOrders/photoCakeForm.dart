import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoCakeForm extends StatefulWidget {
  const PhotoCakeForm({Key? key}) : super(key: key);

  @override
  _PhotoCakeFormState createState() => _PhotoCakeFormState();
}

class _PhotoCakeFormState extends State<PhotoCakeForm> {
  File? _pickedImage;

  void _pickImage(String sourceOfImage) async {
    if (sourceOfImage == 'Camera') {
      final pickedImage =
          await ImagePicker.pickImage(source: ImageSource.camera);
      setState(() {
        _pickedImage = pickedImage;
      });
    } else {
      final pickedImage =
          await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _pickedImage = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Photo Cakes",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
                flex: 2,
                child: Container(
                  height: 200,
                  width: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CircleAvatar(
                        backgroundColor: Color.fromRGBO(51, 51, 51, 1),
                        backgroundImage: _pickedImage != null
                            ? FileImage(_pickedImage!)
                            : null),
                  ),
                )),
            SizedBox(
              height: 15,
            ),
            Flexible(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    color: Colors.red,
                    onPressed: () {
                      _pickImage('Gallery');
                    },
                    child: Text(
                      "Gallery Image",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.red,
                    onPressed: () {
                      _pickImage('Camera');
                    },
                    child: Text(
                      "Camera Image",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Flexible(
              flex: 2,
              child: Container(
                width: 300,
                child: TextFormField(
                  style: TextStyle(fontSize: 22),
                  minLines: 1,
                  maxLines: 7,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 35.0, horizontal: 10.0),
                      hintText: "Enter cake description here",
                      hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)))),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Flexible(
              child: RaisedButton(
                color: Colors.red,
                child: Text(
                  "Place Order",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
