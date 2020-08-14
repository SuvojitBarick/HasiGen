import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class GetHashTags {
  //top,random,live
  Future searchTags({String keyword, String genre, bool forImage}) async {
    var client = http.Client();
    List<String> list, listOfHashTags = List();
    Map<String, String> postData = {"keyword": keyword, "filter": genre};

    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
    };
    http.Response response = await client.post(
        "https://www.all-hashtag.com/library/contents/ajax_generator.php",
        body: postData,
        headers: headers);
    if (response.statusCode == 200) {
      var document = parse(response.body);
      var links = document.querySelectorAll('#copy-hashtags');
      String rawData = links[0].innerHtml;
      list = rawData.split('#');
      list.forEach((element) {
        listOfHashTags.add("#" + element.trim());
      });
    } else {
      throw Exception();
    }
    return forImage ? listOfHashTags.sublist(0, 10) : listOfHashTags;
  }

  // Looking for top hashtags for Instagram, Twitter or other content?
  Future topDailyHashtags({int option}) async {
    var client = http.Client();
    http.Response response = await client
        .get("https://www.all-hashtag.com/library/contents/ajax_top.php");

    if (response.statusCode == 200) {
      var document = parse(response.body);
      var links = document.getElementsByClassName("tab");
      List listOfTags = [];
      links.forEach((element) {
        List list = [];
        var doc = parse(element.innerHtml).getElementsByClassName("hashtag");
        doc.forEach((element) {
          list.add(element.innerHtml.trim());
        });
        listOfTags.add(list);
      });
      return listOfTags;
    }
  }
}
