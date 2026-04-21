import 'dart:io';

import 'package:flutter/material.dart';

import '../../../shared/localization/app_strings.dart';
import '../../../shared/theme/app_color.dart';
import '../providers/add_story_provider.dart';

class ImagePickerArea extends StatelessWidget {
  const ImagePickerArea({
    super.key,
    required this.provider,
    required this.isLoading,
  });

  final AddStoryProvider provider;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final hasImage = provider.selectedImage != null;

    return Column(
      children: [
        GestureDetector(
          onTap: isLoading ? null : provider.pickImage,
          child: Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: hasImage ? AppColor.primary : AppColor.borderLight,
                width: hasImage ? 2 : 1,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: hasImage
                ? Image.file(
                    File(provider.selectedImage!.path),
                    fit: BoxFit.cover,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColor.primary.withAlpha(25),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_photo_alternate_outlined,
                          color: AppColor.primary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        strings.selectImage,
                        style: const TextStyle(
                          color: AppColor.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'JPG, PNG supported',
                        style: TextStyle(
                          color: AppColor.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        if (hasImage) ...[
          const SizedBox(height: 8),
          Center(
            child: TextButton.icon(
              onPressed: isLoading ? null : provider.pickImage,
              icon: const Icon(
                Icons.swap_horiz_rounded,
                size: 18,
                color: AppColor.primary,
              ),
              label: Text(
                strings.selectImage,
                style: const TextStyle(color: AppColor.primary, fontSize: 13),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
