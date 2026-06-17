import 'package:smart_xdrip/domain/entities/glucose_event.dart';

import '../../domain/episode_detail_focus.dart';
import '../../domain/episode_detail_focus_match.dart';
import '../../domain/episode_detail_focus_policy.dart';

class EpisodeFocusSelection {
  final GlucoseEvent? event;
  final EpisodeDetailFocusMatch match;

  const EpisodeFocusSelection({
    required this.event,
    required this.match,
  });
}

class EpisodeFocusCalculator {
  final EpisodeDetailFocusPolicy policy;

  const EpisodeFocusCalculator({
    this.policy = const EpisodeDetailFocusPolicy(),
  });

  GlucoseEvent? latestOfType(
    List<GlucoseEvent> events, {
    required GlucoseEventType type,
  }) {
    final filtered = events.where((event) => event.type == type).toList()
      ..sort((a, b) => a.time.compareTo(b.time));
    return filtered.isEmpty ? null : filtered.last;
  }

  EpisodeFocusSelection select(
    List<GlucoseEvent> events, {
    required GlucoseEventType type,
    required DateTime anchorTime,
    EpisodeDetailFocus? focus,
  }) {
    final filtered = events.where((event) => event.type == type).toList()
      ..sort((a, b) => a.time.compareTo(b.time));
    if (focus != null) {
      return _focused(filtered, focus);
    }
    final beforeAnchor =
        filtered.where((event) => !event.time.isAfter(anchorTime)).toList();
    final latest = beforeAnchor.isNotEmpty
        ? beforeAnchor.last
        : latestOfType(filtered, type: type);
    return EpisodeFocusSelection(
      event: latest,
      match: const EpisodeDetailFocusMatch.latest(),
    );
  }

  EpisodeFocusSelection _focused(
    List<GlucoseEvent> events,
    EpisodeDetailFocus focus,
  ) {
    if (events.isEmpty) {
      return const EpisodeFocusSelection(
        event: null,
        match: EpisodeDetailFocusMatch.notFound(),
      );
    }
    for (final event in events) {
      if (event.time.isAtSameMomentAs(focus.eventTime)) {
        return EpisodeFocusSelection(
          event: event,
          match: const EpisodeDetailFocusMatch(
            kind: EpisodeDetailFocusMatchKind.exactTime,
            offset: Duration.zero,
            explicit: true,
          ),
        );
      }
    }
    final near =
        _nearestByStart(events, focus.eventTime, policy.exactTolerance);
    if (near != null) {
      return EpisodeFocusSelection(
        event: near.event,
        match: EpisodeDetailFocusMatch(
          kind: EpisodeDetailFocusMatchKind.nearTime,
          offset: near.offset,
          explicit: true,
        ),
      );
    }
    for (final event in events) {
      final end = event.endTime;
      if (end == null) continue;
      if (!focus.eventTime.isBefore(event.time) &&
          !focus.eventTime.isAfter(end)) {
        return EpisodeFocusSelection(
          event: event,
          match: EpisodeDetailFocusMatch(
            kind: EpisodeDetailFocusMatchKind.containsTime,
            offset: focus.eventTime.difference(event.time),
            explicit: true,
          ),
        );
      }
    }
    final nearest =
        _nearestByStart(events, focus.eventTime, policy.nearestTolerance);
    if (nearest != null) {
      return EpisodeFocusSelection(
        event: nearest.event,
        match: EpisodeDetailFocusMatch(
          kind: EpisodeDetailFocusMatchKind.nearTime,
          offset: nearest.offset,
          explicit: true,
        ),
      );
    }
    return const EpisodeFocusSelection(
      event: null,
      match: EpisodeDetailFocusMatch.notFound(),
    );
  }

  _NearestEvent? _nearestByStart(
    List<GlucoseEvent> events,
    DateTime target,
    Duration tolerance,
  ) {
    _NearestEvent? best;
    for (final event in events) {
      final offset = event.time.difference(target);
      final absOffset = offset.abs();
      if (absOffset > tolerance) continue;
      if (best == null || absOffset < best.offset.abs()) {
        best = _NearestEvent(event: event, offset: offset);
      }
    }
    return best;
  }
}

class _NearestEvent {
  final GlucoseEvent event;
  final Duration offset;

  const _NearestEvent({
    required this.event,
    required this.offset,
  });
}
