class User {
  final String firstName;
  final String lastName;
  final int age;

  const User({
    required this.firstName,
    required this.lastName,
    required this.age,
  });

  User copy({
    String? firstName,
    String? lastName,
    int? age,
  }) =>
      User(
          firstName: firstName ?? this.firstName,
          lastName: lastName ?? this.lastName,
          age: age ?? this.age);
}
