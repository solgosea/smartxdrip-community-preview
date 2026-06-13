import 'package:flutter/foundation.dart';

import 'ios_bg_refresh_status.dart';

class IosBgRefreshStatusStore extends ChangeNotifier {
  IosBgRefreshStatus _status;

  IosBgRefreshStatusStore({
    IosBgRefreshStatus initialStatus =
        const IosBgRefreshStatus.previewDisabled(),
  }) : _status = initialStatus;

  IosBgRefreshStatus get status => _status;

  void update(IosBgRefreshStatus status) {
    _status = status;
    notifyListeners();
  }
}
