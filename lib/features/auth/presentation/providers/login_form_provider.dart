import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/inputs.dart';

import 'auth_provider.dart';

//! 3 - StateNotifierProvider - Consume afuera
final loginFormProvider =
    StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
  final loginUserCallback = ref.watch(authProvider.notifier).loginUser;

  return LoginFormNotifier(loginUserCallback: loginUserCallback);
});

//! 2 - Cómo implementamos un notifier
class LoginFormNotifier extends StateNotifier<LoginFormState> {
  final Function(String, String) loginUserCallback;

  LoginFormNotifier({required this.loginUserCallback})
      : super(LoginFormState());

  onEmailChange(String value) {
    final newEmail = EmailInput.dirty(value);
    state = state.copyWith(
        emailInput: newEmail,
        isValid: Formz.validate([newEmail, state.passwordInput]));
  }

  onPasswordChange(String value) {
    final newPassword = PasswordInput.dirty(value);
    state = state.copyWith(
        passwordInput: newPassword,
        isValid: Formz.validate([newPassword, state.emailInput]));
  }

  onFormSubmit() async {
    _touchEveryField();

    if (!state.isValid) return;

    state = state.copyWith(isPosting: true);
    await loginUserCallback(state.emailInput.value, state.passwordInput.value);
    state = state.copyWith(isPosting: false);
  }

  _touchEveryField() {
    final emailInput = EmailInput.dirty(state.emailInput.value);
    final passwordInput = PasswordInput.dirty(state.passwordInput.value);

    state = state.copyWith(
        isFormPosted: true,
        emailInput: emailInput,
        passwordInput: passwordInput,
        isValid: Formz.validate([emailInput, passwordInput]));
  }
}

//! 1 - State de este provider
class LoginFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final EmailInput emailInput;
  final PasswordInput passwordInput;

  LoginFormState(
      {this.isPosting = false,
      this.isFormPosted = false,
      this.isValid = false,
      this.emailInput = const EmailInput.pure(),
      this.passwordInput = const PasswordInput.pure()});

  LoginFormState copyWith(
          {bool? isPosting,
          bool? isFormPosted,
          bool? isValid,
          EmailInput? emailInput,
          PasswordInput? passwordInput}) =>
      LoginFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        emailInput: emailInput ?? this.emailInput,
        passwordInput: passwordInput ?? this.passwordInput,
      );

  @override
  String toString() {
    return '''
      LoginFormState:
        isPosting: $isPosting
        isFormPosted: $isFormPosted
        isValid: $isValid
        emailInput: $emailInput
        passwordInput: $passwordInput
    ''';
  }
}
