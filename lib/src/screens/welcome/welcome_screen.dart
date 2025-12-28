import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:m_app/src/utils/app_colors.dart';
import 'package:m_app/src/utils/k_assets.dart';
import 'package:m_app/src/utils/k_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  PageController _controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //padding: const EdgeInsets.all(20),
        child: PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              isLastPage = index == 2; // last page (0,1,2)
            });
          },
          children: [
            buildPage(
              color: Colors.blue.shade100,
              image: KAssets.welcome_1,
              title: 'Welcome to Vessel App',
              description: 'Track and manage your shipments easily.',
            ),
            buildPage(
              color: Colors.green.shade100,
              image: KAssets.welcome_2,
              title: 'Stay Updated',
              description: 'Get real-time vessel locations and updates.',
            ),
            buildPage(
              color: AppColors.skyColor,
              image: KAssets.welcome_3,
              title: 'Start Your Journey',
              description: 'Join us and explore the maritime world!',
            ),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? Padding(
            padding: const EdgeInsets.all(8.0),
            child:SizedBox(
              width: double.infinity,
              child: KButton(
                text: 'Get Started',
                onPressed: () {
                  Get.offNamed('/login');
                },
                backgroundColor: AppColors.primaryColor,
              ),
            ),


            /*TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  minimumSize: const Size.fromHeight(60),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('Get Started', style: TextStyle(fontSize: 20)),
              ),*/
          )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: const Text('Skip'),
                    onPressed: () {
                      _controller.jumpToPage(2);
                    },
                  ),
                  Center(
                    child: Row(
                      children: List.generate(
                        3,
                        (index) => Container(
                          margin: const EdgeInsets.all(4),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                _controller.hasClients &&
                                    _controller.page?.round() == index
                                ? Colors.blue
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    child: const Text('Next'),
                    onPressed: () {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildPage({
    required Color color,
    required String image,
    required String title,
    required String description,
  }) {
    return Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 250),
          const SizedBox(height: 40),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
