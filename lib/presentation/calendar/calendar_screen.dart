import "package:circles_app/circles_localization.dart";
import "package:circles_app/domain/redux/app_actions.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/channel/channel_actions.dart";
import "package:circles_app/presentation/calendar/calendar_item.dart";
import "package:circles_app/presentation/calendar/calendar_screen_viewmodel.dart";
import "package:circles_app/presentation/home/channel_list/channel_list.dart";
import "package:circles_app/theme.dart";
import "package:circles_app/util/date_formatting.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_redux/flutter_redux.dart";

@immutable
class CalendarScreen extends StatelessWidget {
  final _scrollController = ScrollController();

  /// Calendar header

  _buildHeaderItem(
    context,
    CalendarHeaderItem item,
  ) {
    final datePrefix = item.isToday
        ? CirclesLocalizations.of(context).calendarStringToday
        : "";
    return Opacity(
      opacity: item.isPast ? _Style.pastItemOpacity : 1.0,
      child: Container(
        padding: _Style.defaultElementPadding,
        alignment: _Style.calenderHeaderAlignment,
        height: _Style.calenderHeaderHeight,
        child: Text(
          "$datePrefix ${formatCalendarDate(context, item.date)}",
          style: AppTheme.calendarDayTitle,
          maxLines: 1,
          textScaleFactor: 1,
          overflow: TextOverflow.clip,
        ),
      ),
    );
  }

  /// Calendar entry

