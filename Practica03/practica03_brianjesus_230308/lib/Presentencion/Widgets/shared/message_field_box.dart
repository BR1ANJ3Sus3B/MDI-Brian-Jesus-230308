import 'package:flutter/material.dart';

class MessageFieldBox extends StatelessWidget {
  const MessageFieldBox({super.key});

  

  @override
  Widget build(BuildContext context) {

    final texController = TextEditingController(); 
    final FocusNode focusNode = FocusNode();
    final outlineInputBorder = UnderlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(40)
    );

    final inputDecoration = InputDecoration (
      hintText: 'End your message with a "??"',
       enabledBorder:outlineInputBorder,
       focusedBorder: outlineInputBorder,

        
        filled: true,
        suffixIcon: IconButton (icon:
        Icon(Icons.send_outlined),
        
        onPressed: (){
          final TextValue = texController.value.text;

          debugPrint('button : $TextValue');
          texController.clear();
        },

        ),

    );

    return TextFormField(
      
      focusNode: focusNode,
      controller: texController,
      decoration:inputDecoration ,
      onFieldSubmitted:(value) {
        debugPrint('Submit value $value');
        texController.clear();
        focusNode.requestFocus();

      },
    
    );
      
  }
}