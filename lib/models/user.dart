class User {
  final int id;
  final String username;
  final String token;

  const User({
    required this.id,
    required this.username,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'username': String username,
        'token': String token,
      } => 
        User (
          id: id,
          username: username,
          token: token,
        ),
      _ => throw const FormatException('Failed to load User from Json'),
    };
  }
}
