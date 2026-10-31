
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const StudentInfoApp());
}

class StudentInfoApp extends StatelessWidget {
  const StudentInfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CSS3344 Lab 01',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const StudentProfileScreen(),
    );
  }
}

// LAB 02: StatefulWidget for interactive pickers
class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() =>
      _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  DateTime _selectedDate = DateTime.now();
  String _selectedRole = 'Student';

  final List<String> _roles = [
    'Student',
    'Developer',
    'Designer',
  ];

  // LAB 02: Material Date Picker
  Future<void> _selectMaterialDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null && mounted) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // LAB 02: Cupertino Date Picker
  void _showCupertinoDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (popupContext) => Container(
        height: 280,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: CupertinoButton(
                  child: const Text('Done'),
                  onPressed: () => Navigator.pop(popupContext),
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: _selectedDate,
                  minimumDate: DateTime(1950),
                  maximumDate: DateTime.now(),
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() {
                      _selectedDate = newDate;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // LAB 02: Cupertino Wheel Picker
  void _showCupertinoRolePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (popupContext) => Container(
        height: 240,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: CupertinoButton(
                  child: const Text('Done'),
                  onPressed: () => Navigator.pop(popupContext),
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                    initialItem: _roles.indexOf(_selectedRole),
                  ),
                  itemExtent: 32,
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      _selectedRole = _roles[index];
                    });
                  },
                  children: _roles.map((role) {
                    return Center(child: Text(role));
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // LAB 02: Four interactive pickers
  Widget _buildPickerSection() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Interactive Pickers (Lab 2.2)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Divider(height: 24),

              Text(
                'Selected Date: '
                    '${_selectedDate.day}-'
                    '${_selectedDate.month}-'
                    '${_selectedDate.year}',
              ),

              const SizedBox(height: 5),

              Text('Selected Role: $_selectedRole'),

              const SizedBox(height: 12),

              // Material Date Picker
              OutlinedButton.icon(
                onPressed: () => _selectMaterialDate(context),
                icon: const Icon(Icons.calendar_today, size: 18),
                label: const Text('Material Date Picker'),
              ),

              const SizedBox(height: 6),

              // Cupertino Date Picker
              OutlinedButton.icon(
                onPressed: () => _showCupertinoDatePicker(context),
                icon: const Icon(Icons.date_range, size: 18),
                label: const Text('Cupertino Date Picker'),
              ),

              const SizedBox(height: 12),

              const Text('Material Dropdown:'),

              // Material Dropdown
              DropdownButton<String>(
                value: _selectedRole,
                isExpanded: true,
                items: _roles.map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedRole = newValue;
                    });
                  }
                },
              ),

              const SizedBox(height: 8),

              // Cupertino Wheel Picker
              OutlinedButton.icon(
                onPressed: () => _showCupertinoRolePicker(context),
                icon: const Icon(Icons.view_carousel, size: 18),
                label: const Text('Cupertino Wheel Picker'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // LAB 02: Portrait mode
  Widget _buildPortraitView() {
    return ListView(
      children: [
        const StudentDetailsSection(),

        const TitleSection(
          name: 'University of Technology Sarawak',
          location: 'Sibu, Sarawak, Malaysia',
          starCount: 41,
        ),

        const ImageSection(
          imagePath: 'assets/images/location.jpg',
        ),

        const SizedBox(height: 12),

        _buildPickerSection(),
      ],
    );
  }

  // LAB 02: Landscape mode
  Widget _buildLandscapeView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView(
            children: const [
              StudentDetailsSection(),
            ],
          ),
        ),

        Expanded(
          child: ListView(
            children: [
              const TitleSection(
                name: 'University of Technology Sarawak',
                location: 'Sibu, Sarawak, Malaysia',
                starCount: 41,
              ),

              const ImageSection(
                imagePath: 'assets/images/location.jpg',
              ),

              const SizedBox(height: 12),

              _buildPickerSection(),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSS3344 Mobile App Dev - Lab 02'),
        centerTitle: true,
        backgroundColor:
        Theme.of(context).colorScheme.primaryContainer,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? _buildPortraitView()
              : _buildLandscapeView();
        },
      ),
    );
  }
}

// LAB 02: Reusable StudentDetailsSection
// Keeps the Lab 01 profile details, with the
// blue card styling shown in the lecturer's example.
class StudentDetailsSection extends StatelessWidget {
  const StudentDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Card(
        elevation: 4,
        color: Colors.indigo,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Profile picture
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                backgroundImage:
                AssetImage('assets/images/profile.jpg'),
              ),

              const SizedBox(height: 20),

              // Replace with your full name
              const Text(
                'MOHAMMAD ANIQ SHAMIM BIN MOHAMMAD SAFIAN',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 8),

              // Replace with your student ID
              const Text(
                'Student ID: BCA24020016',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),

              const Divider(
                height: 32,
                thickness: 1,
                color: Colors.white70,
              ),

              const Text(
                'Personal Life Goal / Quote:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'When the lion speaks, you listen.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// LAB 02: Exercise 2.1 - TitleSection
// Follows the lecturer's base code.
class TitleSection extends StatelessWidget {
  final String name;
  final String location;
  final int starCount;

  const TitleSection({
    super.key,
    required this.name,
    required this.location,
    required this.starCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Icon(Icons.star, color: Colors.red[500]),
          const SizedBox(width: 4),
          Text('$starCount'),
        ],
      ),
    );
  }
}

// LAB 02: ImageSection
// Displays the location image from the assets folder.
class ImageSection extends StatelessWidget {
  final String imagePath;

  const ImageSection({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          imagePath,
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 180,
              color: Colors.indigo.shade100,
              child: const Center(
                child: Text(
                  'Location image not found',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
