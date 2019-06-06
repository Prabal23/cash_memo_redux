import 'package:cash_memo/model.dart';
import 'package:cash_memo/thunk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'main.dart';

void main() => runApp(new NextPage());

class NextPage extends StatefulWidget {
  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: new NewPage(),
      );
  }
}

class NewPage extends StatefulWidget {
  @override
  _NewPageState createState() => new _NewPageState();
}

class _NewPageState extends State<NewPage>{

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
    return new Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyApp()),
            );
          },
        ),
        title: new Text("Cash Memo"),
      ),
      body: SingleChildScrollView(
        child: new Center(
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: new Column(
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
          ),
        ),
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
            //leading: Text('${d.id}'),
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
    // _editItemlist(d, _currentMonth1, item_type, item_cost);
    // d.isActive = false;
    int exp = int.parse(item_cost);
    int total = cc;
    int allTotal = 0;
    int saved_money = int.parse(saved_cost);
    int add_cost = total - saved_money;
    allTotal = add_cost + exp;
    //_addTotal(allTotal);
    setState(() {
      _addTotal(allTotal);
    });
    // Toast.show("${exp} ${total} ${prev_cost} ${add_cost} ${allTotal}", context,
    //       backgroundColor: Colors.grey,
    //       textColor: Colors.black);
  }

  void _submitDelete(d){
    _deleteItem(d);
    saved_cost = d.amount;
    _currentMonth1 = d.month;
    cc = store.state.counting;
    costing = int.parse(saved_cost);
    allDTotal = cc - costing;
    _addTotal(allDTotal);
    // setState(() {
    //   _deleteItem(d);
    //   _addTotal(allDTotal);
    // });
    // Toast.show("${saved_cost} ${cc} ${costing} ${allDTotal}", context,
    // duration:10,
    //       backgroundColor: Colors.grey,
    // textColor: Colors.black);
  }

  void _addItemlist(int id, String month, String title_type, String title_cost){
    store.dispatch(addItemlist(id, month, title_type, title_cost));
  }

  void _addItemlist1(l1, String month, String title_type, String title_cost){
    store.dispatch(addItemlist1(l1, month, title_type, title_cost));
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

  void _addID(int item_id){
    store.dispatch(addID(item_id));
  }
}