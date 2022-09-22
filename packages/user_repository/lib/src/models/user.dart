import 'package:equatable/equatable.dart';

/// {@template user}
/// An object which represents a specific user.
/// {@endtemplate}
class User extends Equatable {
  /// {@macro user}
  const User({required this.id, this.email = '', this.password = ''});

  /// An empty user (unauthenticated).
  static const User empty = User(id: '');

  /// The user's id.
  final String id;

  /// The user's email.
  final String email;

  /// The user's password.
  final String password;

  @override
  List<Object> get props => [id, email, password];
}
