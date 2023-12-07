
bool validatingEmail(String value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);
  if (regex.hasMatch(value)) {
    return true;
  } else {
    return false;
  }
}


Future<bool> validatePostCode(String postal, String phone) async {
  if(phone.toString().startsWith("+61")) {
    // TODO: validate
    return true;
  }
  else if(phone.toString().startsWith("+44")){
    // TODO: validate
    return true;
  }
  else {
    return false;
  }
}
