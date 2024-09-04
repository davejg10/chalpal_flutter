import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
// Since our class is serializable we must add this part too for additional code generation.
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({required int id, required String email}) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  static Map<String, dynamic> toJsonForRegistration(String email) => {'email': email};
}
