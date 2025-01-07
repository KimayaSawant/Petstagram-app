import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petstagram/utils/colors.dart';
import 'package:petstagram/utils/global_vars.dart';


class MobileScreenLayout extends StatefulWidget{
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();

}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState(){
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }


  void navigationTapped(int page){
    pageController.jumpToPage(page);

  }

  void onPageChanged(int page){
    setState(() {
      _page = page;
    });

  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: homeScreenItems,
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
      ),

    bottomNavigationBar: CupertinoTabBar(
      backgroundColor: mobileBackgroundColor,
      items: [ 
        BottomNavigationBarItem(
        icon: Icon(Icons.home, color : _page == 0 ? primaryColor : secondaryColor),
        label : '',
        backgroundColor: primaryColor
        ),
        BottomNavigationBarItem(
        icon: Icon(Icons.search, color : _page == 1 ? primaryColor : secondaryColor),
        label : '',
        backgroundColor: primaryColor
        ),
                BottomNavigationBarItem(
        icon: Icon(Icons.add_circle , color : _page == 2 ? primaryColor : secondaryColor),
        label : '',
        backgroundColor: primaryColor
        ),
                BottomNavigationBarItem(
        icon: Icon(Icons.pets , color : _page == 3 ? primaryColor : secondaryColor),
        label : '',
        backgroundColor: primaryColor
        ),
                BottomNavigationBarItem(
        icon: Icon(Icons.cruelty_free , color : _page == 4 ? primaryColor : secondaryColor),
        label : '',
        backgroundColor: primaryColor
        ),

        ],
        onTap: navigationTapped,
        ),

    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';

// class MobileScreenLayout extends StatefulWidget{
//   const MobileScreenLayout({super.key});

//   @override
//   State<MobileScreenLayout> createState() => _MobileScreenLayoutState();

// }

// class _MobileScreenLayoutState extends State<MobileScreenLayout> {
//   String username = "";
//   @override
//   void initState() {
//     super.initState();
//     getUsername();
//   }

//   void getUsername() async{
//     DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
//     setState((){
//       username = (snap.data() as Map<String, dynamic>)['username'];
//     });
    
//     print(snap.data());
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(

//       body: Center(child: Text(username),),
//     );
//   }
// }