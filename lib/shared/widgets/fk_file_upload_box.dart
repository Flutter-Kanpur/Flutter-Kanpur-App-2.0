import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/utils/colors.dart';

class FkFileUploadBox extends StatelessWidget {
  const FkFileUploadBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD0D0D0),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          const Icon(Icons.cloud_upload_outlined, color: Colors.grey),
          const SizedBox(height: 10),
          Text(
            'Choose a file or drag & drop it here.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.subtitleTextDarkGrey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: () {}, child: const Text('Browse files')),
        ],
      ),
    );
  }
}
