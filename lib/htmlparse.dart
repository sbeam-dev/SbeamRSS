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
    RegExp re = RegExp(r"\.jpg|\.png|\.gif|\.jpeg|\.webp|\.bmp");
    String srcLink = img.attributes['src'];
    if (srcLink == null) return null;
    if (srcLink.contains(re)) {
      return srcLink;
    }
    return null;
  }
}