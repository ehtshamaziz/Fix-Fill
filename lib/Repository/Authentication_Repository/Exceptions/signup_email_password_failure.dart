
class SignupWithEmailPasswordFailure{
  late final String message;

  SignupWithEmailPasswordFailure([this.message="Unknown error occurred"]);


  factory SignupWithEmailPasswordFailure.code(String code){
    print('Hello ${code}');

    switch(code){
      case'INVALID_LOGIN_CREDENTIALS':
        return SignupWithEmailPasswordFailure('Wrong Credentials');
  case'weak-password':
     return SignupWithEmailPasswordFailure('Please enter a stronger password');
  case'invalid-email':
    // message="Email is not valid";

    return SignupWithEmailPasswordFailure('Email is not valid');
  case'email-already-in-use':
    return SignupWithEmailPasswordFailure('An account already exist with this email.');
  case'user-disabled':
    return SignupWithEmailPasswordFailure('The user has been disabled. Please contact support for help.');
default:
  return SignupWithEmailPasswordFailure();

}
  }
}