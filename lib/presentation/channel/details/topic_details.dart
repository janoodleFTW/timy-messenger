import "package:circles_app/circles_localization.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/channel/channel_actions.dart";
import "package:circles_app/model/channel.dart";
import "package:circles_app/presentation/channel/details/topic_details_viewmodel.dart";
import "package:circles_app/presentation/common/round_button.dart";
import "package:circles_app/presentation/user/user_item.dart";
import "package:circles_app/routes.dart";
import "package:circles_app/theme.dart";
import "package:flutter/material.dart";
import "package:flutter_platform_widgets/flutter_platform_widgets.dart";
import "package:flutter_redux/flutter_redux.dart";

class TopicDetails extends StatelessWidget {
  const TopicDetails({
    Key key,
    this.sideOpenController,
  }) : super(key: key);

  final ValueNotifier<bool> sideOpenController;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, TopicDetailsViewModel>(
      distinct: true,
      converter: TopicDetailsViewModel.fromStore,
      builder: (context, vm) {
        return _TopicDetailsWidget(
          vm: vm,
          sideOpenController: sideOpenController,
        );
      },
    );
  }
}

class _TopicDetailsWidget extends StatefulWidget {
  const _TopicDetailsWidget({
    Key key,
    this.vm,
    this.sideOpenController,
  }) : super(key: key);

  final TopicDetailsViewModel vm;
  final ValueNotifier<bool> sideOpenController;

  @override
  _TopicDetailsWidgetState createState() => _TopicDetailsWidgetState();
}

class _TopicDetailsWidgetState extends State<_TopicDetailsWidget>
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
      ],
    );
  }

  Container _buildBackground() {
    return Container(
      height: 256,
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
      height: 256,
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

  TabBar _buildTabBar() {
    return TabBar(
      controller: _tabController,
      tabs: <Widget>[
        _buildTab(CirclesLocalizations.of(context).topicDetails),
        _buildTab(CirclesLocalizations.of(context).topicMembers),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildVisibility(),
          _buildMembersCount(),
          Expanded(child: Container()),
          _buildLeaveChannelButton(),
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
                height: 36,
              ),
            ),
            Text(
              CirclesLocalizations.of(context).topicPrivate,
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
            height: 36,
          ),
        ),
        Text(
          CirclesLocalizations.of(context)
              .topicMembersCount(widget.vm.members.length.toString()),
          style: AppTheme.topicDetailsItemTextStyle,
        ),
      ],
    );
  }

  Padding _buildLeaveChannelButton() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.appMargin),
      child: Center(
        child: FlatButton(
          child: Text(
            CirclesLocalizations.of(context).topicLeave,
            style: AppTheme.buttonTextStyle,
          ),
          onPressed: () {
            _showLeaveChannelDialog(context);
          },
        ),
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
            isYou: widget.vm.userId == member.uid,
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(AppTheme.appMargin),
            child: RoundButton(
              text: CirclesLocalizations.of(context).channelInviteButton,
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
                    widget.vm.userId,
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

  /// Invite members is only visible if the channel is closed
  num _canInviteUsers() {
    if (widget.vm.channel.visibility == ChannelVisibility.CLOSED) {
      return 1;
    } else {
      return 0;
    }
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
