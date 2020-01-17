import 'dart:async';
import 'package:http/http.dart' as http;

const baseUrl = "https://jsonplaceholder.typicode.com";

class API {
  static Future getUsers() {
    var url = baseUrl + "/users";
    return http.get(url);
  }

  static Future getUserDetail(int id) {
    var url = baseUrl + "/users/" + id.toString();
    return http.get(url);
  }
}