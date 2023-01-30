import 'package:flutter_downloader/flutter_downloader.dart';

class TaskInfo {
  final String? name;
  final String? link;

  String? taskId;
  int? progress = 0;
  DownloadTaskStatus? status = DownloadTaskStatus.undefined;

  TaskInfo({
    this.name,
    this.link,
    this.status,
    this.progress,
    this.taskId,
  });
}

class ItemHolder {
  final String? name;
  final TaskInfo? task;

  ItemHolder({this.name, this.task});
}

final videos = [
  {
    'name': 'Big Buck Bunny',
    'link':
        'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'
  },
  {
    'name': 'Demo video',
    'link':
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'
  },
  {
    'name': 'Elephant Dream',
    'link':
        'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4'
  },
  {
    'name': 'Demo video-2',
    'link':
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'
  },
];

class MovieModel {
  String name;
  String url;

  MovieModel({
    required this.name,
    required this.url,
  });
}

final List<MovieModel> movieList = [
  MovieModel(
    name: "Big Buck Bunny",
    url: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
  ),
  MovieModel(
    name: 'Elephant Dream',
    url: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
  ),
];
