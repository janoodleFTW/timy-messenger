import "dart:async";

import "package:circles_app/circles_localization.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/channel/channel_actions.dart";
import "package:circles_app/model/channel.dart";
import "package:circles_app/presentation/channel/event/event_details_viewmodel.dart";
import "package:circles_app/presentation/channel/event/rsvp_dialog.dart";
import "package:circles_app/presentation/common/round_button.dart";
import "package:circles_app/presentation/user/rsvp_icon.dart";
import "package:circles_app/presentation/user/user_avatar.dart";
import "package:circles_app/presentation/user/user_item.dart";
import "package:circles_app/routes.dart";
import "package:circles_app/theme.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_platform_widgets/flutter_platform_widgets.dart";
import "package:flutter_redux/flutter_redux.dart";

class EventDetails extends StatelessWidget {
  const EventDetails({
    Key key,
    this.sideOpenController,
  }) : super(key: key);

  final ValueNotifier<bool> sideOpenController;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, EventDetailsViewModel>(
      distinct: true,
      converter: (vm) => EventDetailsViewModel.fromStore(context, vm),
      builder: (context, vm) {
        return _EventDetailsWidget(
          vm: vm,
          sideOpenController: sideOpenController,
        );
      },
    );
  }
}

class _EventDetailsWidget extends StatefulWidget {
  const _EventDetailsWidget({
    Key key,
    this.vm,
    this.sideOpenController,
  }) : super(key: key);

  final EventDetailsViewModel vm;
  final ValueNotifier<bool> sideOpenController;

  @override
  _EventDetailsWidgetState createState() => _EventDetailsWidgetState();
}

