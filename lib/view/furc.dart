import 'package:flutter/material.dart';
import 'package:head_hunter/utils/constants/colors.dart';

class UniversityInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('University Info',style: TextStyle(color: whiteColor),),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    'https://www.fui.edu.pk/sites/default/files/furc-building-image_0.jpg',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Foundation University Rawalpindi Campus',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
              const SizedBox(height: 10),
              const Text(
                'Location: Rawalpindi, Pakistan',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 10),
              const Text(
                'Founded: 2002',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 10),

              const Text(
                'About Us:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
              const SizedBox(height: 5),
              const Text(
                'Foundation University Islamabad (FUI) was granted its charter in the Private Sector by the Federal Govt in Oct 2002. Foundation University School of Science & Technology has three faculties: Faculty of Engineering & IT, Faculty of Arts & Social Sciences & Faculty of Management Sciences. It is accredited by HEC and its programs are accredited by PEC, NBEAC, NCEAC & NTC. Recently, we have added Technology related programs like IET and Bio Med Tech, and also Tourism & Hospitality programs.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}