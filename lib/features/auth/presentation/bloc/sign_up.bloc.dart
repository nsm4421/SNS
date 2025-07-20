import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns/features/auth/domain/usecase/sign_up.usecase.dart';

part 'sign_up.state.dart';

part 'sign_up.event.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUpUseCase _useCase;

  SignUpBloc(this._useCase) : super(SignUpInitial()) {
    on<SignUpSubmitted>(_onSubmitted);
  }

  _onSubmitted(SignUpSubmitted event, Emitter<SignUpState> emit) async {
    emit(SignUpLoading());
    await _useCase.call(
      email: event.email,
      password: event.password,
      username: event.username,
    );
    emit(SignUpSuccess());
  }
}
