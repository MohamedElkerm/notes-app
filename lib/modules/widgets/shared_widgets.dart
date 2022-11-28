import 'package:firebase/themes/colors.dart';
import 'package:flutter/material.dart';

void navigateTo(context, widget) => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
);

void navigateToAndReplacement(context, widget) => Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
);

void printFullText(text) {
  final pattern = RegExp('.{1.800}');
  pattern.allMatches(text).forEach((element) {
    print(element.group(0));
  });
}

Widget defaultTextFormField({initValue,required validator,function,required controller ,required label, hintText,required preFixIcon}){
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(
        5.0,
      ),
      border: Border.all(
        color:AppColors().primary,
      ),
    ),
    child: TextFormField(
      initialValue: initValue,
      validator: validator,
      onFieldSubmitted: (value){
        print(value);
      },
      controller: controller,
      decoration: InputDecoration(
        border: InputBorder.none,
        label: Text(label),
        hintText: hintText,
        prefixIcon: Icon(preFixIcon),
      ),
    ),
  );
}

Widget note({required img , required title , required body, function,dissFunc}){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Dismissible(
      background:Container(decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(5)),child: Row(children: [Icon(Icons.delete_forever)],)),
      key: UniqueKey(),
      onDismissed: dissFunc,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(20), // Image border
          child: SizedBox.fromSize(
            size: const Size.fromRadius(30), // Image radius
            child: Image.network(
                img,
                fit: BoxFit.fill),
          ),
        ),
        title:  Text(title),
        subtitle:  Text(
            body
        ),
        trailing: IconButton(icon:const Icon(Icons.edit),onPressed: (){function;},),

      ),
    ),
  );
}













/*
Widget defaultFormField({
  //Validation is not correct
  //required Function validate,
  @required controller,
  @required label,
  @required prefix,
  enable,
  @required type,
  suffix,
  suffixPressed,
  hint = '',
  onTap,
  onSubmit,
  onChange,
  isPassword = false,
}) =>
    Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          5.0,
        ),
        border: Border.all(
          color: HexColor('#F18D35'),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
      ),
      child: TextFormField(
        enabled: enable,
        cursorColor: HexColor('#F18D35'),
        //Validation is not correct
        //validator:validate ,
        onFieldSubmitted: onSubmit,
        controller: controller,
        keyboardType: type,
        obscureText: isPassword,
        onChanged: onChange,
        onTap: onTap,
        decoration: InputDecoration(
          label: Text(
            label,
            style: TextStyle(color: HexColor('#F18D35')),
          ),
          prefixIcon: Icon(
            prefix,
            color: HexColor('#F18D35'),
          ),
          hintText: hint,
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              suffix,
              color: HexColor('#F18D35'),
            ),
            onPressed: suffixPressed,
          ),
        ),
      ),
    );
 */