import 'dart:io';
import 'dart:ui';

import 'package:blog_app/domain/entities/blog_params.dart';
import 'package:blog_app/gen/assets.gen.dart';
import 'package:blog_app/presentation/cubit/blog_cubit/blog_cubit.dart';
import 'package:blog_app/presentation/widgets/custom_button.dart';
import 'package:blog_app/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';

class CreateBlogScreen extends StatefulWidget {
  const CreateBlogScreen({super.key});

  @override
  State<CreateBlogScreen> createState() => _CreateBlogScreenState();
}

class _CreateBlogScreenState extends State<CreateBlogScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  File? _selectedImage;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    _titleController.dispose();

    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate() && _selectedImage != null) {
      final param = BlogParam(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        status: 'published',
        bannerImage: _selectedImage!,
      );
      context.read<BlogCubit>().createBlog(param);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Optional: Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: MyAssets.images.blog
                    .provider(), // Replace with your image if needed
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: 350,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Form(
                    key: _formKey,
                    child: BlocConsumer<BlogCubit, BlogState>(
                      listener: (context, state) {
                        if (state is BlogSuccess) {
                          context.loaderOverlay.hide();
                          Fluttertoast.showToast(
                            msg:
                                "Blog created with slug ${state.blog.blog.slug}",
                            backgroundColor: Colors.black,
                            gravity: ToastGravity.BOTTOM,
                            textColor: Colors.white,
                          );

                          _formKey.currentState?.reset();
                          _titleController.clear();
                          _contentController.clear();
                          setState(() {
                            _selectedImage = null;
                          });
                          Navigator.pop(context);
                        } else if (state is BlogFailure) {
                          context.loaderOverlay.hide();
                          if (state.error.contains('Session expired')) {
                            Fluttertoast.showToast(
                              msg:
                                  'Session expired. Please resubmit your blog.',
                              backgroundColor: Colors.red,
                              gravity: ToastGravity.BOTTOM,
                            );
                            Navigator.pop(context);
                          } else {
                            Fluttertoast.showToast(
                              msg: state.error,
                              backgroundColor: Colors.red,
                              gravity: ToastGravity.BOTTOM,
                            );
                            Navigator.pop(context);
                          }
                        } else if (state is BlogLoading) {
                          context.loaderOverlay.show();
                        }
                      },
                      builder: (context, state) {
                        return SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Create Blog',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 20),
                              CustomTextfield(
                                hintText: 'Title',
                                icon: Icons.title,
                                controller: _titleController,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? 'Please enter title'
                                    : null,
                              ),
                              const SizedBox(height: 15),
                              CustomTextfield(
                                hintText: 'Content',
                                icon: Icons.description,
                                controller: _contentController,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? 'Please enter content'
                                    : null,
                                maxLines: 4,
                              ),
                              const SizedBox(height: 15),

                              CustomButton(
                                text: _selectedImage == null
                                    ? 'Pick Banner Image'
                                    : 'Change Banner Image',
                                onPressed: _pickImage,
                              ),

                              const SizedBox(height: 15),

                              // 👉 Image Preview with rounded corners
                              if (_selectedImage != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.file(
                                    _selectedImage!,
                                    width: double.infinity,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              const SizedBox(height: 20),
                              CustomButton(
                                text: "Upload",
                                onPressed: state is BlogLoading
                                    ? null
                                    : _submit,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
