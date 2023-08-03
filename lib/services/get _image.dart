import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class LoadFirbaseStorageImage extends StatefulWidget {
  @override
  _LoadFirbaseStorageImageState createState() =>
      _LoadFirbaseStorageImageState();
}

class _LoadFirbaseStorageImageState extends State<LoadFirbaseStorageImage> {
   final String image = 'img2';
    @override
    Widget build(BuildContext context) {
      return Container(
    child: FutureBuilder(
            future: _getImage(context, image),
            builder: (context, snapshot) {
              if (snapshot.connectionState ==
                  ConnectionState.done)
                return Container(
                  height:
                      MediaQuery.of(context).size.height / 1.25,
                  width:
                      MediaQuery.of(context).size.width / 1.25,
                  child: snapshot.data,
                );

              if (snapshot.connectionState ==
                  ConnectionState.waiting)
                return Container(
                    height: MediaQuery.of(context).size.height /
                        1.25,
                    width: MediaQuery.of(context).size.width /
                        1.25,
                    child: CircularProgressIndicator());

              return Container();
            },
          ),
      );
    }
}
class FireStorageService extends ChangeNotifier {
  FireStorageService();
static Future<dynamic> loadImage(BuildContext context, String image) async {
    return await FirebaseStorage.instance.ref().child(image).getDownloadURL();
  }
}
Future<Widget> _getImage(BuildContext context, String image) async {
  Image m;
  await FireStorageService.loadImage(context, image).then((downloadUrl) {
    m = Image.network(
      downloadUrl.toString(),
      fit: BoxFit.scaleDown,
    );
  });
return m;
}