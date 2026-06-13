import 'agp_chart_data.dart';

class AgpChartScrubState {
  final bool inspecting;
  final AgpScrubSample? sample;

  const AgpChartScrubState({
    this.inspecting = false,
    this.sample,
  });

  static const idle = AgpChartScrubState();

  AgpChartScrubState inspect(AgpScrubSample sample) {
    return AgpChartScrubState(inspecting: true, sample: sample);
  }
}
