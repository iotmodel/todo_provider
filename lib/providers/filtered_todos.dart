// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:todo_provider/models/todo_model.dart';
import 'package:todo_provider/providers/todo_filter.dart';
import 'package:todo_provider/providers/todo_list.dart';
import 'package:todo_provider/providers/todo_search.dart';

class FilteredTodosState extends Equatable {
  final List<Todo> filteredTodos;
  const FilteredTodosState({
    required this.filteredTodos,
  });

  factory FilteredTodosState.initial() {
    return const FilteredTodosState(filteredTodos: []);
  }

  @override
  List<Object> get props => [filteredTodos];

  @override
  bool get stringify => true;

  FilteredTodosState copyWith({
    List<Todo>? filteredTodos,
  }) {
    return FilteredTodosState(
      filteredTodos: filteredTodos ?? this.filteredTodos,
    );
  }
}

class FilteredTodos with ChangeNotifier {
  late FilteredTodosState _state;
  final List<Todo> initialFilteredTodos;
  FilteredTodos({
    required this.initialFilteredTodos,
  }) {
    _state = FilteredTodosState(filteredTodos: initialFilteredTodos);
  }
  // FilteredTodosState _state = FilteredTodosState.initial();
  FilteredTodosState get state => _state;

  void update(
    TodoFilter todoFilter,
    TodoSearch todoSearch,
    TodoList todoList,
  ) {
    List<Todo> filteredTodos;

    switch (todoFilter.steate.filter) {
      case Filter.active:
        filteredTodos =
            todoList.state.todos.where((todo) => !todo.completed).toList();
        break;
      case Filter.completed:
        filteredTodos =
            todoList.state.todos.where((todo) => todo.completed).toList();
        break;
      case Filter.all:
      default:
        filteredTodos = todoList.state.todos;
        break;
    }

    if (todoSearch.state.searchTerm.isNotEmpty) {
      filteredTodos = filteredTodos
          .where((todo) =>
              todo.desc.toLowerCase().contains(todoSearch.state.searchTerm))
          .toList();
    }

    _state = _state.copyWith(filteredTodos: filteredTodos);
    notifyListeners();
  }
}
