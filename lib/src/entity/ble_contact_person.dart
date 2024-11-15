import 'ble_base.dart';

class BleContactPerson extends BleBase<BleContactPerson> {
  String userName = "";
  String userPhone = "";

  BleContactPerson();

  @override
  String toString() {
    return "BleContactPerson(userName=$userName, userPhone=$userPhone)";
  }

  @override
  Map toJson() {
    Map map = {};
    map["userName"] = userName;
    map["userPhone"] = userPhone;
    return map;
  }
}

class BleAddressBook extends BleBase<BleAddressBook> {
  List<BleContactPerson> personList = [];

  BleAddressBook();

  @override
  String toString() {
    return "BleAddressBook(personList=$personList)";
  }

  @override
  Map toJson() {
    Map map = {};
    map["addressBook"] = personList;
    return map;
  }
}
