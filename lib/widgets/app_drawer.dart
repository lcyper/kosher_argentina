import 'package:flutter/material.dart';

Drawer appDrawer() {
  List<String> menuOptions = [
    'Supervisaciones',
    'Donaciones',
    'Configuracion',
    'Repostar Bug',
    'Contacto'
  ];
  return Drawer(
    // backgroundColor: Colors.orange,
    child: ListView(
      children: [
        const DrawerHeader(
          child: Center(
            child: Text(
              'Menu',
              style: TextStyle(fontSize: 32),
            ),
          ),
        ),
        ...menuOptions.map(
          (option) => ListTile(
            title: Text(option),
            onTap: () {
              // TODO: value, onTopNavigatorPageName
            },
          ),
        )
      ],
    ),
  );
}
