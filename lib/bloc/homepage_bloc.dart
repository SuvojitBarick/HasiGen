import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:hashigen/repository/getHashTags.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'homepage_event.dart';
part 'homepage_state.dart';

class HomepageBloc extends Bloc<HomepageEvent, HomepageState> {
  final GetHashTags getHashTags;
  List listOfAllTags;
  File imagePath;
  HomepageBloc({this.getHashTags}) : super(HomepageInitial());

  @override
  Stream<HomepageState> mapEventToState(
    HomepageEvent event,
  ) async* {
    if (event is FetchHashtagsBasedOnText) {
      yield LoadingState();
      try {
        List list = await getHashTags.searchTags(
            genre: event.genre ?? "top",
            keyword: event.keyword,
            forImage: false);
        yield TextHashtagLoadedState(list);
      } catch (e) {
        yield ErrorState();
      }
    }

    if (event is FetchHashTagsBasedOnImage) {
      yield LoadingState();
      try {
        List detectedObjects = await getImageFromGallery() as List;
        List detectedHashtags = [];
        await Future.forEach(detectedObjects, (labels) async {
          List list = await getHashTags.searchTags(
              genre: "top", keyword: labels, forImage: true) as List;
          list.forEach((element) {
            if (element.length != 0) detectedHashtags.add(element);
          });
        });

        yield ImageHashtagLoadedState(
            image: imagePath, listOfTags: detectedHashtags);
      } catch (e) {
        print(e);
        yield ErrorState();
      }
    }

    if (event is FetchPopularHashtag) {
      yield LoadingState();
      try {
        listOfAllTags = await getHashTags.topDailyHashtags();
        yield PopularHashtagLoadedState(listOfAllTags);
      } catch (e) {
        print(e);
        yield ErrorState();
      }
    }

    if (event is FetchHashtagsBasedOnText) {
      yield LoadingState();
      try {
        List list = await getHashTags.searchTags(
            forImage: false, genre: event.genre, keyword: event.keyword);
        yield TextHashtagLoadedState(list);
      } catch (e) {
        print(e);
        yield ErrorState();
      }
    }
  }

  Future getImageFromGallery() async {
    PickedFile file = await ImagePicker().getImage(source: ImageSource.gallery);
    imagePath = File(file.path);
    return detect(image: imagePath);
  }

  Future detect({File image}) async {
    List<String> listOfObjectsDetected = [];
    if (image != null) {
      final FirebaseVisionImage visionImage =
          FirebaseVisionImage.fromFile(image);
      final ImageLabeler labeler = FirebaseVision.instance.imageLabeler();
      final List<ImageLabel> labels = await labeler.processImage(visionImage);
      labels.forEach((label) {
        if (label.confidence > 0.5) listOfObjectsDetected.add(label.text);
      });
    }
    return listOfObjectsDetected;
  }
}
