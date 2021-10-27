import 'package:flutter/material.dart';
class ErrorPage extends StatelessWidget{
    const ErrorPage({Key? key, String? error}) : _error=error, super(key: key);
    final _error;
    @override
    Widget build(BuildContext context) {
        return Center(
                child: Text('Error!!! $_error'),
        );
    }
}
