class MemoState{
 List name;
 dynamic id = 0;
 dynamic month = '';
 dynamic type = '';
 dynamic amount = '';
 dynamic isActive = false;
 //dynamic counting = 0;
 MemoState({this.id, this.month, this.type, this.amount, this.name, this.isActive});

 int counting = 0;
 int item_id = 0;
}