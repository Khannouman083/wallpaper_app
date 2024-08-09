import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';

class fullWallpaper extends StatefulWidget {
  String imageUrl;
  fullWallpaper({super.key,required this.imageUrl});

  @override
  State<fullWallpaper> createState() => _fullWallpaperState();
}

class _fullWallpaperState extends State<fullWallpaper> {
  Future<void> setwallpaper () async{
    int location = WallpaperManager.HOME_SCREEN;
    var file= await DefaultCacheManager().getSingleFile(widget.imageUrl);
    var result = await WallpaperManager.setWallpaperFromFile(file.path, location);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Full Screen Wallpaper"),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Expanded(child: Container(
            child: Image.network(widget.imageUrl, fit: BoxFit.cover,),
          )),
          InkWell(
            onTap: (){
              setwallpaper();
            },
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.red
              ),
              child: Center(child: Text("Set as Wallpaper", style: TextStyle(fontSize: 15),)),
            ),
          )
        ],
      ),
    );
  }
}
