import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageView extends StatefulWidget {
  final String imgUrl;
  const ImageView({required this.imgUrl});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => {
            _saveImageToGallery() ,
          }, label: const Column(
            children: [
              Text('Set as Wallpaper', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              Text('Image will be saved in gallery', style: TextStyle(fontSize: 11),)
            ],
          )),
      backgroundColor: const Color(0x00ffffff),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                widget.imgUrl,
                fit: BoxFit.cover,
              )),
        ],
      ),
    );
  }

  /*_save() async {
    await _askPermission();
    var response = await Dio().get(widget.imgUrl,
        options: Options(responseType: ResponseType.bytes));
    final result =
    await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    print(result);
    Navigator.pop(context) ;
  }*/

  Future<void> _saveImageToGallery() async {
    var response = await Dio().get(widget.imgUrl,
        options: Options(responseType: ResponseType.bytes));
    if (Platform.isAndroid || Platform.isIOS) {
      if (await _requestStoragePermission()) {
        final result = await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
        if (result['isSuccess']) {
          // Image saved successfully
          print('Image saved to gallery.');
        } else {
          // Failed to save the image
          print('Failed to save image to gallery: ${result['errorMessage']}');
        }
      } else {
        // The user denied the storage permission
        print('Permission to access storage denied.');
      }
    } else {
      // Platform not supported
      print('Saving image to the gallery is not supported on this platform.');
    }
    Navigator.pop(context) ;
  }


  Future<bool> _requestStoragePermission() async {
    var status = await Permission.storage.request();
    return status.isGranted;
  }


/*_askPermission() async {
    *//*if (Platform.isIOS) {
      *//**//*Map<PermissionGroup, PermissionStatus> permissions =
          *//**//*await Permission
          .requestPermissions([PermissionGroup.photos]);
    } else {*//*
      PermissionStatus permission = await Permission
          .storage.status;
      if(permission.isDenied || permission.isRestricted) {
        Permission.storage.request() ;
      }
      Permission.storage.request() ;
    }*/


}
