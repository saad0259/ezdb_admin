class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final bool isBlocked;
  final DateTime memberShipExpiry;
  final DateTime memberSince;
  final DateTime createdAt;
  final List<UserSearch> userSearch;
  final bool isVerified;
  final String fcmToken;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.isBlocked,
    required this.memberShipExpiry,
    required this.memberSince,
    required this.createdAt,
    required this.userSearch,
    required this.isVerified,
    required this.fcmToken,
  });

  UserModel.fromMap(Map<String, dynamic> map, List<UserSearch> userSearchData)
      : id = map['id'].toString(),
        name = map['name'] ?? '',
        email = map['email'] ?? '',
        phone = map['phone'].toString(),
        isBlocked = map['isBlocked'] ?? false,
        memberShipExpiry = map['membershipExpiry'] == null
            ? DateTime.now()
            : DateTime.parse(map['membershipExpiry'].toString()),
        memberSince = map['memberSince'] == null
            ? DateTime.now()
            : DateTime.parse(map['memberSince']),
        isVerified = map['isVerified'] ?? false,
        createdAt = map['createdAt'] == null
            ? DateTime.now()
            : DateTime.parse(map['createdAt'].toString()),
        userSearch = userSearchData,
        fcmToken = map['fcmToken'] ?? '';
}

class UserSearch {
  final String searchType;
  final String searchValue;
  final String limit;
  final String offset;
  final DateTime createdAt;
  final String userId;

  UserSearch({
    required this.searchType,
    required this.searchValue,
    required this.limit,
    required this.offset,
    required this.createdAt,
    required this.userId,
  });

  UserSearch.fromMap(Map<String, dynamic> map)
      : searchType = map['searchType'].toString(),
        searchValue = map['searchValue'].toString(),
        limit = map['limit'].toString(),
        offset = map['offset'].toString(),
        createdAt = map['createdAt'] == null
            ? DateTime.now()
            : DateTime.parse(map['createdAt'].toString()),
        userId = map['userId'].toString();
}
