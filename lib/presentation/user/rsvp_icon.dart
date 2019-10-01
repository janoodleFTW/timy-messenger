import "package:circles_app/model/channel.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";

class RsvpIcon extends StatelessWidget {
  final RSVP rsvp;

  const RsvpIcon({
    @required this.rsvp,
  });

  @override
  Widget build(BuildContext context) {
    final height = 24.0, width = 24.0;
    switch (rsvp) {
      case RSVP.YES:
        return Image.asset(
          "assets/graphics/channel/rsvp/rsvp_yes.png",
          height: height,
          width: width,
        );
      case RSVP.MAYBE:
        return Image.asset(
          "assets/graphics/channel/rsvp/rsvp_maybe.png",
          height: height,
          width: width,
        );
      case RSVP.NO:
      case RSVP.UNSET:
      default:
        return Container();
    }
  }
}
