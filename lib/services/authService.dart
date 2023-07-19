class AuthService{
  static bool validateLogin(String account, String password) {
    if (account.length != 5 || int.tryParse(account) == null) {
      return false;
    }
    if (password.length != 4 || int.tryParse(password) == null) {
      return false;
    }
    return true;
  }
}