import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:redux/redux.dart';

import './middleware/localStorageMiddleware.dart';
import '../integration/dependencyInjection.dart';
import 'appReducer.dart';
import 'modules/base/appState.dart';

Future<Store<AppState>> createStore() async {
  List<void Function(Store<AppState>, dynamic, void Function(dynamic))>
      middlewares = List.empty(growable: true);
  AppState stateObj = AppState.initial();
  if (isAndroid || isiOS || isWeb) {
    try {
      ResultWithValue<AppState> stateResult =
          await getStorageService().loadAppState();
      if (stateResult.isSuccess) stateObj = stateResult.value;
    } catch (exception) {
      getLog().e(exception);
    }
    middlewares.add(LocalStorageMiddleware());
  }

  return Store(
    appReducer,
    initialState: stateObj,
    middleware: middlewares,
  );
}
