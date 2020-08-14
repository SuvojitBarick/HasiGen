part of 'homepage_bloc.dart';

@immutable
abstract class HomepageEvent extends Equatable {}

class FetchHashTagsBasedOnImage extends HomepageEvent {
  @override
  List<Object> get props => [];
}

class FetchHashtagsBasedOnText extends HomepageEvent {
  final String keyword;
  final String genre;

  FetchHashtagsBasedOnText({this.keyword, this.genre});
  @override
  List<Object> get props => [];
}

class FetchPopularHashtag extends HomepageEvent {
  final int tabNumber;

  FetchPopularHashtag({this.tabNumber});
  @override
  List<Object> get props => [];
}
