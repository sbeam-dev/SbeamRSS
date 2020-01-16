

class HtmlParsing {
  static String headImage(String htmlText) {
    var doc = parse(htmlText);
    var img = doc.querySelector("img");
    return img.getAttribute();
  }
}