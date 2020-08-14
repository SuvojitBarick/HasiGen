import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashigen/bloc/homepage_bloc.dart';
import 'package:hashigen/repository/getHashTags.dart';
import 'package:hashigen/widgets/greeting.dart';
import 'package:hashigen/widgets/loading.dart';
import 'package:hashigen/widgets/showTags.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  HomepageBloc _homepageBloc;
  TabController _tabController;
  List<String> _listOfTabs = ['Today', 'Last week', 'Last month', 'All time'];
  List<String> _listOFGenres = ['top', 'random', 'live'];
  bool _imageSearching = false;
  int _selectedRadio = 0;
  TextEditingController _searhController = TextEditingController();

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);

    super.initState();
  }

  @override
  void dispose() {
    _homepageBloc.close();
    _tabController.dispose();
    _searhController.dispose();
    super.dispose();
  }

  void refreshPage() {
    _searhController.clear();
    setState(() {
      _imageSearching = false;
    });
    _homepageBloc.add(FetchPopularHashtag(tabNumber: _tabController.index));
  }

  void handleSearchTap() {
    _homepageBloc.add(FetchHashtagsBasedOnText(
        genre: _listOFGenres[_selectedRadio],
        keyword: _searhController.text.trim()));
  }

  void handleRadioValue(int val) {
    setState(() {
      _selectedRadio = val;
    });
    handleSearchTap();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomepageBloc(getHashTags: GetHashTags()),
      child: Scaffold(
          backgroundColor: Color.fromRGBO(28, 36, 60, 1),
          body: Container(
            margin: EdgeInsets.only(left: 15, right: 15, top: 25),
            child: Column(
              children: [
                Greetings(),
                SizedBox(
                  height: 10,
                ),
                searchBar(),
                SizedBox(
                  height: 10,
                ),
                _imageSearching ? Container() : tabs(),
                SizedBox(
                  height: 15,
                ),
                Expanded(child: blocController())
              ],
            ),
          )),
    );
  }

  Widget blocController() {
    return BlocBuilder<HomepageBloc, HomepageState>(
      builder: (context, state) {
        if (state is HomepageInitial) {
          _homepageBloc = BlocProvider.of<HomepageBloc>(context);
          _homepageBloc.add(FetchPopularHashtag(tabNumber: 0));
        } else if (state is LoadingState)
          return Loading();
        else if (state is ImageHashtagLoadedState)
          return ShowTags(
            image: state.image,
            imageSearching: _imageSearching,
            refresh: refreshPage,
            tags: state.listOfTags,
          );
        else if (state is PopularHashtagLoadedState)
          return tabsData(state.listOfTags);
        else if (state is TextHashtagLoadedState)
          return ShowTags(
            imageSearching: false,
            refresh: refreshPage,
            tags: state.listOfTags,
          );
        else if (state is ErrorState)
          return Center(child: Text("image error "));
        return Container();
      },
    );
  }

  Widget searchBar() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(30),
        color: Colors.white.withOpacity(0.3),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searhController,
              autocorrect: true,
              cursorColor: Colors.white,
              style: TextStyle(
                  fontFamily: "gilroy", fontSize: 22, color: Colors.white),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
                border: InputBorder.none,
                hintText: "Search by image or text",
                hintStyle: TextStyle(
                    fontFamily: "gilroy", fontSize: 18, color: Colors.white),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: handleSearchTap,
          ),
          IconButton(
            icon: Icon(
              Icons.camera_alt,
              color: Colors.white,
            ),
            onPressed: () {
              _searhController.clear();
              setState(() {
                _imageSearching = true;
              });
              _homepageBloc.add(
                FetchHashTagsBasedOnImage(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget tabs() {
    return TabBar(
      isScrollable: true,
      tabs: _listOfTabs.map((element) {
        return Text(
          element,
          style: TextStyle(fontFamily: "gilroy", fontSize: 22),
        );
      }).toList(),
      controller: _tabController,
      indicatorColor: Color.fromRGBO(43, 213, 203, 1),
      labelColor: Color.fromRGBO(43, 213, 203, 1),
      unselectedLabelColor: Colors.white.withOpacity(0.7),
      indicatorSize: TabBarIndicatorSize.tab,
    );
  }

  Widget tabsData(List list) {
    return TabBarView(
      children: list.map((listOfTags) {
        return ShowTags(
          imageSearching: false,
          tags: listOfTags,
          refresh: refreshPage,
        );
      }).toList(),
      controller: _tabController,
    );
  }
}
