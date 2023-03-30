class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final bool isBlocked;
  final DateTime memberShipExpiry;
  final DateTime memberShipStart;
  final DateTime createdAt;
  final List<UserSearch> userSearch;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.isBlocked,
    required this.memberShipExpiry,
    required this.memberShipStart,
    required this.createdAt,
    required this.userSearch,
  });

  UserModel.fromMap(
      String id, Map<String, dynamic> map, List<UserSearch> userSearchData)
      : id = id,
        name = map['name'] ?? '',
        email = map['email'] ?? '',
        phone = map['phone'] ?? '',
        isBlocked = map['isBlocked'] ?? false,
        memberShipExpiry = map['memberShipExpiry'] == null
            ? DateTime.now()
            : map['memberShipExpiry'].toDate(),
        memberShipStart = map['memberShipStart'] == null
            ? DateTime.now()
            : map['memberShipStart'].toDate(),
        createdAt = map['createdAt'] == null
            ? DateTime.now()
            : map['createdAt'].toDate(),
        userSearch = userSearchData;
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
            : map['createdAt'].toDate(),
        userId = map['userId'] ?? '';
}
