import 'package:flutter/material.dart';

class AgpChartStyle {
  final Color targetBand;
  final Color targetBandHighlight;
  final Color thresholdLine;
  final Color rangeGridLine;
  final Color targetBorder;
  final Color outerBandTop;
  final Color outerBandBottom;
  final Color outerBandStroke;
  final Color innerBandTop;
  final Color innerBandBottom;
  final Color innerBandStroke;
  final Color medianLine;
  final Color medianHalo;
  final Color gridLine;
  final Color axisLabel;
  final Color crosshair;
  final Color iqrBar;
  final Color readoutMedianText;
  final Color readoutIqrText;
  final Color readoutBackground;
  final Color readoutBorder;

  const AgpChartStyle({
    this.targetBand = const Color(0x0D6EE89E),
    this.targetBandHighlight = const Color(0x146EE89E),
    this.thresholdLine = const Color(0x4D6EE89E),
    this.rangeGridLine = const Color(0x596EE89E),
    this.targetBorder = const Color(0x806EE89E),
    this.outerBandTop = const Color(0x265DB8F0),
    this.outerBandBottom = const Color(0x1F5DB8F0),
    this.outerBandStroke = const Color(0x385DB8F0),
    this.innerBandTop = const Color(0x4D3FD0C8),
    this.innerBandBottom = const Color(0x423FD0C8),
    this.innerBandStroke = const Color(0x663FD0C8),
    this.medianLine = const Color(0xFF7CF0A8),
    this.medianHalo = const Color(0x4D0C1410),
    this.gridLine = const Color(0x336EE89E),
    this.axisLabel = const Color(0xFF7AB898),
    this.crosshair = const Color(0x80D6EDE3),
    this.iqrBar = const Color(0xD93FD0C8),
    this.readoutMedianText = const Color(0xFF7CF0A8),
    this.readoutIqrText = const Color(0xFF3FD0C8),
    this.readoutBackground = const Color(0xF00A0F0C),
    this.readoutBorder = const Color(0x476EE89E),
  });
}
