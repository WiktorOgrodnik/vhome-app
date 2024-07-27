part of 'home_cubit.dart';

enum HomeSubPage {
  tasksets,
  devices,
  settings,
}

final class HomeState extends Equatable {
  const HomeState({
    this.page = HomeSubPage.tasksets,
  });

  final HomeSubPage page;

  @override
  List<Object> get props => [page];
}
