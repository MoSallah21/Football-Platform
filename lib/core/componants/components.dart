import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';



Widget myDivider() {
  return Container(
    height: 1.0,
    width: double.infinity,
    color: Colors.grey[300],
  );
}


Widget defaultTextForm(
    {
      required TextEditingController controller,
      required TextInputType inputType,
      required IconData prefix,
      required String lable,
      required String validateText,
      IconData? suffixIcon,
      Function()? suffixPressed,
      Function(String)? onsub,
      bool textShow=false,
      Function()? validator,
    }
    )
{
  return TextFormField(
    cursorColor: Colors.black,
    controller:controller ,
    onFieldSubmitted:onsub ,
    keyboardType:inputType,
    obscureText: textShow,
    decoration: InputDecoration(
  focusedBorder: OutlineInputBorder(
  borderSide: BorderSide(color: HexColor('#69A88D')),
),
      prefixIcon: Icon(prefix,color: HexColor('#69A88D'),size:20.0),
      labelText: lable,
      labelStyle: TextStyle(color: Colors.grey),
      suffixIcon: IconButton(icon:Icon(suffixIcon),color: Colors.black,onPressed:suffixPressed),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
    validator: (String? value)
    {
      if(value!.isEmpty) return validateText;
      else return null;
    },
  );
}


Future navigateAndFinish(context,Widget screen){
  return Navigator.pushAndRemoveUntil
    (context, MaterialPageRoute(builder: (context) => screen),(Route<dynamic> route) =>false);

}


Future navigateTo(context,Widget screen){
  return Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
}
void navigateToWithPush(context,screen){
  Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            ),
          ),
          child: child,
        );
      },
    ),
  );
}

void navigateToWithSlide(context,screen){
  Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    ),
  );

}

enum ToastState {SUCSSES,ERROR,WARNING}
Color? TColor;
Color? changeColors(ToastState state){
  switch(state){
    case ToastState.SUCSSES:
      TColor=Colors.green;
      break;
    case ToastState.ERROR:
      TColor=Colors.red;
      break;
    case ToastState.WARNING:
      TColor=Colors.deepOrangeAccent;
      break;}
  return TColor;
}
// void showToast({required String text, required ToastState state,}) {
//   Fluttertoast.showToast(
//       msg: text,
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 1,
//       backgroundColor: changeColors(state),
//       textColor: Colors.white,
//       fontSize: 16.0
//   );
// }
Widget actionButton({
  Color? buttonColor,
  Color? textColor,
  required String title,
  required Function onTap,
}) {
  return SizedBox(
    height: 50,
    width: 200,
    child: ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(buttonColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0), // Adjust border radius as needed
          ),
        ),
      ),
      onPressed: () => onTap(),
      child: Text(
        title,
        style: TextStyle(color: textColor,fontWeight: FontWeight.bold,fontSize: 18),
      ),
    ),
  );
}
Widget CircularButton(
{
required VoidCallback onPressed,
}
){
return InkWell(
onTap: onPressed,
child: Container(
width: 50.0,
height: 50.0,
decoration: BoxDecoration(
shape: BoxShape.circle,
color: Colors.purple.shade500,
),
child: Icon(
Icons.arrow_forward_ios_outlined,
color: Colors.white,
),
),
);
}

