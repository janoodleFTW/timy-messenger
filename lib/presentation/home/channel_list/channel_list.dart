import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/channel/channel_actions.dart";
import "package:circles_app/model/channel.dart";
import "package:circles_app/presentation/home/channel_list/channel_list_item.dart";
import "package:circles_app/presentation/home/channel_list/channel_list_viewmodel.dart";
import "package:circles_app/presentation/home/channel_list/event_status_icon_widget.dart";
import "package:circles_app/presentation/home/channel_list/group_status_icon_widget.dart";
import "package:circles_app/theme.dart";
import "package:flutter/material.dart";
import "package:flutter_redux/flutter_redux.dart";

class ChannelsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ChannelListViewModel>(
        converter: ChannelListViewModel.fromStore,
        distinct: true,
        builder: (context, viewModel) {
          final items = viewModel.items.toList();
          return Container(
              width: DrawerStyle.listWidth,
              child: Padding(
                padding: EdgeInsets.only(left: DrawerStyle.defaultPadding, right: DrawerStyle.defaultPadding),
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final previousItem = index > 0 ? items[index - 1] : null;
                    return _buildChannelList(item, previousItem, index);
                  },
                ),
              ));
        });
  }

  _buildChannelList(ChannelListItem item, previousItem, index) {
    if (item is ChannelListChannelItem) {
      return _ChannelItemWidget(item);
    } else if (item is ChannelListHeadingItem) {
      // Avoid additional padding if previous item in list isn't a channel.
      final followsChannelItem = previousItem is ChannelListChannelItem;
      final heading = _ChannelListHeadingWidget(
          item, followsChannelItem ? DrawerStyle.sectionPadding : 0);

      // Add padding for first title item.
      return index == 0
          ? Padding(
              padding: EdgeInsets.only(top: 20),
              child: heading,
            )
          : heading;
    } else if (item is ChannelListActionItem) {
      return _ChannelListActionItemWidget(item);
    }

    return Container();
  }
}

//- The following private widgets are only used to construct the list above.

class _ChannelListActionItemWidget extends StatelessWidget {
  final ChannelListActionItem _item;

  const _ChannelListActionItemWidget(this._item);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: DrawerStyle.doublePadding),
        child: Row(children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: DrawerStyle.doublePadding),
              child: Text(
                ChannelItemTitleKeyHelper.stringOf(_item.title, context),
                style: AppTheme.circleSectionButtonTitle,
                textScaleFactor: 1,
              ),
            ),
          ),
          Container(
              width: 50,
              child: FlatButton(
                  onPressed: () => {_item.buttonAction(context)},
                  child: Image.asset(
                      "assets/graphics/channel/create_new_channel.png"))),
        ]));
  }
}

class _ChannelListHeadingWidget extends StatelessWidget {
  final ChannelListHeadingItem _item;
  final double _topPadding;

  const _ChannelListHeadingWidget(this._item, this._topPadding);

  @override
  Widget build(BuildContext context) {
    final title = _item.text != null
        ? _item.text
        : ChannelItemTitleKeyHelper.stringOf(_item.key, context);

    return Padding(
      padding:
          EdgeInsets.only(left: DrawerStyle.doublePadding, top: _topPadding),
      child: _styledHeadline(title, _item.type),
    );
  }

  _styledHeadline(String title, ChannelListHeadingItemType type) {
    switch (type) {
      case ChannelListHeadingItemType.SECTION:
        return Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(title, style: AppTheme.circleSectionTitle));
      case ChannelListHeadingItemType.H1:
        return Text(title, style: AppTheme.circleTitle);
      case ChannelListHeadingItemType.H2:
        return Padding(
            padding: EdgeInsets.only(top: DrawerStyle.sectionPadding),
            child: Stack(
              children: <Widget>[
                Text(title, style: AppTheme.circleSectionButtonTitle),
                Positioned(
                    right: 20,
                    child: Image.asset(
                      "assets/graphics/updates_indicator.png",
                      width: 12,
                    ))
              ],
            ));
    }
  }
}

class _ChannelItemWidget extends StatelessWidget {
  final ChannelListChannelItem _item;

  const _ChannelItemWidget(this._item);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
            borderRadius: DrawerStyle.selectionBorderRadius,
            highlightColor: Colors.white24,
            onTap: () {
              Navigator.pop(context);
              final provider = StoreProvider.of<AppState>(context);
              final previousChannelId =
                  provider.state.channelState.selectedChannel;
              provider.dispatch(
                SelectChannel(
                    channel: _item.channel,
                    groupId: provider.state.selectedGroupId,
                    userId: provider.state.user.uid,
                    previousChannelId: previousChannelId),
              );
            },
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: DrawerStyle.selectionBorderRadius,
                    color:
                        _item.isSelected ? Colors.white : Colors.transparent),
                child: Padding(
                    padding: EdgeInsets.only(
                      left: DrawerStyle.doublePadding,
                      right: DrawerStyle.doublePadding,
                    ),
                    child: Container(
                        height: DrawerStyle.rowHeight,
                        child: Row(
                          children: <Widget>[
                            _buildIcon(_item),
                            Padding(
                                padding: EdgeInsets.only(top: 2),
                                child: Container(
                                    width: 160,
                                    child: Text(_item.title,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTheme
                                            .circleSectionChannelTitle)))
                          ],
                        ))))));
  }

  _buildIcon(ChannelListChannelItem item) {
    if (item.channel.type == ChannelType.EVENT) {
      try {
        return EventStatusIconWidget(
          joined: item.userIsMember,
          isPublic: item.isPublic,
          eventDate: item.channel.startDate ?? DateTime.now(),
        );
      } catch (e) {
        return Container();
      }
    }
    return GroupStatusIconWidget(
        joined: item.userIsMember, isPrivateChannel: !item.isPublic);
  }
}

class DrawerStyle {
  static const listWidth = 232.0;
  static const defaultPadding = 5.0;
  static const doublePadding = 10.0;
  static const selectionBorderRadius = BorderRadius.all(Radius.circular(4.0));
  static const sectionPadding = 20.0;
  static const rowHeight = 44.0;
}
