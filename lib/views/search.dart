import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wallpaperx/data/data.dart';
import 'package:wallpaperx/model/photo_model.dart';
import 'package:wallpaperx/widget/widget.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {

  //const Search({super.key});
  final String searchQuery ;
  const Search({ required this.searchQuery}) ;
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController() ;
  List<PhotosModel> photos = [];
  getSearchWallpapers(String query) async {
    var response =
    await http.get(Uri.parse("https://api.pexels.com/v1/search?query=$query&per_page=20"), headers: {
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
    getSearchWallpapers(widget.searchQuery) ;
  super.initState() ;
  searchController.text = widget.searchQuery ;
  }
  @override
  Widget build(BuildContext context) {
    Color? getColor(Set<MaterialState> states) => const Color(0xfff5f8fd);
    Iterable<Widget> searchBarTrailing = [
      RawMaterialButton(
        onPressed: () => {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Search(searchQuery: searchController.text,)))
        },
        shape: const CircleBorder(),
        constraints: const BoxConstraints(maxWidth: 200),
        child: const Icon(Icons.search),
      )
    ];
    return Scaffold(
      appBar: AppBar(
        title: brandName(),
    backgroundColor: Colors.white,
    //make it ti centre
    ),
      body:SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      child: SearchBar(
                        controller: searchController,
                        constraints:
                        BoxConstraints.loose(const Size.fromHeight(50)),
                        hintText: 'Search for Wallpapers',
                        backgroundColor:
                        MaterialStateProperty.resolveWith(getColor),
                        trailing: searchBarTrailing,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15.0,
              ),
              Container(
                child: wallpapersList(wallpapers: photos, context: context),
              )
            ],
          ),
        ),
      )
    );
}}
