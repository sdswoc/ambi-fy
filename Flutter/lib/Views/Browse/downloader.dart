import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Models/_Soundscape.dart';
import 'package:frontend/Views/Browse/bottomsheet_options.dart';
import 'package:frontend/Views/Browse/directory_path.dart';
import 'package:frontend/Views/Common/audioplayer.dart';
import 'package:frontend/Views/utils/sound_generator_helper.dart';
import 'package:get/get.dart';

class DownloaderWidget extends StatefulWidget {
  final MySoundscape mySoundscape;
  final dynamic checkpermission;
  final List<String>? oneDHkey;
  const DownloaderWidget(
      {super.key,
      required this.mySoundscape,
      required this.checkpermission,
      required this.oneDHkey});

  @override
  State<DownloaderWidget> createState() => _DownloaderWidgetState();
}

class _DownloaderWidgetState extends State<DownloaderWidget> {
  List<bool> downloading = [false, false, false, false, false];
  List<bool> fileExists = [false, false, false, false, false];
  List<double> progress = [0, 0, 0, 0, 0];
  late List<String> filePath;
  String code = 'download';
  String soundscapeName = '';
  List<String> elementNames = [];
  double totalprogress = 0;
  late List<CancelToken> cancelToken;
  var getPathFile = DirectoryPath();

  averageprogress() {
    for (int i = 0; i < 5; i++) {
      setState(() {
        totalprogress = (totalprogress + progress[i]) / 5;
      });
    }
  }

  startDownload() async {
    var storePath = await getPathFile.getPath();
    for (int i = 0; i < 5; i++) {
      cancelToken[i] = CancelToken();
      filePath[i] =
          '$storePath/${widget.mySoundscape.name}/${widget.mySoundscape.elements[i].name}';
      setState(() {
        progress[i] = 0;
      });
      setState(() {
        downloading[i] = true;
      });

      try {
        await Dio().download(
          widget.mySoundscape.elements[i].audio,
          filePath[i],
          onReceiveProgress: (count, total) {
            setState(() {
              progress[i] = (count / total);
            });
          },
          cancelToken: cancelToken[i],
        );
        setState(() {
          downloading[i] = false;
          fileExists[i] = true;
        });
      } catch (e) {
        print(e);
        setState(() {
          downloading[i] = false;
        });
      }
    }
  }

  bool downloadingWhole(List<bool> download) {
    for (int i = 0; i < download.length; i++) {
      if (download[i] == false) {
        continue;
      } else {
        return true;
      }
    }
    return false;
  }

  bool fileExistsWhole(List<bool> fileExist) {
    for (int i = 0; i < fileExist.length; i++) {
      if (fileExist[i] == false) {
        continue;
      } else {
        return true;
      }
    }
    return false;
  }

  cancelDownload() {
    for (int i = 0; i < 5; i++) {
      cancelToken[i].cancel();
      setState(() {
        downloading[i] = false;
      });
    }
  }

  checkFileExist() async {
    var storePath = await getPathFile.getPath();
    for (int i = 0; i < 5; i++) {
      filePath[i] =
          '$storePath/${widget.mySoundscape.name}/${widget.mySoundscape.elements[i].name}';
      bool fileExistCheck = await File(filePath[i]).exists();
      setState(() {
        fileExists[i] = fileExistCheck;
      });
    }
  }

  openFile() {
    Get.to(
      () => ClassAudioPlayer(
        mySoundscape: widget.mySoundscape,
        oneDHkey: widget.oneDHkey,
        code: code,
        filepath: filePath,
      ),
      transition: Transition.zoom,
      duration: const Duration(milliseconds: 300),
    );
    print("fff  $filePath \n ");
  }

  @override
  void initState() {
    super.initState();
    filePath = List.generate(5, (index) => '');
    cancelToken = List.generate(5, (index) => CancelToken());
    setState(() {
      soundscapeName = widget.mySoundscape.name;
      elementNames =
          widget.mySoundscape.elements.map((element) => element.name).toList();
    });
    checkFileExist();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapDownload('downloadsoundname__1', widget.mySoundscape);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Added to downloaded!',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            duration: Duration(seconds: 3),
            backgroundColor: Color.fromARGB(255, 48, 47, 47),
          ),
        );
      },
      child: BottomSheetOptions(
        message: 'Add to Downloads',
        iconbutton1: IconButton(
          onPressed: () {
            fileExistsWhole(fileExists) &&
                    downloadingWhole(downloading) == false
                ? openFile()
                : startDownload();
          },
          icon: fileExistsWhole(fileExists)
              ? const Icon(
                  Icons.save,
                  color: Colors.green,
                )
              : downloadingWhole(downloading)
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: totalprogress,
                          strokeWidth: 3,
                          backgroundColor: Colors.grey,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                        Text(
                          (totalprogress * 100).toStringAsFixed(2),
                          style: const TextStyle(fontSize: 12),
                        )
                      ],
                    )
                  : const Icon(Icons.download, color: Colors.white, size: 30),
        ),
        iconbutton2: IconButton(
          onPressed: () {
            fileExistsWhole(fileExists) &&
                    downloadingWhole(downloading) == false
                ? openFile()
                : cancelDownload();
          },
          icon: fileExistsWhole(fileExists) &&
                  downloadingWhole(downloading) == false
              ? const Icon(
                  Icons.window,
                  color: Colors.green,
                )
              : const Icon(Icons.close),
        ),
      ),
    );
  }
}