  _buildEntryItem(
    context,
    CalendarEntryItem item,
  ) {
    return Opacity(
      opacity: item.isPast ? _Style.pastItemOpacity : 1.0,
      child: Container(
        margin: EdgeInsets.only(
          left: DrawerStyle.defaultPadding,
          right: DrawerStyle.defaultPadding,
        ),
        decoration: BoxDecoration(
          color: item.isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
        padding: _Style.defaultElementPadding,
        height: _Style.calenderItemHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _timeWidget(
              context,
              item.date,
              item.isAllDay,
            ),
            Container(
                padding: EdgeInsets.only(left: DrawerStyle.defaultPadding),
                width:
                    DrawerStyle.listWidth - (90 + DrawerStyle.defaultPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item.eventName,
                      style: AppTheme.calendarListEventName,
                      maxLines: 1,
                      textScaleFactor: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                    ),
                    Text(
                      item.groupName,
                      style: AppTheme.calendarListGroupName,
                      maxLines: 1,
                      textScaleFactor: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  _timeWidget(
    BuildContext context,
    DateTime date,
    bool isAllDay,
  ) {
    return Container(
        width: 70,
        child: Center(
            child: Container(
          decoration: BoxDecoration(
            color: AppTheme.colorDarkBlue,
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            ),
          ),
          height: 24,
          width: 60,
          child: Center(
              child: Text(
            isAllDay
                ? CirclesLocalizations.of(context).calendarStringAllDay
                : formatTime(context, date),
            textScaleFactor: 1,
            style: AppTheme.calendarListTime,
          )),
          // color: AppTheme.colorDarkBlue,
        )));
  }

  /// Calendar

  _buildCalendarList(
    BuildContext context,
    CalendarScreenViewModel viewModel,
  ) {
    final numberOfHeaderItems = viewModel.headerItemSizeMap.keys.length;
    final items = viewModel.calendar.toList();
    double lastSectionHeight = 0;

    if (numberOfHeaderItems > 0) {
      final lastHeaderItems =
          viewModel.headerItemSizeMap[numberOfHeaderItems - 1];
      lastSectionHeight = _Style.calenderHeaderHeight +
          _Style.calenderItemHeight * lastHeaderItems;
    }

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return ListView.builder(
          padding: EdgeInsets.only(
              top: _Style.titleHeight,
              bottom: constraints.minHeight - (lastSectionHeight + _Style.titleHeight)),
          controller: _scrollController,
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];

            if (item is CalendarHeaderItem) {
              return _buildHeaderItem(
                context,
                item,
              );
            } else if (item is CalendarEntryItem) {
              return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: DrawerStyle.selectionBorderRadius,
                    highlightColor: Colors.white24,
                    onTap: () {
                      _selectCalendarEvent(context: context, item: item);
                    },
                    child: _buildEntryItem(
                      context,
                      item,
                    ),
                  ));
            }

            return Container();
          });
    });
  }

  _selectCalendarEvent({
    context,
    item,
  }) {
    Navigator.pop(context);

    final provider = StoreProvider.of<AppState>(context);
    final previousChannelId = provider.state.channelState.selectedChannel;

    provider.dispatch(SelectGroup(item.groupId));

    provider.dispatch(
      SelectChannelIdAction(
        channelId: item.eventId,
        groupId: provider.state.selectedGroupId,
        userId: provider.state.user.uid,
        previousChannelId: previousChannelId,
      ),
    );
  }

  _calendar(
    BuildContext context,
    CalendarScreenViewModel viewModel,
  ) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Stack(
        children: <Widget>[
          Container(
            width: DrawerStyle.listWidth,
            height: constraints.maxHeight,
            child: _buildCalendarList(context, viewModel),
          ),
          Container(
            color: Colors.white.withAlpha(240),
            padding: _Style.defaultElementPadding,
            width: DrawerStyle.listWidth,
            height: _Style.titleHeight,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      alignment: Alignment(-1.0, 0.6),
                      child: Text(
                        CirclesLocalizations.of(context).calendarTitle,
                        style: AppTheme.circleTitle,
                        textScaleFactor: 1,
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      width: 50,
                      child: FlatButton(
                        child: Image.asset(
                            "assets/graphics/calendar/calendar_today.png"),
                        onPressed: () {
                          _setScrollOffsetToSelectedEntry(
                            animated: true,
                            viewModel: viewModel,
                            toSelectedEntry: false,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  /// Setting the offset to upcoming events or a selected item
  _setScrollOffsetToSelectedEntry({
    CalendarScreenViewModel viewModel,
    bool toSelectedEntry,
    bool animated,
  }) {
    final headerIndex = toSelectedEntry
        ? viewModel.selectedEventHeaderIndex
        : viewModel.upcomingEventHeaderIndex;

    final headersHeight = (headerIndex * _Style.calenderHeaderHeight);
    var items = 0;

    viewModel.headerItemSizeMap.forEach((key, value) {
      if (key <= headerIndex) {
        items += value;
      }
    });

    final itemsHeight = items * _Style.calenderItemHeight;
    final offset = itemsHeight + headersHeight;

    if (animated) {
      _scrollController.animateTo(
        offset,
        curve: Curves.elasticInOut,
        duration: Duration(milliseconds: 400),
      );
    } else {
      _scrollController.jumpTo(offset);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CalendarScreenViewModel>(
        converter: CalendarScreenViewModel.fromStore,
        distinct: true,
        builder: (context, viewModel) {
          final calendar = _calendar(context, viewModel);

          // Scrolls to upcoming events or selected group
          Future.delayed(Duration(milliseconds: 0), () {
            if (_scrollController.offset == 0) {
              _setScrollOffsetToSelectedEntry(
                viewModel: viewModel,
                toSelectedEntry: viewModel.selectedEventHeaderIndex != -1,
                animated: false,
              );
            }
          });

          return calendar;
        });
  }
}

/// Private Styles
class _Style {
  static const topSectionHeight =
      _Style.titleHeight + DrawerStyle.sectionPadding * 2;

  static const pastItemOpacity = 0.6;
  static const defaultElementPadding = EdgeInsets.only(
    left: 4,
    right: 4,
  );

  static const titleHeight = 100.0;

  static const calenderHeaderHeight = 32.0;
  static const calenderHeaderAlignment = AlignmentDirectional(-1.0, 0.0);

  static const calenderItemHeight = 62.0;
}
