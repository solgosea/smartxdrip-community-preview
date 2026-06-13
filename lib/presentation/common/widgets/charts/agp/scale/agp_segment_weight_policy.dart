class AgpSegmentWeightPolicy {
  final double lowerToLow;
  final double lowToCenter;
  final double centerToHigh;
  final double highToUpper;

  const AgpSegmentWeightPolicy({
    required this.lowerToLow,
    required this.lowToCenter,
    required this.centerToHigh,
    required this.highToUpper,
  });

  const AgpSegmentWeightPolicy.detail()
      : lowerToLow = 0.72,
        lowToCenter = 1.22,
        centerToHigh = 1.22,
        highToUpper = 0.72;
}
