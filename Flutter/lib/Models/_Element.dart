class MyElement {
  late String name;
  late String audio;

  MyElement({required this.name, required this.audio});

  factory MyElement.fromJson(Map<String, dynamic> data) {
    return MyElement(
      name: data['name'],
      audio: data['audio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'audio': audio,
    };
  }
}
