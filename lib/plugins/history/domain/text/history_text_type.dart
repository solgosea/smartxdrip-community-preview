enum HistoryTextTemplate {
  episodeCallout,
  episodeCalloutNoExtra,
  highEventDetail,
  highEventDetailDurationOnly,
  highEventDetailRateOnly,
  highEventDetailEmpty,
  lowEventDetail,
  lowEventDetailDurationOnly,
  lowEventDetailNocturnalOnly,
  lowEventDetailEmpty,
  recoveryDetail,
  stableWindowDetail,
  firstReadingDetail,
  highValueSuffix,
  riseValueSuffix,
  plainValueSuffix;

  String get key => 'history.$name.v1';
}
