import 'dart:io';

import 'package:ecommerce_app/blocs/home/home_bloc.dart';
import 'package:ecommerce_app/blocs/home/home_bloc_provider.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  String _selectedColor = "Red";
  String selectedSize;
  List<String> _colourList = [
    "Red",
    "Green",
    "Blue",
    "Orange",
    "Purple",
    "Yellow",
    "Black",
    "None"
  ];
  File _image1;
  File _image2;
  bool isLoading = false;

  HomeBloc _homeBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _homeBloc = HomeBlocProvider.of(context).homeBloc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.close,
              color: Colors.black,
            ),
          ),
          title: Text("Add Products", style: TextStyle(color: Colors.black))),
      body: Form(
        key: _formKey,
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView(children: <Widget>[
                SizedBox(height: 20.0),
                Text(
                  "Select two images of the product from your device",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),

                SizedBox(height: 30.0),

                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlineButton(
                            borderSide: BorderSide(color: Colors.black, width: 2.5),
                            onPressed: () {
                              _selectedImage(
                                  ImagePicker.pickImage(
                                      source: ImageSource.gallery),
                                  1);
                            },
                            child: _displayChild1()),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlineButton(
                            borderSide: BorderSide(color: Colors.black, width: 2.5),
                            onPressed: () {
                              _selectedImage(
                                  ImagePicker.pickImage(
                                      source: ImageSource.gallery),
                                  2);
                            },
                            child: _displayChild2()),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10.0),

                Text(
                  "Enter a product name with 10 characters at maximum",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: productNameController,
                    decoration: InputDecoration(
                      focusColor: Colors.black,
                      fillColor: Colors.black,
                      hoverColor: Colors.black,
                      hintText: "Product name",
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "You must enter the product name";
                      } else if (value.length > 15) {
                        return "Product name can't have more than 15 letters";
                      }
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Price in whole numbers",
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "You must enter a price";
                      }
                      try {
                        int.parse(value);
                      } catch (e) {
                        return "Please enter a valid price";
                      }
                    },
                  ),
                ),

                //select category
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Color: ', style: TextStyle(color: Colors.black)),
                    ),
                    DropdownButton<String>(
                        items: _colourList
                            .map((data) => DropdownMenuItem<String>(
                                  child: Text(data),
                                  value: data,
                                ))
                            .toList(),
                        onChanged: (String value) {
                          setState(() => _selectedColor = value);
                        },
                        hint: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(_selectedColor),
                          ],
                        )),
                  ],
                ),

                SizedBox(height: 10.0),

                Text(
                  "Pick a size",
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 10.0),

                Row(
                  children: <Widget>[
                    Checkbox(
                        value: selectedSize == 'S',
                        onChanged: (value) => changeSelectedSize('S')),
                    Text("S"),
                    Checkbox(
                        value: selectedSize == 'M',
                        onChanged: (value) => changeSelectedSize('M')),
                    Text("M"),
                    Checkbox(
                        value: selectedSize == 'L',
                        onChanged: (value) => changeSelectedSize('L')),
                    Text("L"),
                    Checkbox(
                        value: selectedSize == 'XL',
                        onChanged: (value) => changeSelectedSize('XL')),
                    Text("XL"),
                    Checkbox(
                        value: selectedSize == 'None',
                        onChanged: (value) => changeSelectedSize('None')),
                    Text("None"),
                  ],
                ),

                SizedBox(height: 20.0),

                FlatButton(
                  color: Colors.black,
                  textColor: Colors.white,
                  child: Text('ADD', style: TextStyle(fontSize: 15.0)),
                  onPressed: () {
                    validateAndUpload();
                  },
                )
              ]),
      ),
    );
  }

  void changeSelectedSize(String size) {
    setState(() {
      selectedSize = size;
    });
  }

  void _selectedImage(Future<File> pickImage, int imageNumber) async {
    File tempImg = await pickImage;
    switch (imageNumber) {
      case 1:
        setState(() => _image1 = tempImg);
        break;
      case 2:
        setState(() => _image2 = tempImg);
        break;
    }
  }

  Widget _displayChild1() {
    if (_image1 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 50.0, 14.0, 50.0),
        child: Icon(Icons.add, color: Colors.black),
      );
    } else {
      return Image.file(_image1, fit: BoxFit.fill, width: double.infinity);
    }
  }

  Widget _displayChild2() {
    if (_image2 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 50.0, 14.0, 50.0),
        child: Icon(Icons.add, color: Colors.black),
      );
    } else {
      return Image.file(_image2, fit: BoxFit.fill, width: double.infinity);
    }
  }

  void validateAndUpload() async {
    if (_formKey.currentState.validate()) {
      setState(() => isLoading = true);
      if (_image1 != null && _image2 != null) {
        if (selectedSize.isNotEmpty) {
          String imageUrl1;
          String imageUrl2;
          final FirebaseStorage storage = FirebaseStorage.instance;
          final String picture1 =
              "1${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
          StorageUploadTask task1 =
              storage.ref().child(picture1).putFile(_image1);

          final String picture2 =
              "2${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
          StorageUploadTask task2 =
              storage.ref().child(picture2).putFile(_image2);

          StorageTaskSnapshot snapshot1 =
              await task1.onComplete.then((snapshot) => snapshot);

          task2.onComplete.then((snapshot2) async {
            imageUrl1 = await snapshot1.ref.getDownloadURL();
            imageUrl2 = await snapshot2.ref.getDownloadURL();

            Product product_details = Product(
              name: productNameController.text,
              price: int.parse(priceController.text),
              picture1: imageUrl1,
              picture2: imageUrl2,
              color: _selectedColor,
              size: selectedSize,
            );
            _formKey.currentState.reset();
            _homeBloc.addProductToDb(product_details);
            Fluttertoast.showToast(msg: "Product added");
            Navigator.pop(context);
          });
        } else {
          setState(() => isLoading = true);
          Fluttertoast.showToast(msg: " Please select at least one size");
        }
      } else {
        setState(() => isLoading = true);
        Fluttertoast.showToast(msg: "All the images must be provided");
      }
    }
  }
}
