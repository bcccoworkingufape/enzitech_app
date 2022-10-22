abstract class IUserRepo {
  Future<void> createUser(
    String name,
    String institution,
    String email,
    String password,
  );
}
