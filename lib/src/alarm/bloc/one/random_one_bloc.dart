import 'package:bloc/bloc.dart';

part 'random_one_event.dart';
part 'random_one_state.dart';

class RandomOneBloc extends Bloc<RandomOneEvent, RandomOneState> {
  RandomOneBloc() : super(RandomOneInitial()) {
    on<RandomOneEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
  void init() {}
}
