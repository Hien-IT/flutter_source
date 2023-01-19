class FlutterWidgetKit {
  FlutterWidgetKit(this.text);

  FlutterWidgetKit.fromJson(Map<String, dynamic> json)
      : text = json['text'] as String;

  Map<String, dynamic> toJson() => {
        'text': text,
      };

  final String text;
}
