import 'package:app_vendas/views/widgets/HeaderContainer.dart';
import 'package:flutter/material.dart';

class Mensagens extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: HeaderContainer(
        child: Center(
            child: Text("Mensagens")
        ),
      ),
    );
  }
}
