import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app/fullwallpaper.dart';

class wallpaperScreen extends StatefulWidget {
  const wallpaperScreen({super.key});

  @override
  State<wallpaperScreen> createState() => _wallpaperScreenState();
}

class _wallpaperScreenState extends State<wallpaperScreen> {
  List images = [];
  int page=1;
  @override
  void initState() {
    super.initState();
    fetchApi();
  }
  fetchApi () async {
    await http.get(Uri.parse('https://api.pexels.com/v1/curated?per_page=80'),
        headers: {
          'Authorization' : 'kjHsjpWzKTBFLR9xfnLt8wUUf8hsXBiLq6qMVrRfjBhc3aklZg3V3apb'
        }).then((value){
      Map result = jsonDecode(value.body);
      setState(() {
        images = result['photos'];
      });
      print(images);
    });
  }
  loadMore() async{
    setState(() {
      page=page+1;
    });
    String url = 'https://api.pexels.com/v1/curated?per_page=80&page='+page.toString();
    await http.get(Uri.parse(url),
        headers: {
          'Authorization' : 'kjHsjpWzKTBFLR9xfnLt8wUUf8hsXBiLq6qMVrRfjBhc3aklZg3V3apb'
        }).then((onValue){
          Map result = jsonDecode(onValue.body);
          setState(() {
            images.addAll(result['photos']);
          });
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wallpaper App"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Container(
            child: GridView.builder(
               itemCount: images.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  childAspectRatio: 2/3,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2
                ),
                itemBuilder: (context, index){
                  return InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>fullWallpaper(imageUrl: images[index]['src']['large2x'])));
                    },
                    child: Container(
                      color: Colors.white,
                      child: Image.network(images[index]['src']['tiny'], fit: BoxFit.cover,),
                    ),
                  );
                }),
          )),
          InkWell(
            onTap: (){
              loadMore();
            },
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.red
              ),
              child: Center(child: Text("Load More Wallpapers", style: TextStyle(fontSize: 15),)),
            ),
          )
        ],
      ),
    );
  }
}
