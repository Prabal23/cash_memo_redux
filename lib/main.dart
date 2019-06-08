import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:cash_memo/model.dart';
import 'package:cash_memo/thunk.dart';
import 'package:cash_memo/action.dart';
import 'package:cash_memo/reducer.dart';
import 'package:toast/toast.dart';
import 'package:cash_memo/next_page.dart';

void main() => runApp(new MyApp());

final store = new Store<MemoState>(
  reducer,
  initialState: new MemoState(
    name: []
  ),  
  middleware: [thunkMiddleware]
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return StoreProvider<MemoState>(
      store: store,
      child: new MaterialApp(
        title: 'Cash Memo',
        theme: new ThemeData(
          buttonTheme: ButtonThemeData(
            textTheme: ButtonTextTheme.primary
          ),
          primarySwatch: Colors.blue,
          // secondaryHeaderColor: Colors.grey[600],
          // buttonColor: Colors.black,
          // primarySwatch: Colors.grey,
          // brightness: Brightness.light,
          // accentColor: Colors.purpleAccent,
          canvasColor: Colors.white
        ),
        home: MyHomePage()
      ),
    );
  }
}
// final store = new Store<MemoState>(
//   reducer,
//   initialState: new MemoState(
//     name: []
//   ),  
//   middleware: [thunkMiddleware]
// );

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return StoreProvider<MemoState>(
//       store: store,
//       child: new MaterialApp(
//         home: new MyHomePage(),
//       ),
//     );
//   }
// }

class MyHomePage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cash Memo")
      ),
      // accessing the store via the _ViewModel class
      body: SingleChildScrollView(
        child: new Center(
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AddtoList(),
                //DisplayList()
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class AddtoList extends StatefulWidget {
 
 @override
  _AddtoListState createState() => _AddtoListState();
}

class _AddtoListState extends State<AddtoList>{
  List _months =
  ["January", "February", "March", "April", "May", "June",
  "July", "August", "September", "October", "November", "December"];
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentMonth;
  //int cc = 0, allDTotal = 0, costing = 0;
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController price1 = TextEditingController();

  String item_type = "";
  String item_cost = "";

  @override
    void initState() {
      _dropDownMenuItems = getDropDownMenuItems();
      _currentMonth = _dropDownMenuItems[0].value;
      super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String month in _months) {
      items.add(new DropdownMenuItem(
          value: month,
          child: new Text(month)
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: <Widget>[
              Text("Select Month : ", style: TextStyle(fontSize: 15),),
              DropdownButton(
                style: TextStyle(fontSize: 15, color: Colors.black),
                value: _currentMonth,
                items: _dropDownMenuItems,
                onChanged: (String value){
                  setState(() {
                    _currentMonth = value; 
                  });
                  // Toast.show(_currentMonth, context,
                  // duration: 1,
                  // backgroundColor: Colors.grey,
                  // textColor: Colors.black);
                },
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Text("Expense Type : ", style: TextStyle(color: Colors.black54, fontSize: 13.5),),
              Container(
                width: 240,
                child: TextField(
                  style: TextStyle(fontSize: 13.5, color: Colors.black54),
                  controller: controller1,
                  decoration: InputDecoration(
                    hintText: "Enter Type"
                  ),
                  onChanged: (value) {
                    item_type = value;
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10,),
        Container(
          child: Row(
            children: <Widget>[
              Text("Expense Amount : ", style: TextStyle(color: Colors.black54, fontSize: 13.5),),
              Container(
                width: 220,
                child: TextField(
                  style: TextStyle(fontSize: 13.5, color: Colors.black54),
                  keyboardType: TextInputType.number,
                  controller: price1,
                  decoration: InputDecoration(
                    hintText: "Enter Price"
                  ),
                  onChanged: (value) {
                    item_cost= value;
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed : (){
                  _submitAdd();
                },
                color: Colors.blue,
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 10),
              RaisedButton(
                onPressed : (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NextPage()),
                  );
                },
                color: Colors.blue,
                child: Text(
                  "Report",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        DisplayList()
        // SizedBox(height: 10,),
        // Text("Total Balance : ${store.state.counting}/-"),
        // Divider(color: Colors.grey),
        // StoreConnector<MemoState, List>(
        //   converter: (store) => store.state.name,
        //   builder: (context, items) => Column(children: _someLists(store.state.name)),
        // )
      ],
    );
  }

  void _submitAdd(){
    String amount = item_cost;
    int money = int.parse(amount);
    int cost = store.state.counting + money; 
    int id = store.state.item_id;
    id++;
    setState((){
      _addItemlist(id, _currentMonth, item_type, item_cost);
      _addTotal(cost);
      _addID(id);
    });
    // _addItemlist(count, _currentMonth, item_type, item_cost);
    // _addTotal(cost);
    // _addID(count);
    controller1.text = "";
    price1.text = "";
    _currentMonth = _dropDownMenuItems[0].value;
    FocusScope.of(context).requestFocus(new FocusNode());
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => NextPage()),
    // );
  }

  void _addItemlist(int id, String month, String title_type, String title_cost){
    store.dispatch(addItemlist(id, month, title_type, title_cost));
  }

  void _addTotal(int money){
    store.dispatch(addTotal(money));
  }

  void _addID(int item_id){
    store.dispatch(addID(item_id));
  }
}

class DisplayList extends StatefulWidget {
 @override
  _DisplayListState createState() => _DisplayListState();
}

class _DisplayListState extends State<DisplayList>{

  List _months =
  ["January", "February", "March", "April", "May", "June",
  "July", "August", "September", "October", "November", "December"];
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentMonth, _currentMonth1, saved_cost = "";
  int cc = 0, allDTotal = 0, costing = 0;
  final TextEditingController controller = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController price1 = TextEditingController();

  String item_type = "";
  String item_cost = "";
  bool activity = true;

  @override
    void initState() {
      _dropDownMenuItems = getDropDownMenuItems();
      _currentMonth = _dropDownMenuItems[0].value;
      super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String month in _months) {
      items.add(new DropdownMenuItem(
          value: month,
          child: new Text(month)
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[ 
          SizedBox(height: 10,),
          Text("Total Balance : ${store.state.counting}/-"),
          Divider(color: Colors.grey),
          StoreConnector<MemoState, List>(
            converter: (store) => store.state.name,
            builder: (context, items) => Column(children: _someLists(store.state.name)),
          )
        ],
      ),
    );
  }

  List<Widget> _someLists(storeData) {
    List<Widget> list = [];
    for (var d in storeData) {
      list.add(
        Container(
          margin: EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(width: 1.0, color: Colors.black26),
              bottom: BorderSide(width: 1.0, color: Colors.black26),
              right: BorderSide(width: 1.0, color: Colors.black26),
              left: BorderSide(width: 1.0, color: Colors.black26),
            ),
            color: Colors.white, 
          ),
          child: ListTile(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NextPage()),
              );
            },
            onLongPress: (){
              setState((){
                d.isActive = true;
              });
              if (d != null) {
                item_type = d.type;
                controller.text = d.type;
                item_cost = d.amount;
                price.text = d.amount;
                saved_cost = d.amount;
                _currentMonth1 = d.month;
                cc = store.state.counting;
                costing = int.parse(saved_cost);
                allDTotal = cc - costing;
              }
            },
            leading: Text('${d.id}'),
            title:Container(
              child: Container(
                child: d.isActive == false ? Container(child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                  Text("Month : " + d.month, maxLines: 1, style: TextStyle(fontSize: 15, color: Colors.black),),
                  SizedBox(height: 5,),
                  Text("Type : "+d.type, maxLines: 1, style: TextStyle(fontSize: 14, color: Colors.black54),),
                  SizedBox(height: 5,),
                ],),) :
                Container(child: new Column(children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: <Widget>[
                        Text("Month : ", style: TextStyle(fontSize: 15),),
                        DropdownButton(
                          value: _currentMonth1,
                          items: _dropDownMenuItems,
                          onChanged: (String value){
                            setState(() {
                              _currentMonth1 = value; 
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Text("Type : ", style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic, color: Colors.black54)),
                        Container(
                          width: 120,
                          child: TextField(
                            style: TextStyle(fontSize: 15, color: Colors.black54, fontStyle: FontStyle.italic),
                            controller: controller,
                            decoration: InputDecoration(
                              hintText: "Enter Type"
                            ),
                            onChanged: (value) {
                              item_type = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],),) 
              ),
            ),
            subtitle: d.isActive == false ? Text("Amount : "+d.amount + "/-", maxLines: 2,) :
            Container(child: Row(children: <Widget>[
              Text("Amount : ", style: TextStyle(fontSize: 15),),
              Container(
                width: 120,
                child: TextField(
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                  controller: price,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Enter Body"
                  ),
                  onChanged: (value) {
                    item_cost = value;
                  },
                ),
              ),
            ],),), 
            dense: true,
            isThreeLine: true,
            trailing: Column(
              children: <Widget>[
                d.isActive == false ? 
                IconButton(icon: Icon(Icons.delete), onPressed: (){
                  _submitDelete(d);
                },) :
                IconButton(icon: Icon(Icons.edit), onPressed: (){
                  _submitEdit(d);
                },) 
              ],
            ),
          ),
        ),
      );
    }

    return list;
  }

  void _submitEdit(d){
    setState(() {
      _editItemlist(d, _currentMonth1, item_type, item_cost);
      d.isActive = false;
    });
    //_editItemlist(d, _currentMonth1, item_type, item_cost);
    //d.isActive = false;
    int exp = int.parse(item_cost);
    int total = cc;
    int allTotal = 0;
    int saved_money = int.parse(saved_cost);
    int add_cost = total - saved_money;
    allTotal = add_cost + exp;
    //_addTotal(allTotal);
    FocusScope.of(context).requestFocus(new FocusNode());
    setState(() {
      _addTotal(allTotal);
    });
    // Toast.show("${exp} ${total} ${prev_cost} ${add_cost} ${allTotal}", context,
    //       backgroundColor: Colors.grey,
    //       textColor: Colors.black);
  }

  void _submitDelete(d){
    
    saved_cost = d.amount;
    _currentMonth1 = d.month;
    cc = store.state.counting;
    costing = int.parse(saved_cost);
    allDTotal = cc - costing;
    // _deleteItem(d);
    // _addTotal(allDTotal);
    FocusScope.of(context).requestFocus(new FocusNode());
    setState(() {
      _deleteItem(d);
      _addTotal(allDTotal);
    });
    // Toast.show("${saved_cost} ${cc} ${costing} ${allDTotal}", context,
    // duration:10,
    //       backgroundColor: Colors.grey,
    // textColor: Colors.black);
  }

  void _editItemlist(d, String months, String title_type, String title_cost){
    store.dispatch(editItemlist(d, months, title_type, title_cost));
  }

  void _deleteItem(d){
    store.dispatch(deleteItemById(d));
  }

  void _addTotal(int money){
    store.dispatch(addTotal(money));
  }
}

