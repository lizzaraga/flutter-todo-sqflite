import 'package:flutter/material.dart';
import 'package:flutter_vs/data/models/Todo.dart';
import 'package:flutter_vs/data/notifiers/TodosNotifier.dart';
import 'package:provider/provider.dart';


// class TodoScreen extends StatefulWidget {
//   @override
//   _TodoScreenState createState() => _TodoScreenState();
// }

class TodoScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AddTodoWidget(onAddTodo: (todo) => onAddTodo(context, todo)),
            TodoListViewWidget()
          ],
        ),
      ),
    );
  }

  onAddTodo(BuildContext context, Todo todo){
    todo.id = DateTime.now().millisecondsSinceEpoch;
    Provider.of<TodosNotifier>(context).createTodo(todo);
  }
}

class AddTodoWidget extends StatefulWidget {
  final Function(Todo) onAddTodo;
  AddTodoWidget({
    Key key, @required this.onAddTodo,
  }) : super(key: key);

  @override
  _AddTodoWidgetState createState() => _AddTodoWidgetState();
}

class _AddTodoWidgetState extends State<AddTodoWidget> {
  String _todoTitle = "";
  var _todoTextFieldCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Theme.of(context).errorColor,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
           horizontal: 8, vertical: 10
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Color(0x22000000)
              // border: Border.all(
              //   width: 1.5,
              //   color: Color(0x66000000)
              // )
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: TextField(
                      cursorColor: Color(0x22FFFFFF),
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xBBFFFFFF)
                      ),
                      onSubmitted: (_){onSubmitted();},
                      onChanged: (text){_todoTitle = text;},
                      controller: _todoTextFieldCtrl,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "New Todo",
                        hintStyle: TextStyle(
                          color: Color(0x99FFFFFF)
                        )
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onSubmitted,
                  icon: Icon(
                    Icons.add,
                    color: Color(0xBBFFFFFF),
                  ),
                )
              ],
            ),
          ),
        )
      ),
    );
  }

  void onSubmitted() {
    if(_todoTitle.trim().isNotEmpty){
      _todoTextFieldCtrl.clear();
      widget.onAddTodo(Todo(title: _todoTitle));
      _todoTitle = "";
    }
    else _todoTextFieldCtrl.clear();
  }
}

class TodoListViewWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<TodosNotifier>(
      builder: (context, todos, child){
        return ListView.builder(
          shrinkWrap: true,
          itemCount: todos.items.length,
          itemBuilder: (context, index){
            final item = todos.items[index];
            return TodoWidget(key: Key(item.id.toString()),todo: item, onDoneTodo: (todo){
              todo.done = true;
              onDoneTodo(context, todo);
            });
          }
        );
      },
    );
  }

  onDoneTodo(BuildContext context, Todo todo) {
     Provider.of<TodosNotifier>(context).updateTodo(todo);
  }
}
class TodoWidget extends StatefulWidget {
  final Todo todo;
  final Function(Todo) onDoneTodo;

  const TodoWidget({Key key, @required this.todo, @required this.onDoneTodo}) : super(key: key);

  @override
  _TodoWidgetState createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  bool _isCheck = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isCheck = widget.todo.done;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      //margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 8),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Text(widget.todo.title, maxLines: 2, overflow: TextOverflow.ellipsis,),
          ),
          Checkbox(value: _isCheck, onChanged: (value){
            setState(() {
              _isCheck = value;
            });
            
            Future.delayed(Duration(milliseconds: 500), () => {widget.onDoneTodo(widget.todo)});
          })
        ],
      ),
    );
  }
}