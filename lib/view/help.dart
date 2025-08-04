import 'package:flutter/material.dart';

class HelpView extends StatelessWidget {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Help & Support"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Company"),
              Tab(text: "Job Seeker"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            HelpContent(role: "Company"),
            HelpContent(role: "Job Seeker"),
          ],
        ),
      ),
    );
  }
}

class HelpContent extends StatelessWidget {
  final String role;
  HelpContent({required this.role});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome to the $role Help Center",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "We’re here to assist you. Below are common topics to help you navigate the platform.",
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          const SizedBox(height: 16),
          ContactSection(),
          const SizedBox(height: 16),
          const Text(
            "Frequently Asked Questions",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          FAQSection(role: role),
        ],
      ),
    );
  }
}

class ContactSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Need Assistance? Contact Us!",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text("📧 Email: dev.umar032@gmail.com"),
          //Text("📞 Phone: ++92 314 9560393"),

        ],
      ),
    );
  }
}

class FAQSection extends StatelessWidget {
  final String role;
  FAQSection({super.key, required this.role});

  final Map<String, List<Map<String, String>>> faqs = {
    "Company": [
      {"How to post a job?": "Go to 'Post a Job' section and fill in details."},
      {"How to manage applications?": "Navigate to 'My Jobs' to view applicants."},
    ],
    "Job Seeker": [
      {"How to apply for a job?": "Click 'Apply' on a job listing and upload your CV."},
      {"How to track applications?": "Check 'My Applications' section for updates."},
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: faqs[role]!.map((faq) {
        String question = faq.keys.first;
        String answer = faq.values.first;
        return ExpansionTile(
          title: Text(question, style: const TextStyle(fontWeight: FontWeight.bold)),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(answer, style: TextStyle(color: Colors.grey[700])),
            ),
          ],
        );
      }).toList(),
    );
  }
}
