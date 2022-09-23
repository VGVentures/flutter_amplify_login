import 'package:equatable/equatable.dart';

/// {@template amplify_user}
/// Amplify user model
/// {@endtemplate}
class AmplifyUser extends Equatable {
  /// {@macro amplify_user}
  const AmplifyUser({
    required this.id,
    required this.email,
  });

  /// ID of the amplify user.
  final String id;

  /// Email of the amplify user.
  final String email;

  @override
  List<Object?> get props => [id, email];

  /// Empty Amplify object.
  static const anonymous = AmplifyUser(
    id: '',
    email: '',
  );
}
