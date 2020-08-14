part of 'homepage_bloc.dart';

@immutable
abstract class HomepageState extends Equatable {}

class HomepageInitial extends HomepageState {
  @override
  List<Object> get props => [];
}

class LoadingState extends HomepageState {
  @override
  List<Object> get props => [];
}

class PopularHashtagLoadedState extends HomepageState {
  final List listOfTags;

  PopularHashtagLoadedState(this.listOfTags);
  @override
  List<Object> get props => [];
}

class ErrorState extends HomepageState {
  @override
  List<Object> get props => [];
}

class TextHashtagLoadedState extends HomepageState {
  final List listOfTags;

  TextHashtagLoadedState(this.listOfTags);
  @override
  List<Object> get props => [];
}

class ImageHashtagLoadedState extends HomepageState {
  final List listOfTags;
  final File image;
  ImageHashtagLoadedState({this.listOfTags, this.image});
  @override
  List<Object> get props => [];
}
