class MyElement {
  late String name;
  late String audio;
  late int volume;

  MyElement({required this.name, required this.audio, required this.volume});

  factory MyElement.fromJson(Map<String, dynamic> data) {
    return MyElement(
      name: data['name'],
      audio: data['audio'],
      volume: data['volume'],
    );
  }
}
