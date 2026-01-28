import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:password_saver/providers/password_provider.dart';

class AddPasswordScreen extends StatefulWidget {
  final int? editIndex;

  const AddPasswordScreen({Key? key, this.editIndex}) : super(key: key);

  @override
  State<AddPasswordScreen> createState() => _AddPasswordScreenState();
}

class _AddPasswordScreenState extends State<AddPasswordScreen> {
  late TextEditingController _placeController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _customFieldLabelController;
  late TextEditingController _customFieldController;
  bool _obscurePassword = true;
  bool _hasCustomField = false;

  @override
  void initState() {
    super.initState();
    _placeController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _customFieldLabelController = TextEditingController();
    _customFieldController = TextEditingController();
    
    // Load existing password data if editing
    if (widget.editIndex != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final passwordProvider = Provider.of<PasswordProvider>(context, listen: false);
        final passwords = passwordProvider.passwords;
        if (widget.editIndex! < passwords.length) {
          final password = passwords[widget.editIndex!];
          _placeController.text = password.place;
          _usernameController.text = password.username;
          _passwordController.text = password.password;
          if (password.customFieldLabel != null && password.customFieldLabel!.isNotEmpty) {
            _hasCustomField = true;
            _customFieldLabelController.text = password.customFieldLabel ?? '';
            _customFieldController.text = password.customField ?? '';
          }
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    _placeController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _customFieldLabelController.dispose();
    _customFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.editIndex == null ? '➕ Add Password' : '✏️ Edit Password'),
        backgroundColor: Colors.blue[700],
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[50]!,
              Colors.blue[100]!,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo area
              Container(
                height: 80,
                alignment: Alignment.center,
                child: Icon(
                  Icons.lock_outline,
                  size: 60,
                  color: Colors.blue[700],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.editIndex == null ? 'Create New Entry' : 'Update Entry',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
              const SizedBox(height: 24),
              _buildTextField(
                _placeController,
                'Place (e.g., Gmail)',
                Icons.location_on,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                _usernameController,
                'Username/Email',
                Icons.person,
              ),
              const SizedBox(height: 16),
              _buildPasswordField(),
              const SizedBox(height: 16),
              _buildCustomFieldCheckbox(),
              if (_hasCustomField) ...[
                const SizedBox(height: 12),
                _buildTextField(
                  _customFieldLabelController,
                  'Field Label (e.g., "Security Question")',
                  Icons.label,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  _customFieldController,
                  'Field Value',
                  Icons.note,
                ),
              ],
              const SizedBox(height: 24),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue[700]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: Icon(Icons.lock, color: Colors.blue[700]),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.blue[700],
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildCustomFieldCheckbox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue[300]!),
      ),
      child: CheckboxListTile(
        title: const Text('Add Custom Field (Optional)', style: TextStyle(fontWeight: FontWeight.w500)),
        value: _hasCustomField,
        onChanged: (value) {
          setState(() {
            _hasCustomField = value ?? false;
          });
        },
        activeColor: Colors.blue[700],
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton.icon(
      onPressed: _savePassword,
      icon: const Icon(Icons.save, size: 24),
      label: Text(
        widget.editIndex == null ? 'Add Password' : 'Update Password',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[700],
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _savePassword() async {
    if (_placeController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final passwordProvider = Provider.of<PasswordProvider>(context, listen: false);

    try {
      if (widget.editIndex == null) {
        await passwordProvider.addPassword(
          _placeController.text,
          _usernameController.text,
          _passwordController.text,
          customFieldLabel: _hasCustomField ? _customFieldLabelController.text : null,
          customField: _hasCustomField ? _customFieldController.text : null,
        );
      } else {
        await passwordProvider.updatePassword(
          widget.editIndex!,
          _placeController.text,
          _usernameController.text,
          _passwordController.text,
          customFieldLabel: _hasCustomField ? _customFieldLabelController.text : null,
          customField: _hasCustomField ? _customFieldController.text : null,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password saved successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
