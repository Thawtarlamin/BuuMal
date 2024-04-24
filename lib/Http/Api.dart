import 'dart:convert';

import 'package:mal/Model/MyanmarModel.dart';
import 'package:http/http.dart' as http;
import 'package:mal/Model/StreamModel.dart';

class Api {
  static Future<List<MyanmarModel>> GetMyanmar(page) async {
    List<MyanmarModel> list = [];
    var response = await http.get(Uri.parse(
        "https://script.google.com/macros/s/AKfycbzhUD2o0EW9qyZNcsh8suilW5zcz7ZmBEXCaisIgJA0j7r6NKccYRMArTtOrRC8w9mtuA/exec?page=$page"));
    List json = jsonDecode(response.body);
    list = json.map((e) => MyanmarModel.from(e)).toList();
    return list;
  }

  static Future<List<StreamModel>> GetStream(url) async {
    List<StreamModel> list = [];
    var response = await http.get(Uri.parse(
        "https://script.google.com/macros/s/AKfycbzhUD2o0EW9qyZNcsh8suilW5zcz7ZmBEXCaisIgJA0j7r6NKccYRMArTtOrRC8w9mtuA/exec?url=$url"));
    
    List json = jsonDecode(response.body);
    list = json.map((e) => StreamModel.from(e)).toList();
    return list;
  }
}
