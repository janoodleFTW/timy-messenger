import "package:circles_app/domain/redux/app_actions.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/model/group.dart";
import "package:circles_app/presentation/common/platform_alerts.dart";
import "package:circles_app/presentation/home/circles_drawer.dart";
import "package:circles_app/presentation/home/group_list/group_list_viewmodel.dart";
import "package:circles_app/routes.dart";
import "package:circles_app/theme.dart";
import "package:circles_app/util/HexColor.dart";
import "package:flutter/material.dart";
import "package:flutter_redux/flutter_redux.dart";

class GroupList extends StatefulWidget {
  final Function(DrawerState) stateChangeCallback;

  const GroupList(this.stateChangeCallback);

  @override
  _GroupListState createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  bool _calendarSelected = false;

  _buildFirstSection(BuildContext context) {
    return Container(
        height: _Style.firstSectionHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
                child: Row(children: <Widget>[
              ..._buildSelectionHighlight(_calendarSelected, Colors.white),
              _selectableListItem(
                  icon: Image.asset("assets/graphics/drawer/events.png"),
                  isSelected: _calendarSelected,
                  action: () {
                    widget.stateChangeCallback(DrawerState.CALENDAR);
                    setState(() {
                      _calendarSelected = true;
                    });
                  }),
            ])),
            Padding(
              padding: EdgeInsets.only(
                top: _Style.padding,
              ),
            ),
            Container(
              color: AppTheme.colorDarkGreen,
              height: _Style.separatorHeight,
              width: _Style.separatorWidth,
            ),
          ],
        ));
  }

  _buildThirdSection(BuildContext context) {
    return Container(
        height: _Style.thirdSectionHeight,
        child: Column(
          children: <Widget>[
            _Style.defaultPadding,
            _GroupSettingsButton(
                Image.asset("assets/graphics/drawer/create_topic.png"), () {
              showSoonAlert(context: context);
            }),
          ],
        ));
  }

  _buildFourthSection(BuildContext context) {
    return Container(
      height: _Style.fourthSectionHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          _GroupSettingsButton(
            Image.asset("assets/graphics/drawer/settings.png"),
            () {
              Navigator.pushNamed(context, Routes.settings);
            },
          ),
          _Style.defaultPadding,
          _GroupSettingsButton(
            Image.asset("assets/graphics/drawer/account.png"),
            () {
              _openUserAccount(context);
            },
          ),
          _Style.defaultPadding,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GroupListViewModel>(
      converter: GroupListViewModel.fromStore,
      distinct: true,
      builder: (context, viewModel) {
        final secondSectionHeight = viewModel.groups.length * _Style.itemHeight;
        final statusBarHeight = MediaQuery.of(context).padding.top;
        final topPadding = MediaQuery.of(context).size.height -
            (_Style.totalStaticSectionHeight +
                secondSectionHeight +
                statusBarHeight);

        final items = [
          _buildFirstSection(context),
          ...viewModel.groups.toList(),
          _buildThirdSection(context),
          // Atempt to position fourth section in bottom of screen.
          // Attach it with padding if there isn't enough space available.
          Padding(
            padding: EdgeInsets.only(
                top: topPadding < 100 ? _Style.padding * 2 : topPadding),
          ),
          _buildFourthSection(context)
        ];

        return Container(
          height: MediaQuery.of(context).size.height,
          width: _Style.listWidth,
          color: AppTheme.colorDarkBlue.withOpacity(0.3),
          child: ListView.builder(
              padding: EdgeInsets.only(top: 0),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];

                if (item is Group) {
                  return _GroupListItem(
                    item,
                    item.id == viewModel.selectedGroupId && !_calendarSelected,
                    viewModel.updatedGroups.contains(item.id),
                    () {
                      widget.stateChangeCallback(DrawerState.CHANNEL);
                      setState(() {
                        _calendarSelected = false;
                      });
                    },
                  );
                } else {
                  return item;
                }
              }),
        );
      },
    );
  }

  void _openUserAccount(BuildContext context) {
    final uid = StoreProvider.of<AppState>(context).state.user.uid;
    Navigator.of(context).pushNamed(Routes.user, arguments: uid);
  }
}

class _GroupListItem extends StatelessWidget {
  final Group _group;
  final bool _selected;
  final bool _hasUpdates;
  final Function _selectionCallback;

