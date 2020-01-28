import 'package:html/parser.dart' show parse;

class HtmlParsing {
  static String headImage(String htmlText) {
    var doc = parse(htmlText);
    var img;
    try{
      img = doc.querySelector("img");
    } catch (e) {
      return null;
    }
    if (img == null) return null;
    return img.attributes['src'];
  }
}