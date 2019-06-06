
class MemoAction{
  List showMemo;

  MemoAction(this.showMemo);
}

class CountAction{
  int count;

  CountAction(this.count);
}

class AddAction{
  dynamic ids = 0;
  dynamic months = '';
  dynamic types = '';
  dynamic amounts = '';

  AddAction(this.ids, this.months, this.types, this.amounts);
}