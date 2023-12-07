import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:workoneerweb/core/error/expection.dart';

const String apiUrl = 'https://api.vimeo.com/me/videos';
const String apiKey = '67d4f72bfb33ad7a54355adfeab40c6eae1a0428';
const String accessToken = '9e04b71c8ee03a475c88ada2c79da3bb';

class VimeoVideoRepo{

  Future<Map> uploadVideoToVimeo(Uint8List videoFilePath) async {

    String finalResponse = "";
    String privateVideoWithHashcode = "";

    var vimeoUrl = apiUrl;

    String videoUploadLink = "";

    // getting the endpoint
    try {
      var dio = Dio();
      var response = await dio.post(
        vimeoUrl, options: Options(
        headers: {
          "Authorization":"bearer $accessToken",
          "Content-Type":"application/json",
          "Accept":"application/vnd.vimeo.*+json;version=3.4"
        },
      ),
        data: FormData.fromMap({
          "upload": {
            "approach": "post",
            "size": "50000000",
            "redirect_url":'/client'
          },
        }),
      );
      // get upload link
      String fullUploadLink = response.data['upload']['upload_link'].toString();

      privateVideoWithHashcode = response.data['player_embed_url'].toString();

      privateVideoWithHashcode = privateVideoWithHashcode.replaceAll("https://player.vimeo.com/video/", "");

      // removing to get upload endpoint only
      videoUploadLink  = fullUploadLink.substring(0, fullUploadLink.indexOf('&redirect_url'));

    } catch (e) {

      throw ServerException(e.toString());

    }

    try{
      var dio = Dio();
      var response = await dio.post(
        videoUploadLink, options: Options(
        headers: {
          "Authorization":"bearer $accessToken",
          "Content-Type":"application/json",
          "Accept":"application/vnd.vimeo.*+json;version=3.4"
        },),
        data: FormData.fromMap({
          "file_data": MultipartFile.fromBytes(videoFilePath, filename:"Workoneer"),
          "name":"Sample","description":"Sample Vid",
        }),
      );

      if(response.statusCode == 200){
        finalResponse == "done";
        return {
          "res":"done",
          "videoId":privateVideoWithHashcode,
        };
      }
      return {
        "res":"done",
        "videoId":privateVideoWithHashcode,
      };
    } catch(e){

      throw ServerException(e.toString());

    }
  }


  Future<String> getVideoThumbnail(String videoID) async {

    String imgThumb = "";

    var vimeoUrl = 'https://api.vimeo.com/videos/$videoID/pictures';

    try{

      var dio = Dio();
      var response = await dio.get(
        vimeoUrl, options: Options(
        headers: {
          "Authorization": "bearer $accessToken",
          "Content-Type":"application/json",
          "Access-Control-Allow-Origin": "*",
          "Accept":"application/vnd.vimeo.*+json;version=3.4"
        },),
      );

      if(response.statusCode == 200){
        imgThumb = response.data['pictures']['sizes'][4]['link_with_play_button'].toString();
        return imgThumb;
      }

    } catch (e){
      return imgThumb;
    }

    return imgThumb;
  }

}