import 'dart:convert';
import 'dart:io';

import 'package:chat_app/models/message.model.dart';
import 'package:chat_app/models/user.model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Api {
  static const String baseURL = "http://localhost:3000";
  static var client = http.Client();

  static String jwtToken = '';

  static Future<(bool, String, UserModel?)> signUp(
    String username,
    String email,
    String password,
  ) async {
    var response = await client.post(
      Uri.parse('$baseURL/signup'),
      body: {
        'username': username,
        'email': email,
        'password': password,
      },
    );
    var body = json.decoder.convert(response.body);
    debugPrint("${response.statusCode} $body");
    if (response.statusCode == 500) {
      return (true, "User Already Exists", null);
    } else if (response.statusCode != 201) {
      return (true, (body["message"] ?? "Unknown Err") as String, null);
    }
    jwtToken = body["token"] as String;
    return (
      false,
      "",
      UserModel(
        id: "",
        name: username,
        email: email,
        status: "ONLINE",
        prevStatus: "ONLINE",
      )
    );
  }

  static Future<(bool, String, UserModel?)> login(
    String email,
    String password,
  ) async {
    var response = await client.post(
      Uri.parse('$baseURL/signin'),
      body: {
        'email': email,
        'password': password,
      },
    );
    debugPrint("${response.statusCode} ${response.body}");

    var body = json.decoder.convert(response.body);

    if (response.statusCode != 200) {
      return (true, (body["message"] ?? "Unknown Err") as String, null);
    }

    jwtToken = body["token"] as String;

    return (false, "", UserModel.fromJson(body));
  }

  static Future<(bool, String, List<UserModel>?)> getAllUsers() async {
    var response = await client.get(
      Uri.parse('$baseURL/api/users'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $jwtToken',
      },
    );

    debugPrint("${response.statusCode} ${response.body}");

    var body = json.decoder.convert(response.body);

    if (response.statusCode != 200) {
      return (true, (body["message"] ?? "Unknown Err") as String, null);
    }

    var users = (body["users"] as List)
        .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return (false, "", users);
  }

  static Future<(bool, String, List<MessageModel>?)> getMessages(
      String receiverId, String senderId) async {
    var response = await client.get(
      Uri.parse(
          '$baseURL/api/messages?receiverId=$receiverId&senderId=$senderId'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $jwtToken',
      },
    );

    debugPrint("${response.statusCode} ${response.body}");

    var body = json.decoder.convert(response.body);

    if (response.statusCode != 200) {
      return (true, (body["message"] ?? "Unknown Err") as String, null);
    }

    var messages = (body["messages"] as List)
        .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return (false, "", messages);
  }
}
