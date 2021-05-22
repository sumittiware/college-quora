class API {
  String baseurl = "http://192.168.43.220:8000/api/";

  getUrl({String endpoint = ""}) {
    final url = Uri.parse(baseurl + endpoint);
    return url;
  }
}
