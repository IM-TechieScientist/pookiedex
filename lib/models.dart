// Model class for Friend
class Friend {
  final int? id;
  final String name;
  final String regNumber;
  final String instaId;

  Friend({this.id, required this.name, required this.regNumber, required this.instaId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'regNumber': regNumber,
      'instaId': instaId,
    };
  }
}
