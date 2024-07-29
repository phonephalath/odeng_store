import 'dart:convert';
import 'package:http/http.dart' as http;

class AddAdDitails {
  static Future<http.Response> postAdDetail(
    String adImage,
    String adText,
  ) async {
    String url = 'https://app-api-seven.vercel.app/adBox/create';
    var requsetBody = jsonEncode({
      "ad_pic": adImage,
      "ad_text": adText,
    });
    var respone = await http.post(Uri.parse(url),
        body: requsetBody, headers: {'Content-Type': 'application/json'});
    return respone;
  }
}

class DeleteAd {
  static Future<http.Response> deleteAd(
    String adId,
  ) async {
    String url = 'https://app-api-seven.vercel.app/adBox/delete/$adId';
    var respone = await http.delete(Uri.parse(url));
    return respone;
  }
}
