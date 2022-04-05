import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_picker_widget/media_picker_widget.dart';

Future<void> openImagePicker(
  BuildContext context,
  Function(File image) onImageSelected,
) async {
  // openCamera(onCapture: (image){
  //   setState(()=> mediaList = [image]);
  // });
  List<Media> mediaList = [];
  showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).pop(),
            child: DraggableScrollableSheet(
              initialChildSize: 0.6,
              maxChildSize: 0.95,
              minChildSize: 0.6,
              builder: (ctx, controller) => AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  color: Colors.white,
                  child: MediaPicker(
                    scrollController: controller,
                    mediaList: mediaList,
                    onPick: (selectedList) {
                      onImageSelected(selectedList[0].file!);

                      Navigator.pop(context);
                    },
                    onCancel: () => Navigator.pop(context),
                    mediaCount: MediaCount.single,
                    mediaType: MediaType.image,
                    decoration: PickerDecoration(
                      cancelIcon: const Icon(Icons.close),
                      albumTitleStyle: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      actionBarPosition: ActionBarPosition.top,
                      blurStrength: 2,
                      completeText: 'Change',
                    ),
                  )),
            ));
      });
}
