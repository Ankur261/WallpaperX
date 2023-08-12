import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wallpaperx/data/data.dart';
import 'package:wallpaperx/model/photo_model.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaperx/widget/widget.dart';

class Categorie extends StatefulWidget {
  final String categorieQuery;
  Categorie({required this.categorieQuery});

  @override
  State<Categorie> createState() => _CategorieState();
}

class _CategorieState extends State<Categorie> {
  TextEditingController categorieController = TextEditingController();
  List<PhotosModel> photos = [];
  getSearchWallpapers(String query) async {
    var response = await http.get(
        Uri.parse("https://api.pexels.com/v1/search?query=$query&per_page=20"),
        headers: {
          'Authorization': apiKEY,
        });
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element) {
      //print(element) ;
      //SrcModel srcModel = SrcModel.fromMap(element.src) ;
      PhotosModel photosModel = PhotosModel.fromMap(element);
      photos.add(photosModel);
    });
    setState(() {});
  }

  @override
  void initState() {
    getSearchWallpapers(widget.categorieQuery);
    super.initState();
    categorieController.text = widget.categorieQuery;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: brandName(),
          backgroundColor: Colors.white,
          //make it ti centre
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 15.0,
              ),
              Container(
                child: wallpapersList(wallpapers: photos, context: context),
              )
            ],
          ),
        ));
  }
}
