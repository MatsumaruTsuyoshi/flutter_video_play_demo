import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_play_demo/video_item.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("video play demo"),
      ),
      body: Center(),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              //galleryをcameraに変更すれば、撮影した動画を再生できる。
              getVideo(context, ImageSource.gallery);
            },
            heroTag: "gallery",
            child: Icon(Icons.photo),
          ),
        ],
      ),
    );
  }

  Future getVideo(context, source) async {
    //image pickerを用いて動画を選択する。
    final picker = ImagePicker();
    final pickVideo = await picker.getVideo(source: source);
    if (pickVideo == null) return;

    //データの型をPickedFileからFileに変更する。
    final pickFile = File(pickVideo.path);

    //localPathを呼び出して、アプリ内のストレージ領域を確保。
    final path = await localPath;

    //拡張子を取得
    final String fileName = basename(pickVideo.path);

    //pickした動画をコピーする場所を作成。
    final videoPath = '$path/$fileName';

    //pickした動画をvideoPathにコピー。※ .copyはデータの型がFileの必要あり。
    final File saveVideo = await pickFile.copy('$videoPath');

    //saveVideoを引数に、VideoItemページに移動。
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VideoItem(saveVideo),
      ),
    );
  }

  //path_providerでアプリ内のストレージ領域を確保。
  static Future get localPath async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String path = appDocDir.path;
    return path;
  }
}
