String queId = '60f0256d43efb03a34c82a2c';

String placeholderImage =
    "https://firebasestorage.googleapis.com/v0/b/news-app-bowe.appspot.com/o/source_image%2FIMG-20210531-WA0009.jpg?alt=media&token=c6325d45-9c0c-4b5f-a497-a8f9fa677b65";

RegExp _base64 = RegExp(
    r'^(?:[A-Za-z0-9+\/]{4})*(?:[A-Za-z0-9+\/]{2}==|[A-Za-z0-9+\/]{3}=|[A-Za-z0-9+\/]{4})$');

bool isBase64(String str) {
  return _base64.hasMatch(str);
}
// d3N2OnBhc3N3b3JkMTIz