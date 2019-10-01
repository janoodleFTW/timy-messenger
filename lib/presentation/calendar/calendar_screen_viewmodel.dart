import "package:built_collection/built_collection.dart";
import "package:built_value/built_value.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/model/channel.dart";
import "package:circles_app/presentation/calendar/calendar_item.dart";
import "package:redux/redux.dart";

// ignore: prefer_double_quotes
part 'calendar_screen_viewmodel.g.dart';

abstract class CalendarScreenViewModel
    implements Built<CalendarScreenViewModel, CalendarScreenViewModelBuilder> {
  BuiltList<CalendarItem> get calendar;

  /// Indicating a selected event. -1 if nothing is selected.
  int get selectedEventHeaderIndex;

  /// Index of header closes to now
  int get upcomingEventHeaderIndex;

  BuiltMap<int, int> get headerItemSizeMap;

  CalendarScreenViewModel._();

  factory CalendarScreenViewModel(
          [void Function(CalendarScreenViewModelBuilder) updates]) =
      _$CalendarScreenViewModel;

  static CalendarScreenViewModel fromStore(Store<AppState> store) {
    final nowFullDate = DateTime.now();
    final today = (DateTime(
      nowFullDate.year,
      nowFullDate.month,
      nowFullDate.day,
    ));
    final calendarItems = List<CalendarItem>();
    DateTime sectionDate = DateTime(
      1900,
      today.month,
      today.day,
    );

    var sectionItem;
    var headerItemCount = 0;
    var selectedEventHeaderIndex = -1;
    var upcomingEventHeaderIndex = -1;
    final headerItemMap = Map<int, int>();

    // Create CalendarHeaderItem and associated CalendarEntryItems
    store.state.userCalendar.forEach((calendarEntry) {
      // Group events by day
      final entryDate = DateTime(
        calendarEntry.eventDate.year,
        calendarEntry.eventDate.month,
        calendarEntry.eventDate.day,
      );

      // Add new header item for every day
      if (entryDate.isAfter(sectionDate)) {
        headerItemCount += 1;
        sectionDate = entryDate;

        // Check if we've found the most relevant item and mark it
        if (calendarEntry.eventDate.isAfter(today) && upcomingEventHeaderIndex == -1) {
          upcomingEventHeaderIndex = headerItemCount - 1;
        }

        // Add header
        sectionItem = CalendarHeaderItem(
          date: entryDate,
          isToday: today.isAtSameMomentAs(entryDate),
          isPast: upcomingEventHeaderIndex == -1
        );
        calendarItems.add(sectionItem);
      }

      // Add header to map and increment items count for header.
      headerItemMap.putIfAbsent(headerItemCount, () => 0);
      headerItemMap[headerItemCount] = headerItemMap[headerItemCount] + 1;

      // Check if event is selected and persist its index.
      final isSelected =
          store.state.channelState.selectedChannel == calendarEntry.channelId &&
              store.state.selectedGroupId == calendarEntry.groupId;

      if (isSelected) {
        selectedEventHeaderIndex = headerItemCount - 1;
      }

      // Add actual CalendarEntryItem
      calendarItems.add(CalendarEntryItem(
        date: calendarEntry.eventDate,
        groupName: calendarEntry.groupName,
        groupId: calendarEntry.groupId,
        eventName: calendarEntry.channelName,
        eventId: calendarEntry.channelId,
        rsvpStatus: RSVP.UNSET,
        isSelected: isSelected,
        isAllDay: !calendarEntry.hasStartTime,
        isPast: upcomingEventHeaderIndex == -1
      ));
    });

    return CalendarScreenViewModel(
      (viewModel) => viewModel
        ..calendar = ListBuilder(calendarItems)
        ..headerItemSizeMap = MapBuilder(headerItemMap)
        ..selectedEventHeaderIndex = selectedEventHeaderIndex
        ..upcomingEventHeaderIndex = upcomingEventHeaderIndex, 
    );
  }
}
