// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, file_names

import 'package:flutter/material.dart';

Widget MyCustomTextField(
    {context,
    title,
    controller,
    hinttext,
    validator,
    bordercolor,
    textcolor,
    obscure,
    suffixIcon,
    istextarea}) {
  return TextFormField(
    controller: controller,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    style: TextStyle(color: Colors.black),
    validator: validator,
    keyboardType: TextInputType.text,
    autofocus: false,
    obscureText: obscure ?? false,
    maxLines: istextarea == true ? 5 : 1,
    decoration: InputDecoration(
      suffixIcon: suffixIcon,
      hintText: '$hinttext',
      labelStyle: TextStyle(color: textcolor),
      hintStyle: TextStyle(color: textcolor),
      errorStyle: TextStyle(color: textcolor),
      labelText: '$title',
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: bordercolor,
          width: 1,
        ),
      ),
      focusColor: bordercolor,
      fillColor: bordercolor,
      hoverColor: bordercolor,
      disabledBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: bordercolor, width: 1, style: BorderStyle.solid),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: bordercolor,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: bordercolor,
          width: 1,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: bordercolor,
          width: 1,
        ),
      ),
    ),
  );
}

Widget MyCustomTextField2(
    {context, title, controller, hinttext, bordercolor, textcolor, validator}) {
  return TextFormField(
    controller: controller,
    validator: validator,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    style: TextStyle(color: textcolor),
    decoration: InputDecoration(
      hintText: '$hinttext',
      labelStyle: TextStyle(color: textcolor),
      hintStyle: TextStyle(color: textcolor),
      labelText: '$title',
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: bordercolor,
          width: 1,
        ),
      ),
      focusColor: bordercolor,
      fillColor: bordercolor,
      hoverColor: bordercolor,
      disabledBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: bordercolor, width: 1, style: BorderStyle.solid),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: bordercolor,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: bordercolor,
          width: 1,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: bordercolor,
          width: 1,
        ),
      ),
    ),
  );
}
