import 'package:ezdb_admin/repo/api_helper.dart';

import 'repo_contants.dart';

class AllowedUsersRepo {
  static final instance = AllowedUsersRepo();

  Future<List<String>> getAllowedUsers() async {
    return await executeSafely(() async {
      final response = await Request('/users/allowed', null).get(baseUrl);

      final data = response.data as List<dynamic>;

      return data.map((e) => e['phone'] as String).toList();
    });
  }

  Future<void> addAllowedUser(String phone) async {
    return await executeSafely(() async {
      await Request('/users/allowed/$phone', null).post(baseUrl);
    });
  }

  Future<void> removeAllowedUser(String phone) async {
    return await executeSafely(() async {
      await Request('/users/allowed/$phone', null).delete(baseUrl);
    });
  }
}
