import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void setTab(HomeSubPage page) => emit(HomeState(page: page));
}
