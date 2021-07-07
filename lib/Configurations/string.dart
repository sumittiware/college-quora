String queId = '60e00859b021822bfc6c1b54';
// 60cc73cbea747b4f8c53a13a

String answerId = '60cc82cdf3d31b4a4cfd7e80';
// 60cc78cbf0e9e45230ff3fd9

String placeholderImage =
    "https://firebasestorage.googleapis.com/v0/b/news-app-bowe.appspot.com/o/source_image%2FIMG-20210531-WA0009.jpg?alt=media&token=c6325d45-9c0c-4b5f-a497-a8f9fa677b65";

RegExp _base64 = RegExp(
    r'^(?:[A-Za-z0-9+\/]{4})*(?:[A-Za-z0-9+\/]{2}==|[A-Za-z0-9+\/]{3}=|[A-Za-z0-9+\/]{4})$');

bool isBase64(String str) {
  return _base64.hasMatch(str);
}
