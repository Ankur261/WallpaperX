import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wallpaperx/data/data.dart';
import 'package:wallpaperx/model/photo_model.dart';
import 'package:wallpaperx/views/categori_screen.dart';
import 'package:wallpaperx/views/search.dart';
import 'package:wallpaperx/widget/widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

const bool kIsWeb = bool.fromEnvironment('dart.library.js_util');

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<PhotosModel> photos = [];

  getTrendingWallpapers() async {
    var response = await http.get(
        Uri.https("api.pexels.com", "/v1/curated", {"per_page": "20"}),
        headers: {
          'Authorization': apiKEY,
        });
    //print(response.body) ;
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element) {
      //print(element) ;
      //SrcModel srcModel = SrcModel.fromMap(element.src) ;
      PhotosModel photosModel = PhotosModel.fromMap(element);
      photos.add(photosModel);
    });
    setState(() {});
  }

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    getTrendingWallpapers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color? getColor(Set<MaterialState> states) => const Color(0xfff5f8fd);
    Iterable<Widget> searchBarTrailing = [
      RawMaterialButton(
        onPressed: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Search(
                        searchQuery: searchController.text,
                      )))
        },
        shape: const CircleBorder(),
        constraints: const BoxConstraints(maxWidth: 200),
        child: const Icon(Icons.search),
      )
    ];
    var categories = getCategories();
    return Scaffold(
      appBar: AppBar(
        title: brandName(),
        backgroundColor: Colors.white,
        //make it ti centre
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
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
            SizedBox(
              height: 60,
              child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 7, vertical: 0),
                  itemCount: categories.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    /// Create List Item tile
                    return CategoriesTile(
                      imgUrls: categories[index].imgUrl,
                      categorie: categories[index].categorieName,
                    );
                  }),
            ),
            wallpapersList(wallpapers: photos, context: context),
          ],
        ),
      ),
    );
  }
}

class CategoriesTile extends StatelessWidget {
  final String imgUrls, categorie;

  CategoriesTile({required this.imgUrls, required this.categorie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Categorie(
                      categorieQuery: categorie,
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(right: 8),
        child: kIsWeb
            ? Row(
                children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: kIsWeb
                          ? Image.network(
                              imgUrls,
                              height: 50,
                              width: 100,
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              imageUrl: imgUrls,
                              height: 50,
                              width: 100,
                              fit: BoxFit.cover,
                            )),
                  /*const SizedBox(
                    height: 4,
                  ),*/
                  Container(
                      width: 100,
                      alignment: Alignment.center,
                      child: Text(
                        categorie,
                        style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Overpass'),
                      )),
                ],
              )
            : Stack(
                children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: kIsWeb
                          ? Image.network(
                              imgUrls,
                              height: 50,
                              width: 100,
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              imageUrl: imgUrls,
                              height: 50,
                              width: 100,
                              fit: BoxFit.cover,
                            )),
                  Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Container(
                      height: 50,
                      width: 100,
                      alignment: Alignment.center,
                      child: Text(
                        categorie,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Overpass'),
                      ))
                ],
              ),
      ),
    );
  }
}

// class CategorieTile extends StatelessWidget {
//   final String imgUrl, title;
//    CategorieTile({required this.title, required this.imgUrl});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Stack(
//         children: <Widget>[
//           Container(
//             child: Image.network(imgUrl),
//           ),
//           Container(
//             child: Text(title),
//           )
//         ],
//       ),
//     );
//   }
// }
