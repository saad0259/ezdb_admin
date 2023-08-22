import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mega_admin/repo/api_helper.dart';

import '../model/admin_model.dart';

class AdminRepo {
  static final instance = AdminRepo();

  final String _adminCollection = 'admins';

  final String _adminsPath = '/admins';

  Stream<List<AdminModel>> watchAdmins() {
    return FirebaseFirestore.instance
        .collection(_adminCollection)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => AdminModel.fromMap(e.id, e.data())).toList());
  }

  Future<void> createAdmin(String email, String password) async {
    return await executeSafely(() async {
      final Request request = Request(_adminsPath, {
        'email': email,
        'password': password,
      });
      await request.post(baseUrl);
      return;
    });
  }

  Future<void> updateAdminActiveStatus(String uid, bool isActive) async {
    return await executeSafely(() async {
      final Request request = Request('$_adminsPath/$uid', {
        'isActive': isActive,
      });
      await request.patch(baseUrl);
      return;
    });
  }

  Future<void> deleteAdmin(String uid) async {
    return await executeSafely(() async {
      final Request request = Request('$_adminsPath/$uid', {});
      await request.delete(baseUrl);
      return;
    });
  }
}
