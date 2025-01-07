import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:petstagram/pages/activity_page.dart';
import 'package:petstagram/pages/add_post_page.dart';
import 'package:petstagram/pages/feed_page.dart';
import 'package:petstagram/pages/search_page.dart';
import 'package:petstagram/pages/profile_page.dart';


const webScreenSize = 600;


List<Widget> homeScreenItems = [
          const FeedPage(),
          const SearchPage(),
          const AddPostPage(),
          const ActivityPage(),
          ProfilePage(uid: FirebaseAuth.instance.currentUser!.uid,),

];