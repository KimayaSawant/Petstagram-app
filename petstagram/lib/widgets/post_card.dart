import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:petstagram/pages/comments_page.dart';
import 'package:petstagram/providers/user_provider.dart';
import 'package:petstagram/resources/firestore_methods.dart';
// import 'package:petstagram/providers/user_provider.dart';
import 'package:petstagram/utils/colors.dart';
import 'package:petstagram/utils/global_vars.dart';
import 'package:petstagram/utils/utils.dart';
import 'package:petstagram/widgets/like_animation.dart';
import 'package:provider/provider.dart';
import 'package:petstagram/models/user.dart' as model;


class PostCard extends StatefulWidget {
  final snap;
  const PostCard({
    super.key,
    required this.snap,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState  extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLen = 0;

  @override
  void initState(){
    super.initState();
    getComments();
  }

  void getComments() async{
    try{
      QuerySnapshot snap = await FirebaseFirestore.instance.collection('posts').doc(widget.snap['postId']).collection('comments').get();
      commentLen = snap.docs.length;
    }
    catch(e){
      showSnackBar(e.toString(), context);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Container( 
      color: width > webScreenSize? secondaryColor : mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(
        vertical: 10
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16
            ).copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage( 
                    widget.snap['profImage'],
                  
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.snap['username'], style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                      ],
                    ), ),),

                   IconButton(onPressed: () {

                    showDialog(
                      context: context,
                       builder: (context) => Dialog(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(
                            vertical : 16,
                          ),
                          shrinkWrap: true,
                          children: [
                            'Delete',
                          ].map(
                            (e) => InkWell(
                              onTap: () async {
                                FirestoreMethods().deletePost(widget.snap['postId']);
                                Navigator.of(context).pop();
                              },
                              child : Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                                  child: Text(e),
                              ),
                            ),
                          ).toList(),
                        ),
                       ));

                   }, icon: const  Icon(Icons.more_vert),
                   ) ,
              ],
            ),

            // Image Section
          ),

          GestureDetector(
            onDoubleTap: (){
              FirestoreMethods().likePost(
                widget.snap['postId'],
                user.uid,
                widget.snap['likes']
              );
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                height: MediaQuery.of(context).size.height*0.35,
                width : double.infinity,
                child : Image.network(widget.snap['postUrl'],
                fit : BoxFit.cover,
                  ),
                ),

                AnimatedOpacity(
                  duration: const Duration(),
                  opacity: isLikeAnimating?  1:0,
                  child: LikeAnimation(child: const Icon(Icons.pets, color: Colors.white, size: 100), 
                    isAnimating: isLikeAnimating, duration: const Duration(milliseconds: 400,),
                    onEnd: () {
                        setState(() {
                          isLikeAnimating = false;
                        });
                    },
                )
                
                )

                
              ],
            ),
          ),

          // Like Comment Section

          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton ( 
                  onPressed: () => FirestoreMethods().likePost(
                    widget.snap['postId'],
                    user.uid,
                    widget.snap['likes']
                  ),
                icon:  widget.snap['likes'].contains(user.uid)? const Icon(
                  Icons.pets,
                  color: Color.fromARGB(255, 209, 88, 128),
                ): const Icon(Icons.pets_outlined,),
                ),
              ),

              IconButton(
               icon: const Icon(
                Icons.comment_outlined
               ),
               onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentsPage(
                      postId: widget.snap['postId'].toString(),
                    ),
                  ),
               ),),

             IconButton(onPressed: () {},
               icon: const Icon(
                Icons.send
               ),
               ),
            ],
          ),

          //Description and comments

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,      
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.snap['likes'].length} likes',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top : 8,
                  ),

                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: primaryColor),
                      children: [
                        TextSpan(
                          text : widget.snap['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
         
                        ),
                        TextSpan(
                          text: ' ${widget.snap['description']}',
                        ),
                      ]

                    )
                    ),
                ),
                InkWell(
                  onTap: () {},
                
                child : Container(
                  padding: const EdgeInsets.symmetric(vertical: 4) ,
                  child:  Text('View all $commentLen comments', style: const TextStyle(
                    fontSize: 16,
                    color: secondaryColor
                  ),),
                ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(DateFormat.yMMMd().format(widget.snap['datePublished'].toDate(),) ,
                  ),
                )
              ],
            ),
          )

        ],
      ),
      );
  }
}


