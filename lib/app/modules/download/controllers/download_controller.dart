import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';
import 'package:download_demo/app/data_base/data_base_model.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../data_base/daa_base_helper.dart';

class DownloadController extends GetxController {
  final count = 0.obs;
  var startDownload = false.obs;
  var progress = 0.0.obs;
  ReceivePort receivePort = ReceivePort();
  var downloadStatus = DownloadTaskStatus.undefined.obs;

  String path = "";
  String? fileName = "downloader";
  RxList<DownloadTask> tasks = <DownloadTask>[].obs;
  final box = GetStorage();

  //RxMap<String, int> progressTasks = <String, int>{}.obs;

  @override
  void onInit() async {
    Permission.storage.request();
    await FlutterDownloader.registerCallback(downloadCallback);
    IsolateNameServer.registerPortWithName(
        receivePort.sendPort, "downloader_send_port");
    receivePort.listen((dynamic data) {
      int progressValue = data[2];
      progress.value = progressValue.toDouble();
      update();
    });
    loadTasks();
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  loadTasks() async {
    var dh = loadMoviesData();
    for (var mv in dh) {
      var newTaskId = mv.taskId;
      var newTasks = await FlutterDownloader.loadTasksWithRawQuery(
          query: "SELECT * FROM task where task_id = '$newTaskId'");
      if (newTasks != null && newTasks.isNotEmpty) {
        tasks.add(newTasks.first);
      } else {
        tasks.add(DownloadTask(
            taskId: newTaskId,
            status: DownloadTaskStatus.complete,
            progress: 100,
            url: "",
            filename: "",
            savedDir: "",
            timeCreated: 1,
            allowCellular: true));
      }
    }

    update();
  }

  static void downloadCallback(id, status, progress) {
    SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  // void addNewProgress(String id, int progress) {
  //   Map<String, int> oldValue = {};
  //   for (String key in progressTasks.keys) {
  //     if (progressTasks[key] != null) {
  //       oldValue[key] = progressTasks[key]!;
  //     }
  //   }
  //   oldValue[id] = progress;
  //
  //   progressTasks.value = oldValue;
  // }

  addUrl(String url) async {
    startDownload.value = true;
    downloadStatus.value = DownloadTaskStatus.running;
    final baseStorage = await getExternalStorageDirectory();
    if (baseStorage == null) {
      return;
    }
    var path = baseStorage.path;
    DateTime now = DateTime.now();
    var newTaskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: path,
        fileName: 'Sample${now.millisecondsSinceEpoch}.mp4');
    var newTasks = await FlutterDownloader.loadTasksWithRawQuery(
        query: "SELECT * FROM task where task_id = '$newTaskId'");
    if (newTasks != null && newTasks.isNotEmpty) {
      tasks.add(newTasks.first);

      var data = MoviesDownload(taskId: newTasks.first.taskId, progress: 0);
      var downloadHistory = loadMoviesData();

      if (downloadHistory.isEmpty) {
        List<MoviesDownload> newList = [];
        newList.add(data);
        await saveData(newList);
      } else {
        downloadHistory.add(data);
        await saveData(downloadHistory);
      }
    }
    update();
  }

  Future<void> saveData(List<MoviesDownload> data) async {
    var dataAsMap = data.map((d) => d.toJson()).toList();
    String jsonString = jsonEncode(dataAsMap);
    await box.write('movies', jsonString);
  }

  List<MoviesDownload> loadMoviesData() {
    List<MoviesDownload> data = [];

    if (box.hasData('movies')) {
      var result = box.read('movies');
      dynamic jsonData = jsonDecode(result);
      jsonData.map((d) => data.add(MoviesDownload.fromJson(d))).toList();
    }

    return data;
  }

  pauseDownload(String? task) async {
    downloadStatus.value = DownloadTaskStatus.paused;
    await FlutterDownloader.pause(taskId: task!);
    update();
  }

  resumeDownload(String? task) async {
    downloadStatus.value = DownloadTaskStatus.paused;
    await FlutterDownloader.resume(taskId: task!);
    update();
  }

  retryDownload(String? task) async {
    downloadStatus.value = DownloadTaskStatus.canceled;
    String? newTaskId = await FlutterDownloader.retry(taskId: task!);
    //taskId.value = newTaskId!;
    update();
  }

  delete(String? task) async {
    downloadStatus.value = DownloadTaskStatus.complete;
    await FlutterDownloader.remove(taskId: task!, shouldDeleteContent: true);
    startDownload.value = false;
    update();
  }

  reload() async {
    var loaded = await FlutterDownloader.loadTasks();
    if (loaded != null) {
      tasks.clear();
      tasks.addAll(loaded);
    } else {
      tasks.clear();
    }
  }

  void increment() => count.value++;
}
