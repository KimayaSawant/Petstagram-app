import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petstagram/providers/user_provider.dart';
import 'package:petstagram/resources/firestore_methods.dart';
import 'package:petstagram/utils/colors.dart';
import 'package:petstagram/utils/utils.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {

  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;
  void postImage(String uid,   String username,    String profImage,) async {
    setState(() {
      _isLoading= true;
    });
    try{
      String res = await FirestoreMethods().uploadPost(_descriptionController.text, _file!, uid, username, profImage,);
        if(res == "success"){
          setState(() {
          _isLoading= false;
        });
        clearImage();
        showSnackBar('Posted!', context);
      }
      else{
        setState(() {
        _isLoading= false;
      });
        showSnackBar(res, context);
      }
    }
    catch(e){
        showSnackBar(e.toString(), context);
    }
  }
  _selectImage(BuildContext contex) async{
    return showDialog(context: context, builder: (contex){
      return SimpleDialog(
        title: const Text('Create a Post'),
        children: [
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text('Take a photo') ,
            onPressed: () async{
              Navigator.of(context).pop();
              Uint8List file = await pickImage(ImageSource.camera,);

              setState(() {
                _file = file;
              });
            },
          ),

         SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text('Choose from gallery') ,
            onPressed: () async{
              Navigator.of(context).pop();
              Uint8List file = await pickImage(ImageSource.gallery,);

              setState(() {
                _file = file;
              });
            },
          ),

          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text('Cancel') ,
            onPressed: ()  {
              Navigator.of(context).pop();
              
            },
          ),

        ],
      );
    });
  }
  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final User user = Provider.of<UserProvider>(context).getUser;

      return _file == null
      ? Center(
        
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
              'assets/images/pet.png', // Path to your image asset
              height: 100, // Adjust size as needed
              width: 100,
            ),
            const SizedBox(height: 20),
              IconButton(
                icon: const Icon(Icons.upload, size: 50, color: Colors.grey),
                onPressed: () => _selectImage(context),
              ),
              const SizedBox(height: 10), // Space between icon and text
              const Text(
                'Hey Pet Owner! Want to share something about your pet?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
      : 
     Scaffold(

      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: clearImage,
          
          ),
          title: const  Text('Post to'),
          centerTitle: false,
          actions: [
            TextButton(onPressed: () => postImage(user.uid,user.username,user.photoUrl),
             child: const Text('Post', style: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),))
          ],
      ),


      body: Column(
        children: [
          _isLoading? const LinearProgressIndicator(): const Padding(padding: EdgeInsets.only(top:0)), const Divider(), 
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround ,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  user.photoUrl,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.35,
                child: TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Write a Caption...',
                    border: InputBorder.none,
                  ),
                  maxLines: 8,
                )
              ),

              SizedBox(
                height: 45,
                width: 45,
                child: AspectRatio(
                  aspectRatio: 487/451,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(_file!),
                        fit: BoxFit.fill,
                        alignment: FractionalOffset.topCenter,
                        )
                    ),
                  ),
                  
                  ),

              ),
              const Divider(),
            ],
          )
        ],
      )

    );
  }
}