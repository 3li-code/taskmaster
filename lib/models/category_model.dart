import 'package:flutter/material.dart';

class TaskCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  const TaskCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon.codePoint,
      'color': color.value,
    };
  }

  factory TaskCategory.fromMap(Map<String, dynamic> map) {
    return TaskCategory(
      id: map['id'] as String,
      name: map['name'] as String,
      icon: IconData(map['icon'] as int, fontFamily: 'MaterialIcons'),
      color: Color(map['color'] as int),
    );
  }
}

// Predefined categories
class Categories {
  static const work = TaskCategory(
    id: 'work',
    name: 'Work',
    icon: Icons.work_rounded,
    color: Color(0xFF6C63FF),
  );

  static const personal = TaskCategory(
    id: 'personal',
    name: 'Personal',
    icon: Icons.person_rounded,
    color: Color(0xFFFF6B9D),
  );

  static const shopping = TaskCategory(
    id: 'shopping',
    name: 'Shopping',
    icon: Icons.shopping_cart_rounded,
    color: Color(0xFFFFA726),
  );

  static const health = TaskCategory(
    id: 'health',
    name: 'Health',
    icon: Icons.favorite_rounded,
    color: Color(0xFFEF5350),
  );

  static const study = TaskCategory(
    id: 'study',
    name: 'Study',
    icon: Icons.school_rounded,
    color: Color(0xFF42A5F5),
  );

  static const home = TaskCategory(
    id: 'home',
    name: 'Home',
    icon: Icons.home_rounded,
    color: Color(0xFF66BB6A),
  );

  static const other = TaskCategory(
    id: 'other',
    name: 'Other',
    icon: Icons.more_horiz_rounded,
    color: Color(0xFF9E9E9E),
  );

  static List<TaskCategory> get all => [
    work,
    personal,
    shopping,
    health,
    study,
    home,
    other,
  ];

  static TaskCategory getById(String id) {
    return all.firstWhere((category) => category.id == id, orElse: () => other);
  }
}
