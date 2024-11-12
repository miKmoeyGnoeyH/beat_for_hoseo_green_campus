import 'dart:convert';

import 'package:BEAT/data/models/data_models.dart';
import 'package:BEAT/data/states/info_image_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../states/info_list_state.dart';

class InfoProvider {
  Future<InfoImageState> getInfoImages() async {
    final String requestUrl = dotenv.env['INFO_IMAGE']!;
    List<Image> images = [];
    int imageId = 1;

    try {
      while (await http
              .get(Uri.parse('$requestUrl$imageId'))
              .then((value) => value.statusCode) ==
          200) {
        images.add(
          Image.network(
            '$requestUrl$imageId',
            fit: BoxFit.fitWidth,
          ),
        );
        imageId++;
      }
    } catch(e) {
      return InfoImageError();
    }

    return InfoImageLoaded(images);
  }

  Future<InfoListState> getInfoList() async {
    final String requestUrl = dotenv.env['INFO']!;
    InfoListState infoEventState = InfoListInitial();

    try {
      final http.Response response = await http.get(Uri.parse(requestUrl));

      if (response.statusCode == 200) {
        final body = jsonDecode(utf8.decode(response.bodyBytes));
        infoEventState = InfoListLoaded(InfoList.fromJson(body));
      } else {
        infoEventState = InfoListError();
      }
    } catch(e) {
      infoEventState = InfoListError();
    }

    return infoEventState;
  }
}
