import 'dart:io';

import 'package:client/core/theme/app_pallet.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/view/widgets/audio_wave.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SongUploadPage extends ConsumerStatefulWidget {
  const SongUploadPage({super.key});

  @override
  ConsumerState<SongUploadPage> createState() => _SongUploadPageState();
}

class _SongUploadPageState extends ConsumerState<SongUploadPage> {
  final songNameController = TextEditingController();
  final artistController = TextEditingController();
  Color selectedColor = Pallet.cardColor;
  File? selectedImage;
  File? selectedAudio;
  final formKey = GlobalKey<FormState>();

  void selectImageFile() async {
    final image = await pickImage();
    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }

  void selectAudioFile() async {
    final audio = await pickAudio();
    if (audio != null) {
      setState(() {
        selectedAudio = audio;
      });
    }
  }

  void clearAudio() {
    setState(() {
      selectedAudio = null;
    });
  }

  @override
  void dispose() {
    songNameController.dispose();
    artistController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref
        .watch(homeViewModelProvider.select((val) => val?.isLoading == true));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Song'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async{
              if (formKey.currentState!.validate() &&
                  selectedImage != null &&
                  selectedAudio != null) {
                await ref.read(homeViewModelProvider.notifier).uploadSong(
                      uploadSong: selectedAudio!,
                      thumbnailFile: selectedImage!,
                      artist: artistController.text,
                      songName: songNameController.text,
                      colorHex: selectedColor,
                    );
                Navigator.of(context).pop();
              } else {
                Fluttertoast.showToast(
                    msg: 'Missing field!', timeInSecForIosWeb: 5);
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: selectImageFile,
                        child: selectedImage != null
                            ? SizedBox(
                                height: 160,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : DottedBorder(
                                color: Pallet.borderColor,
                                dashPattern: const [9, 4],
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(10),
                                strokeCap: StrokeCap.round,
                                child: const SizedBox(
                                  height: 160,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.folder_open_outlined,
                                        size: 40,
                                      ),
                                      SizedBox(height: 15),
                                      Text(
                                        "Select the thumbnail for your song.",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 40),
                      selectedAudio != null
                          ? AudioWave(path: selectedAudio!.path, onTap: clearAudio,)
                          : CustomField(
                              hintText: 'Pick Song',
                              textEditingController: null,
                              isReaOnly: true,
                              onTap: selectAudioFile,
                            ),
                      const SizedBox(height: 20),
                      CustomField(
                        hintText: 'Song Name',
                        textEditingController: songNameController,
                      ),
                      const SizedBox(height: 20),
                      CustomField(
                        hintText: 'Artist',
                        textEditingController: artistController,
                      ),
                      const SizedBox(height: 20),
                      ColorPicker(
                        pickersEnabled: const {
                          ColorPickerType.wheel: true,
                        },
                        color: selectedColor,
                        onColorChanged: (Color color) {
                          setState(() {
                            selectedColor = color;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
