import 'package:flutter/material.dart';
import 'package:petstagram/utils/colors.dart';
import 'package:petstagram/utils/global_vars.dart';


class WebScreenLayout extends StatefulWidget{
  const WebScreenLayout({super.key});

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();

}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  int _page =0;
  late PageController pageController; 

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
              centerTitle: false,
              title: Image.asset(
                'assets/images/pet.png',
                // color: primaryColor,
                height: 32,
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.home,
                    color: _page == 0? primaryColor:secondaryColor,
                  ),
                  onPressed: () => navigationTapped(0),
                ),
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: _page == 1 ? primaryColor : secondaryColor,
                  ),
                  onPressed: () => navigationTapped(1),
                ),
                IconButton(
                  icon: Icon(
                    Icons.add_circle,
                    color: _page == 2 ? primaryColor : secondaryColor,
                  ),
                  onPressed: () => navigationTapped(2),
                ),
                IconButton(
                  icon: Icon(
                    Icons.pets,
                    color: _page == 3 ? primaryColor : secondaryColor,
                  ),
                  onPressed: () => navigationTapped(3),
                ),

                IconButton(
                  icon:  Icon(
                    Icons.cruelty_free,
                    color: _page == 4 ? primaryColor : secondaryColor,
                  ),
                  onPressed: () => navigationTapped(4),
                ),
              ],
      ),
      
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems,
      ),
    );
  }
}