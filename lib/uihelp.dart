import 'package:flutter/material.dart';

class UiHelp1 {
  static Widget textf(TextEditingController controller, String hintText,
      IconData iconData, bool obscureText) {
    return Container(
      height: 40, // Specify the height of the text field
      child: TextField(
        cursorColor: Colors.black,
        cursorHeight: 15.0,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: Icon(iconData, color: Colors.grey, size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
              vertical: 5.0, horizontal: 25.0), // Adjust based on your needs
        ),
        style: TextStyle(
          color: Colors.black, // Text color
          fontSize: 14.0,
        ),
      ),
    );
  }
  static Widget Searchtf(TextEditingController controller, String hintText,
      IconData iconData, bool obscureText) {
    return Container(
      height: 40, // Specify the height of the text field
      child: TextField(
        cursorColor: Colors.white,
        cursorHeight: 20.0,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: Icon(iconData, color: Colors.grey, size: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none
          ),
          filled: true,
          fillColor: Color.fromRGBO(196, 196, 196, 0.27),
          contentPadding: EdgeInsets.symmetric(
              vertical: 13.0, horizontal: 25.0), // Adjust based on your needs
        ),
        style: TextStyle(
          color: Colors.white, // Text color
          fontSize: 14.0,
        ),
      ),
    );
  }

  static Widget textf2(TextEditingController controller, String hintText,
      IconData iconData, bool obscureText) {
    return Container(
      height: 30, // Specify the height of the text field
      child: TextField(
        cursorColor: Colors.white,
        cursorHeight: 20.0,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: Icon(iconData, color: Colors.grey, size: 15),
        

          filled: true,
          fillColor: Color.fromRGBO(55, 55, 55, 1),
          contentPadding: EdgeInsets.symmetric(
              vertical: 11.0, horizontal: 25.0), // Adjust based on your needs
        ),
        style: TextStyle(
          color: Colors.white, // Text color
          fontSize: 15.0,
        ),
      ),
    );
  }

  static button(VoidCallback voidCallback, String text) {
    return Center(
        child: SizedBox(
      height: 40,
      width: 400,
      child: ElevatedButton(
          onPressed: voidCallback,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 10),
          )),
    ));
  }

  static CustomAlertBox(BuildContext context, String text) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(text, style: TextStyle(fontSize: 13)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              )
            ],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          );
        });
  }

  static Future<void> showCustomAlertBox(
    BuildContext context, {
    required String title,
    required String content,
  }) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content, style: TextStyle(fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      );
    },
  );
}

static Widget button3(VoidCallback onPressed, Widget child) {
    return Center(
      child: SizedBox(
        
        height: 40,
        width: 400,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor:  Color.fromRGBO(168, 195, 221, 0.3),
            shape: RoundedRectangleBorder(
              
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
          ),
          child: child,
        ),
      ),
    );
  }

}
