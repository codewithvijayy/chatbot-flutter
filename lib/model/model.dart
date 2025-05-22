// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DataModel {
  final String data;
  final bool isChatbot;

  DataModel(
    this.data,
    this.isChatbot,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'data': data,
      'isChatbot': isChatbot,
    };
  }

  factory DataModel.fromMap(Map<String, dynamic> map) {
    return DataModel(
      map['data'] as String,
      map['isChatbot'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory DataModel.fromJson(String source) =>
      DataModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
