import 'package:hive/hive.dart';
part 'userdata.g.dart';
@HiveType(typeId: 0)
class UserData extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String surname;

  UserData({
    required this.name,
    required this.surname,
  });
}