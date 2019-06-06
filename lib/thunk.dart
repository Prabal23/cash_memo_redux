import 'package:cash_memo/model.dart';
import 'package:cash_memo/action.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction<MemoState> addItemlist(int ids, String months, String type1, String cost1) => (Store<MemoState> store) async{
  store.state.name.add(MemoState(id: ids, month: months, type: type1, amount: cost1, isActive: false));
  // store.dispatch(
  //   new AddAction(ids, months, type1, cost1)
  // );
  store.dispatch(
    new MemoAction(
      store.state.name
    )
  );
};

ThunkAction<MemoState> addItemlist1(l1, String months, String type1, String cost1) => (Store<MemoState> store) async{
  int _id = l1._id;
  _id++;
  store.state.name.add(MemoState(id: _id, month: months, type: type1, amount: cost1, isActive: false));
  
  store.dispatch(
    new MemoAction(
      store.state.name
    )
  );
};

ThunkAction<MemoState> editItemlist(d, String months, String type, String cost) => (Store<MemoState> store) async{
  for(var data in store.state.name){
    if(data.id == d.id){
      d.month = months;
      d.type = type;
      d.amount = cost;
    }
  }
  
  store.dispatch(
    new MemoAction(
      store.state.name
    )
  );
};

ThunkAction<MemoState> deleteItemById(d) => (Store<MemoState> store) async{
  for(var data in store.state.name){
    if(data.id == d.id){
      store.state.name.remove(data);
    }
  }
  
  store.dispatch(
    new MemoAction(
      store.state.name
    )
  );
};

ThunkAction<MemoState> addTotal(int money) => (Store<MemoState> store) async{
  store.state.counting = money;
  // var m = store.state.counting;
  // m  = money;
  //store.dispatch(new CountAction(money));
};

ThunkAction<MemoState> addID(int id) => (Store<MemoState> store) async{
  //id++;
  store.state.item_id = id;
};