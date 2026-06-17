import '../episode_similar_chart_point.dart';
import '../episode_similar_chart_selection.dart';

class EpisodeSimilarSection {
  final String title;
  final int windowDays;
  final EpisodeSimilarChartPoint? currentPoint;
  final List<EpisodeSimilarChartPoint> points;
  final EpisodeSimilarChartSelection? selected;

  const EpisodeSimilarSection({
    required this.title,
    required this.windowDays,
    required this.currentPoint,
    required this.points,
    required this.selected,
  });

  bool get hasMatches => currentPoint != null && selected != null;
}
