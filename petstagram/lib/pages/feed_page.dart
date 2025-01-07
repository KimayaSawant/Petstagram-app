import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:petstagram/utils/colors.dart';
import 'package:petstagram/utils/global_vars.dart';
import 'package:petstagram/widgets/post_card.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor:  mobileBackgroundColor,
      appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              centerTitle: false,
              title: Image.asset(
                'assets/images/pet.png',
                // color: primaryColor,
                height: 50,
                width: 80,
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.messenger_outline,
                    color: primaryColor,
                  ),
                  onPressed: () {},
                ),
              ],
            ),

            body: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('posts').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(),);
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => Container(margin:
                  EdgeInsets.symmetric(horizontal: width > webScreenSize? width*0.3:0,
                  vertical: width > webScreenSize ? 15: 0,) ,
                  child: PostCard(
                    snap: snapshot.data!.docs[index].data(),
                  ),));
              },
            ),
    
    );
  }
}