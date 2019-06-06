import 'package:cash_memo/model.dart';
import 'package:cash_memo/action.dart';

MemoState reducer(MemoState state, dynamic action) {
  // if (action is AddAction) {
  //   return MemoState(name: [] ..add(action.types));
  // }

  if (action is MemoAction) {
    return MemoState(name: [] ..addAll(action.showMemo));
  }

  // if (action is CountAction) {
  //   return MemoState(counting: action.count);
  // }
  return state;
}