class _EventDetailsWidgetState extends State<_EventDetailsWidget>
    with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(left: BorderSide(color: AppTheme.colorGrey225))),
      child: Column(
        children: <Widget>[
          _buildHeader(),
          _buildTabBar(),
          _buildTabContent(),
        ],
      ),
    );
  }

  Stack _buildHeader() {
    return Stack(
      children: <Widget>[
        _buildBackground(),
        _buildGradient(),
        _buildHeaderText(),
        _buildEditButton(),
      ],
    );
  }

  Container _buildBackground() {
    return Container(
      height: _Style.headerSize,
      decoration: BoxDecoration(
        color: AppTheme.colorMintGreen,
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
              Color.fromRGBO(255, 255, 255, 0.1), BlendMode.modulate),
          image: AssetImage("assets/graphics/visual_twist_white_petrol.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Container _buildGradient() {
    return Container(
      height: _Style.headerSize,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            AppTheme.colorMintGreen,
            // Mint Green but transparent, so we have a nice gradient
            const Color.fromRGBO(54, 207, 166, 0.0),
          ],
        ),
      ),
    );
  }

  Positioned _buildHeaderText() {
    return Positioned(
      bottom: AppTheme.appMargin,
      left: AppTheme.appMargin,
      right: AppTheme.appMargin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.vm.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.topicDetailsNameTextStyle,
          ),
          Visibility(
            visible: widget.vm.description.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                widget.vm.description,
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
                style: AppTheme.topicDetailsDescriptionTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton() {
    return Positioned(
      top: 0,
      right: 0,
      child: SafeArea(
        child: Visibility(
          visible: widget.vm.editable,
          child: FlatButton(
              child: Text(
                CirclesLocalizations.of(context).edit,
                style: AppTheme.buttonTextStyle,
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  Routes.eventNew,
                  arguments: widget.vm.channel,
                );
              }),
        ),
      ),
    );
  }

  TabBar _buildTabBar() {
    return TabBar(
      controller: _tabController,
      tabs: <Widget>[
        _buildTab(CirclesLocalizations
            .of(context)
            .eventDetails),
        _buildTab(CirclesLocalizations
            .of(context)
            .eventGuests),
      ],
      labelPadding: EdgeInsets.all(0),
      indicatorColor: AppTheme.colorDarkBlueFont,
    );
  }

  Tab _buildTab(String title) {
    return Tab(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppTheme.colorGrey225),
          ),
        ),
        height: 60,
        child: Center(
          child: Text(
            title,
            style: AppTheme.topicDetailsTabTextStyle,
          ),
        ),
      ),
    );
  }

  Expanded _buildTabContent() {
    return Expanded(
      child: _TabBarView(
        controller: _tabController,
        children: <Widget>[
          _buildDetails(),
          _buildMemberList(),
        ],
      ),
    );
  }

  Widget _buildDetails() {
    return SizedBox.expand(
      child: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          _buildEventDate(),
          _buildEventLocation(),
          _buildVisibility(),
          _buildMembersCount(),
          _buildUserRsvp(),
          _buildLogout(),
        ],
      ),
    );
  }

  Widget _buildEventDate() {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(AppTheme.appMargin),
          child: Image.asset(
            "assets/graphics/channel/details_date.png",
            height: _Style.iconSize,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.vm.eventDate,
              textAlign: TextAlign.start,
              style: AppTheme.topicDetailsItemTextStyle,
            ),
            Visibility(
              visible: widget.vm.eventTime.isNotEmpty,
              child: Text(
                widget.vm.eventTime,
                textAlign: TextAlign.start,
                style: AppTheme.topicDetailsItemSubtitleTextStyle,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEventLocation() {
    return Visibility(
      visible: widget.vm.venue.isNotEmpty,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(AppTheme.appMargin),
            child: Image.asset(
              "assets/graphics/channel/details_location.png",
              height: _Style.iconSize,
            ),
          ),
          Text(
            widget.vm.venue,
            textAlign: TextAlign.start,
            style: AppTheme.topicDetailsItemTextStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildVisibility() {
    switch (widget.vm.visibility) {
      case ChannelVisibility.CLOSED:
        return Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(AppTheme.appMargin),
              child: Image.asset(
                "assets/graphics/channel/details_padlock.png",
                height: _Style.iconSize,
              ),
            ),
            Text(
              CirclesLocalizations
                  .of(context)
                  .eventPrivate,
              style: AppTheme.topicDetailsItemTextStyle,
            ),
          ],
        );
        break;
      case ChannelVisibility.OPEN:
      default:
      // Do not show for Open channels
        return Container();
        break;
    }
  }

  Widget _buildMembersCount() {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(AppTheme.appMargin),
          child: Image.asset(
            "assets/graphics/channel/details_members.png",
            height: _Style.iconSize,
          ),
        ),
        Text(
          CirclesLocalizations.of(context)
              .eventGuestCount(widget.vm.guestCount.toString()),
          style: AppTheme.topicDetailsItemTextStyle,
        ),
      ],
    );
  }

  Widget _buildUserRsvp() {
    return Visibility(
      visible: widget.vm.userRsvp != RSVP.UNSET,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(AppTheme.appMargin),
            child: UserAvatar(user: widget.vm.user),
          ),
          Text(
            CirclesLocalizations
                .of(context)
                .eventRsvpUser,
            style: AppTheme.topicDetailsItemTextStyle,
          ),
          Padding(
            padding: const EdgeInsets.only(left: AppTheme.appMargin),
            child: RsvpIcon(rsvp: widget.vm.userRsvp),
          ),
          Visibility(
            visible: widget.vm.canChangeRsvp,
            child: FlatButton(
              child: Text(
                CirclesLocalizations.of(context).eventRsvpChange,
                style: AppTheme.buttonTextStyle,
              ),
              onPressed: () {
                _showChangeRsvpDialog(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberList() {
    return ListView.builder(
      padding: EdgeInsets.all(0),
      itemCount: widget.vm.members.length + _canInviteUsers(),
      itemBuilder: (BuildContext context, int index) {
        if (index < widget.vm.members.length) {
          final member = widget.vm.members[index];
          return UserItem(
            user: member,
            rsvp: widget.vm.rsvpStatus[member.uid],
            isYou: member.uid == widget.vm.user.uid,
            isHost: member.uid == widget.vm.channel.authorId,
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(AppTheme.appMargin),
            child: RoundButton(
              text: CirclesLocalizations
                  .of(context)
                  .channelInviteButton,
              onTap: () {
                Navigator.of(context).pushNamed(Routes.channelInvite,
                    arguments: widget.vm.channel.id);
              },
            ),
          );
        }
      },
    );
  }

  /// Invite members is only visible if the channel is closed
  num _canInviteUsers() {
    if (widget.vm.channel.visibility == ChannelVisibility.CLOSED) {
      return 1;
    } else {
      return 0;
    }
  }

  _showChangeRsvpDialog(BuildContext context) {
    final completer = Completer();
    completer.future.then((rsvp) {
      showDialogRsvp(context, rsvp);
    });

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) =>
          CupertinoActionSheet(
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  CirclesLocalizations
                      .of(context)
                      .eventRsvpYes,
                  style: AppTheme.optionTextStyle,
                  textScaleFactor: 1,
                ),
                onPressed: () {
                  _changeRsvp(context, completer, RSVP.YES);
                },
              ),
              CupertinoActionSheetAction(
                child: Text(
                  CirclesLocalizations
                      .of(context)
                      .eventRsvpMaybe,
                  style: AppTheme.optionTextStyle,
                  textScaleFactor: 1,
                ),
                onPressed: () {
                  _changeRsvp(context, completer, RSVP.MAYBE);
                },
              ),
              CupertinoActionSheetAction(
                child: Text(
                  CirclesLocalizations
                      .of(context)
                      .eventRsvpNo,
                  style: AppTheme.optionTextStyle,
                  textScaleFactor: 1,
                ),
                onPressed: () {
                  _changeRsvp(context, completer, RSVP.NO);
                },
              ),
            ],
          ),
    );
  }

  void _changeRsvp(BuildContext context, Completer completer, RSVP rsvp) {
    Navigator.of(context).pop();
    // close the side when the user changes RSVP
    widget.sideOpenController.value = false;
    StoreProvider.of<AppState>(context).dispatch(RsvpAction(rsvp, completer));
  }

  _buildLogout() {
    return Visibility(
      visible: !widget.vm.canChangeRsvp,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.appMargin),
        child: Center(
          child: FlatButton(
            child: Text(
              CirclesLocalizations.of(context).eventLeave,
              style: AppTheme.buttonTextStyle,
            ),
            onPressed: () {
              _showLeaveChannelDialog(context);
            },
          ),
        ),
      ),
    );
  }

  _showLeaveChannelDialog(BuildContext context) {
    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: Text(CirclesLocalizations.of(context).channelLeaveAlertTitle),
        content:
        Text(CirclesLocalizations.of(context).channelLeaveAlertMessage),
        actions: <Widget>[
          PlatformDialogAction(
              child: Text(CirclesLocalizations.of(context).yes),
              onPressed: () {
                StoreProvider.of<AppState>(context).dispatch(
                  LeaveChannelAction(
                    widget.vm.groupId,
                    widget.vm.channel,
                    widget.vm.user.uid,
                  ),
                );
                widget.sideOpenController.value = false;
                Navigator.pop(context);
              }),
          PlatformDialogAction(
              child: Text(CirclesLocalizations.of(context).cancel),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }
}

class _TabBarView extends StatefulWidget {
  final TabController controller;
  final List<Widget> children;

  const _TabBarView({
    @required this.controller,
    @required this.children,
  });

  @override
  _TabBarViewState createState() => _TabBarViewState();
}

class _TabBarViewState extends State<_TabBarView> {
  int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.controller.index;
    widget.controller.addListener(() {
      setState(() {
        _currentIndex = widget.controller.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 200),
      child: widget.children[_currentIndex],
    );
  }
}

class _Style {
  static const headerSize = 256.0;
  static const iconSize = 36.0;
}
