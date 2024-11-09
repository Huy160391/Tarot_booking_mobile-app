import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tarot/api/reader_api.dart';
import 'package:tarot/api/image_api.dart';
import 'package:tarot/model/image_model.dart';
import 'package:tarot/model/reader_model.dart';

class EditProfilePage extends StatefulWidget {
  final String readerId;

  EditProfilePage({required this.readerId});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  Reader? _reader;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchReaderData();
  }

  Future<void> _fetchReaderData() async {
    try {
      ReaderApi api = ReaderApi();
      ApiResponse? response = await api.fetchReader(widget.readerId);

      if (response != null && response.reader != null) {
        setState(() {
          _reader = response.reader;
          _nameController.text = _reader!.name ?? '';
          _phoneController.text = _reader!.phone ?? '';
          _descriptionController.text = _reader!.description ?? '';
          _dobController.text = _reader!.dob?.toIso8601String().split('T').first ?? '';
        });
      }
    } catch (e) {
      print('Failed to fetch reader data: $e');
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      UpdateProfileModel model = UpdateProfileModel(
        id: _reader!.id!,
        name: _nameController.text,
        phone: _phoneController.text,
        description: _descriptionController.text,
        dob: _dobController.text,
      );

      PostUpdateProfile postUpdateProfile = PostUpdateProfile();
      bool success = await postUpdateProfile.updateProfile(model);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Profile updated successfully.' : 'Failed to update profile.'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateImage() async {
    if (_selectedImage != null) {
      final imageApi = PostUpdateReaderImage();
      final imageRequest = UpdateImageRequest(
        readerId: widget.readerId,
        imageFile: _selectedImage!,
      );

      await imageApi.updateImage(imageRequest);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image updated successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No image selected.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dobController.text = picked.toIso8601String().split('T').first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/tarotpage.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      title: Text(
                        'Edit Profile',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      centerTitle: true,
                    ),
                    SizedBox(height: 10),
                    _buildImageSection(),
                    SizedBox(height: 20),
                    _buildProfileForm(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildImageSection() {
  return Column(
    children: [
      GestureDetector(
        onTap: _pickImage,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: _selectedImage != null
                  ? FileImage(_selectedImage!)
                  : AssetImage('assets/images/placeholder.png') as ImageProvider,
            ),
            if (_selectedImage == null)
              Icon(
                Icons.add,
                color: Colors.white.withOpacity(0.8),
                size: 50,
              ),
          ],
        ),
      ),
      SizedBox(height: 10),
      ElevatedButton(
        onPressed: _updateImage,
        child: Text('Update Image'),
      ),
    ],
  );
}


  Widget _buildProfileForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _buildTextField(_nameController, 'Name', 'Please enter your name'),
          SizedBox(height: 10),
          _buildTextField(_phoneController, 'Phone', 'Please enter your phone number'),
          SizedBox(height: 10),
          _buildTextField(_descriptionController, 'Description', 'Please enter a description'),
          SizedBox(height: 10),
          _buildDatePicker(),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _updateProfile,
            child: Text('Update Profile'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String validationMessage) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      validator: (value) => value!.isEmpty ? validationMessage : null,
    );
  }

  Widget _buildDatePicker() {
    return TextButton(
      onPressed: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Date of Birth (YYYY-MM-DD)',
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(_dobController.text.isNotEmpty ? _dobController.text : 'Select Date'),
      ),
    );
  }
}
