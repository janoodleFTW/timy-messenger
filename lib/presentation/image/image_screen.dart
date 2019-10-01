import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/model/message.dart";
import "package:circles_app/presentation/common/common_app_bar.dart";
import "package:circles_app/presentation/image/image_with_loader.dart";
import "package:circles_app/routes.dart";
import "package:circles_app/theme.dart";
import "package:circles_app/util/date_formatting.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_redux/flutter_redux.dart";

class ImageScreen extends StatefulWidget {
  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  int _selectedImage = 0;
  Message _message;
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  final _itemExtent = 48.0 + 8.0;
  double _screenWidth = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final newSelectedImage = _pageController.page.round();
      if (newSelectedImage != _selectedImage) {
        setState(() {
          _selectedImage = newSelectedImage;
          final double position = _calculateScrollPosition(_selectedImage)
              .clamp(0.0, _scrollController.position.maxScrollExtent);
          _scrollController.animateTo(
            position,
            duration: Duration(milliseconds: 200),
            curve: Curves.ease,
          );
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _message = ModalRoute.of(context).settings.arguments;
    _screenWidth = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: _getAuthorName(context),
        subtitle: _getMessageTime(context),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _buildCurrentSelectedImage(),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  String _getMessageTime(BuildContext context) =>
      formatDateShort(context, _message.timestamp) +
      ", " +
      formatTime(context, _message.timestamp);

  String _getAuthorName(BuildContext context) =>
      StoreProvider.of<AppState>(context)
          .state
          .groupUsers
          .firstWhere((u) => u.uid == _message.authorId)
          .name;

  Widget _buildCurrentSelectedImage() {
    return Expanded(
      child: PageView.builder(
        controller: _pageController,
        itemCount: _message.media.length,
        itemBuilder: (context, position) {
          final url = _message.media[position];
          return InkWell(
            child: ImageWithLoader(
              url: url,
            ),
            onTap: () {
              return Navigator.pushNamed(
                context,
                Routes.imagePinch,
                arguments: url,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      height: 64,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: _message.media.length,
        itemExtent: _itemExtent,
        padding: EdgeInsets.all(8),
        shrinkWrap: true,
        itemBuilder: (context, position) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              child: InkWell(
                child: Container(
                  decoration: _selectedImage == position
                      ? BoxDecoration(
                          border: Border.all(
                          color: AppTheme.colorDarkBlueImageSelection,
                          width: 4,
                        ))
                      : null,
                  child: ImageWithLoader(
                    url: _message.media[position],
                    loaderSize: 16.0,
                  ),
                ),
                onTap: () {
                  _pageController.animateToPage(
                    position,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.ease,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  double _calculateScrollPosition(int selectedImage) {
    return (_itemExtent * selectedImage) -
        (_screenWidth / 2) +
        (_itemExtent / 2);
  }
}
