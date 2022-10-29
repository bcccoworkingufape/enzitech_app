abstract class IUserRepo {
  Future<void> createUser({
    required String name,
    required String institution,
    required String email,
    required String password,
  });

  Future<void> recoverPassword({required String email});
}