  const _GroupListItem(
    group,
    selected,
    hasUpdates,
    selectionCallback, {
    Key key,
  })  : _group = group,
        _selected = selected,
        _hasUpdates = hasUpdates,
        _selectionCallback = selectionCallback,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: _Style.itemHeight,
        child: Padding(
          padding: const EdgeInsets.only(
            top: _Style.padding,
            right: _Style.padding,
          ),
          child: _GroupButton(
            _group,
            (id) {
              _selectionCallback();
              _selectGroup(context, id);
            },
            _selected,
            _hasUpdates,
          ),
        ));
  }

  void _selectGroup(
    BuildContext context,
    String id,
  ) {
    StoreProvider.of<AppState>(context).dispatch(SelectGroup(id));
  }
}

class _GroupSettingsButton extends StatelessWidget {
  final Image image;
  final Function onPressed;

  const _GroupSettingsButton(
    this.image,
    this.onPressed, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: _Style.circleButtonWidth,
        height: _Style.circleButtonWidth,
        child: FittedBox(
            fit: BoxFit.cover,
            child: FlatButton(
              shape: CircleBorder(),
              child: image,
              onPressed: onPressed,
            )));
  }
}

class _GroupButton extends StatelessWidget {
  final Group group;
  final Function(String) onPressedCircle;
  final bool isSelected;
  final bool hasUpdates;

  const _GroupButton(
    this.group,
    this.onPressedCircle,
    this.isSelected,
    this.hasUpdates, {
    Key key,
  })  : assert(group != null),
        assert(onPressedCircle != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final _circleColor = HexColor(group.hexColor);
    final _groupText = group.abbreviation.substring(0, 2).toUpperCase();

    return Container(
      child: Row(
        children: <Widget>[
          ..._buildSelectionHighlight(isSelected, _circleColor),
          _selectableListItem(
            color: _circleColor,
            text: _groupText,
            action: () {
              onPressedCircle(group.id);
            },
            updateIndicatorVisible: hasUpdates,
            isSelected: isSelected,
          ),
        ],
      ),
    );
  }
}

_selectableListItem({
  Color color = Colors.white,
  String text = "",
  Image icon,
  Function action,
  bool updateIndicatorVisible = false,
  bool isSelected = false,
}) {
  return AnimatedContainer(
    duration: Duration(milliseconds: 100),
    width: _Style.circleButtonWidth,
    height: _Style.circleButtonWidth,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.all(Radius.circular(isSelected ? 8.0 : 22.0)),
    ),
    child: Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        InkWell(
          child: Center(
              child: Container(
            alignment: Alignment(0, 0.2),
            width: _Style.circleButtonWidth,
            height: _Style.circleButtonWidth,
            child: icon == null
                ? Text(text, style: AppTheme.circleMenuAbbreviationText)
                : icon,
          )),
          onTap: action,
        ),
        Visibility(
          visible: updateIndicatorVisible,
          child: Positioned(
            top: -2,
            right: -2,
            height: _Style.circleUnreadIndicatorWidth,
            width: _Style.circleUnreadIndicatorWidth,
            child: Image.asset(
              "assets/graphics/update_indicator_darkgreen.png",
            ),
          ),
        ),
      ],
    ),
  );
}

List<Widget> _buildSelectionHighlight(isSelected, circleColor) {
  final List<Widget> widgets = [];
  if (isSelected) {
    final highlight = ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(_Style.circleHighlightBorderRadius),
            bottomRight: Radius.circular(_Style.circleHighlightBorderRadius)),
        child: Container(
          width: _Style.circleHighlightWidth,
          height: _Style.circleButtonWidth,
          color: circleColor,
        ));
    widgets.add(highlight);
  }

  final sizedBoxSpace = SizedBox(
    width: (isSelected ? 11 : 15),
  );

  widgets.add(sizedBoxSpace);
  return widgets;
}

class _Style {
  static const listWidth = 72.0;
  static const circleButtonWidth = 44.0;

  static const circleHighlightWidth = 4.0;
  static const circleHighlightBorderRadius = 10.0;
  static const circleUnreadIndicatorWidth = 14.0;

  static const separatorHeight = 2.0;
  static const separatorWidth = 48.0;
  static const padding = 8.0;
  static const defaultPadding = Padding(padding: EdgeInsets.only(top: padding));

  static const itemHeight = 52.0;
  static const firstSectionHeight = 100.0;
  static const thirdSectionHeight = 60.0;
  static const fourthSectionHeight = 180.0;
  static const totalStaticSectionHeight =
      340.0; // Sum of all sections without itemHeight
}
