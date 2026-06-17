import 'dart:math' as math;

import 'package:smart_xdrip/domain/entities/glucose_event.dart';

import '../../domain/episode_similar_chart_point.dart';
import '../../domain/episode_similar_chart_selection.dart';
import '../../domain/episode_similar_match.dart';
import '../../domain/sections/episode_similar_section.dart';

class EpisodeSimilarCalculator {
  const EpisodeSimilarCalculator();

  EpisodeSimilarSection calculate({
    required GlucoseEvent current,
    required List<GlucoseEvent> events,
    required bool high,
    int windowDays = 30,
    String? title,
  }) {
    final cutoff = current.time.subtract(Duration(days: windowDays));
    final candidates = events
        .where((event) =>
            event.type == current.type &&
            !identical(event, current) &&
            event.time != current.time &&
            !event.time.isBefore(cutoff) &&
            !event.time.isAfter(current.time.add(Duration(days: windowDays))))
        .toList();
    final matches = candidates
        .map((event) => _match(current: current, candidate: event, high: high))
        .toList()
      ..sort((a, b) => b.score.compareTo(a.score));
    final selected = matches.isEmpty ? null : matches.first;
    final selectedId = selected == null ? null : _idFor(selected.event);
    final currentPoint = _point(
      id: 'current',
      event: current,
      high: high,
      score: 1,
      label: EpisodeSimilarMatchLabel.verySimilar,
      isCurrent: true,
      isSelected: false,
    );
    final points = [
      currentPoint,
      for (final match in matches)
        _point(
          id: _idFor(match.event),
          event: match.event,
          high: high,
          score: match.score,
          label: match.label,
          isCurrent: false,
          isSelected: _idFor(match.event) == selectedId,
        ),
    ];

    return EpisodeSimilarSection(
      title: title ?? 'Similar Episodes (Past $windowDays Days)',
      windowDays: windowDays,
      currentPoint: currentPoint,
      points: points,
      selected: selected == null
          ? null
          : EpisodeSimilarChartSelection(
              match: selected,
              reason: _reasonFor(current, selected),
            ),
    );
  }

  EpisodeSimilarMatch _match({
    required GlucoseEvent current,
    required GlucoseEvent candidate,
    required bool high,
  }) {
    final timeScore = _timeScore(current.time, candidate.time);
    final valueScore = _distanceScore(
      _value(current),
      _value(candidate),
      high ? 4.0 : 2.0,
    );
    final durationScore = _distanceScore(
      current.durationMinutes.toDouble(),
      candidate.durationMinutes.toDouble(),
      120,
    );
    final recoveryScore =
        (current.endTime != null) == (candidate.endTime != null) ? 1.0 : 0.35;
    final driverScore = _driverLikeScore(current, candidate);
    final score = (timeScore * 0.35) +
        (valueScore * 0.25) +
        (durationScore * 0.20) +
        (recoveryScore * 0.10) +
        (driverScore * 0.10);
    final duration = math.max(candidate.durationMinutes, 0);
    return EpisodeSimilarMatch(
      event: candidate,
      score: score.clamp(0.0, 1.0),
      label: _labelFor(score),
      valueMmol: _value(candidate),
      durationMinutes: duration,
      recoveryVisible: candidate.endTime != null,
      slowOrUnknownRecovery: candidate.endTime == null || duration >= 90,
    );
  }

  EpisodeSimilarChartPoint _point({
    required String id,
    required GlucoseEvent event,
    required bool high,
    required double score,
    required EpisodeSimilarMatchLabel label,
    required bool isCurrent,
    required bool isSelected,
  }) {
    final duration = math.max(event.durationMinutes, 0);
    return EpisodeSimilarChartPoint(
      id: id,
      time: event.time,
      valueMmol: _value(event),
      durationMinutes: duration,
      score: score,
      label: label,
      isCurrent: isCurrent,
      isSelected: isSelected,
      slowOrUnknownRecovery: event.endTime == null || duration >= 90,
    );
  }

  double _value(GlucoseEvent event) => event.peakOrNadir ?? event.value;

  double _timeScore(DateTime a, DateTime b) {
    final aMinutes = a.hour * 60 + a.minute;
    final bMinutes = b.hour * 60 + b.minute;
    final diff = (aMinutes - bMinutes).abs();
    final circular = math.min(diff, 1440 - diff);
    return (1 - (circular / 720)).clamp(0.0, 1.0);
  }

  double _distanceScore(double a, double b, double scale) {
    if (scale <= 0) return 0;
    return (1 - ((a - b).abs() / scale)).clamp(0.0, 1.0);
  }

  double _driverLikeScore(GlucoseEvent current, GlucoseEvent candidate) {
    var score = 0.0;
    if ((current.ratePerMin ?? 0).sign == (candidate.ratePerMin ?? 0).sign) {
      score += 0.45;
    }
    if (current.isNocturnal == candidate.isNocturnal) score += 0.35;
    if ((current.areaOutOfRange == null) ==
        (candidate.areaOutOfRange == null)) {
      score += 0.20;
    }
    return score.clamp(0.0, 1.0);
  }

  EpisodeSimilarMatchLabel _labelFor(double score) {
    if (score >= 0.78) return EpisodeSimilarMatchLabel.verySimilar;
    if (score >= 0.55) return EpisodeSimilarMatchLabel.similar;
    return EpisodeSimilarMatchLabel.looseMatch;
  }

  String _idFor(GlucoseEvent event) => event.time.toIso8601String();

  String _reasonFor(GlucoseEvent current, EpisodeSimilarMatch selected) {
    final sameHour = current.time.hour == selected.event.time.hour;
    final durationDiff =
        (current.durationMinutes - selected.durationMinutes).abs();
    final valueDiff = (_value(current) - selected.valueMmol).abs();
    if (sameHour && durationDiff <= 20) {
      return 'Same time window and similar duration.';
    }
    if (sameHour && valueDiff <= 1.0) {
      return 'Same time window and similar glucose level.';
    }
    if (durationDiff <= 20 && valueDiff <= 1.0) {
      return 'Similar duration and glucose level.';
    }
    return 'Closest match by time, glucose level, duration, and recovery visibility.';
  }
}
