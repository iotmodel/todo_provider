import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_provider/pages/todos_page.dart';
import 'package:todo_provider/providers/providers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TodoFilter>(
          create: (context) => TodoFilter(),
        ),
        ChangeNotifierProvider<TodoSearch>(
          create: (context) => TodoSearch(),
        ),
        ChangeNotifierProvider<TodoList>(
          create: (context) => TodoList(),
        ),
        ChangeNotifierProxyProvider<TodoList, ActiveTodoCount>(
          create: (context) => ActiveTodoCount(
            initialActiveTodoCount: context.read<TodoList>().state.todos.length,
          ),
          update: (
            context,
            todoList,
            activeTodoCount,
          ) =>
              activeTodoCount!..update(todoList),
        ),
        ChangeNotifierProxyProvider3<TodoFilter, TodoSearch, TodoList,
            FilteredTodos>(
          create: (context) => FilteredTodos(
            initialFilteredTodos: context.read<TodoList>().state.todos,
          ),
          update: (
            context,
            todoFilter,
            todoSearch,
            todoList,
            filteredTodos,
          ) =>
              filteredTodos!
                ..update(
                  todoFilter,
                  todoSearch,
                  todoList,
                ),
        )
      ],
      child: MaterialApp(
        title: 'TODOS',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.blue,
          useMaterial3: false,
        ),
        home: const TodosPage(),
      ),
    );
  }
}
