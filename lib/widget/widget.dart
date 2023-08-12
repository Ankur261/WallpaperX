import 'package:flutter/material.dart';
import 'package:wallpaperx/model/photo_model.dart';
import 'package:wallpaperx/views/image_view.dart';


Widget brandName() {
  return const Row(
    children: [
      Text(
        'Wallpaper',
        style: TextStyle(color: Colors.black),
      ),
      Text(
        'X',
        style: TextStyle(color: Colors.blue),
      )
    ],
  );
}

Widget wallpapersList({required List<PhotosModel> wallpapers, context}) {
  return Container(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
    child: GridView.count(
      padding: const EdgeInsets.symmetric(horizontal: 7),
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        mainAxisSpacing: 6.0,
        crossAxisSpacing: 6.0,
        children: wallpapers
            .map((wallpapers) => GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ImageView(imgUrl:wallpapers.src.portrait )));
          },
              child: Hero(
                tag: wallpapers.url,
                child: GridTile(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            wallpapers.src.portrait,
                            fit: BoxFit.cover,
                          ),
                        )),
              ),
            ))
            .toList()),
  );
}
