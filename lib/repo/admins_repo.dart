import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<List<AdminLogs>> getIndividualAdminLogs(String uid) async {
    return await executeSafely(() async {
      final Request request = Request('$_adminsPath/logs/$uid', {});
      final response = await request.get(baseUrl);
      final List<AdminLogs> logs = [];
      for (final log in response.data) {
        logs.add(AdminLogs.fromMap(log));
      }
      return logs;
    });
  }

  Future<List<AdminLogs>> getAllLogs() async {
    return await executeSafely(() async {
      final Request request = Request('$_adminsPath/logs', {});
      final response = await request.get(baseUrl);
      final List<AdminLogs> logs = [];
      for (final log in response.data) {
        logs.add(AdminLogs.fromMap(log));
      }
      return logs;
    });
  }

  Future<void> addAdminLogs(String email, String content) async {
    return await executeSafely(() async {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final Request request = Request('$_adminsPath/logs', {
        'content': content,
        'email': email,
        'adminId': uid,
      });
      await request.post(baseUrl);
      return;
    });
  }

  Future<void> addUserLogs(String userId, String content) async {
    return await executeSafely(() async {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final Request request = Request('/users/logs', {
        'content': content,
        'adminId': uid,
      });
      await request.post(baseUrl);
      return;
    });
  }
}
