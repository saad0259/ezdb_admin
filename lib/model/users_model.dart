import 'package:faker/faker.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final bool isVerified;
  final String remainingDays;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.isVerified,
    required this.remainingDays,
    required this.createdAt,
  });

  //generaet list of users
  static List<UserModel> generateUsers(int count) {
    final faker = Faker();
    return List.generate(
      count,
      (index) => UserModel(
        id: faker.guid.guid(),
        name: faker.person.name(),
        email: faker.internet.email(),
        phone: faker.phoneNumber.us(),
        isVerified: faker.randomGenerator.boolean(),
        remainingDays: faker.randomGenerator.integer(30).toString(),
        createdAt: faker.date.dateTimeBetween(
          DateTime.now().subtract(const Duration(days: 10)),
          DateTime.now(),
        ),
      ),
    );
  }
}
