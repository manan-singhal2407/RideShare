class Users {
  late num createdAt;
  late String emailId;
  late String phoneNumber;
  late String profileUrl;
  late String userName;
  late String userId;
  late String status;
  late String role;

  Users(
    this.createdAt,
    this.emailId,
    this.phoneNumber,
    this.profileUrl,
    this.userName,
    this.userId,
    this.status,
    this.role,
  );

  Users.fromJson(Map<String, dynamic> map) {
    createdAt = map['createdAt'];
    emailId = map['emailId'];
    phoneNumber = map['phoneNumber'];
    profileUrl = map['profileUrl'];
    userName = map['userName'];
    userId = map['userId'];
    status = map['status'];
    role = map['role'];
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt,
      'emailId': emailId,
      'phoneNumber': phoneNumber,
      'profileUrl': profileUrl,
      'userName': userName,
      'userId': userId,
      'status': status,
      'role': role,
    };
  }
}
