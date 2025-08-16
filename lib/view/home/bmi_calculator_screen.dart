import 'package:flutter/material.dart';
// Assuming AppColors exists in your project for consistent theming
// import 'package:flutter_application_1/utils/app_colors.dart';

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({super.key});

  @override
  _BMICalculatorScreenState createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  double? bmi;
  String bmiCategory = '';
  Color bmiCategoryColor = Colors.black; // Default color

  void calculateBMI() {
    final height = double.tryParse(heightController.text);
    final weight = double.tryParse(weightController.text);

    // Dismiss the keyboard
    FocusScope.of(context).unfocus();

    if (height != null && weight != null && height > 0) {
      final heightInMeters = height / 100;
      setState(() {
        bmi = weight / (heightInMeters * heightInMeters);
        // Update category and color after calculating BMI
        bmiCategory = getBMICategory(bmi!);
        bmiCategoryColor = getBMICategoryColor(bmi!);
      });
    } else {
      setState(() {
        bmi = null;
        bmiCategory = ''; // Clear category
        bmiCategoryColor = Colors.black; // Reset color
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid height and weight'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  String getBMICategory(double bmi) {
    if (bmi < 18.5) return "Underweight";
    if (bmi < 25) return "Normal";
    if (bmi < 30) return "Overweight";
    return "Obese";
  }

  Color getBMICategoryColor(double bmi) {
    if (bmi < 18.5) return Colors.blueAccent;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    return Colors.redAccent;
  }

  @override
  void dispose() {
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2), // Use a light background color
      // Added a standard AppBar
      appBar: AppBar(
        title: const Text(
          'BMI Calculator',
          style: TextStyle(color: Colors.black), // Title color
        ),
        backgroundColor: const Color(0xFFF2F2F2), // Match background
        elevation: 0, // No shadow
        iconTheme: const IconThemeData(
          color: Colors.black, // Back button color
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Adjusted padding
          child: SingleChildScrollView( // Added SingleChildScrollView to prevent overflow on small screens
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Removed the manual back button as AppBar handles it

                // Header card with gradient and result display
                Container(
                  padding: const EdgeInsets.all(24), // Adjusted padding
                  decoration: BoxDecoration(
                    gradient: const LinearGradient( // Using the same gradient
                      colors: [Color(0xFF6C9EEB), Color(0xFFA87FE7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                  child: Column( // Changed to Column to display BMI value and category
                    crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                    children: [
                      // Removed the "BMI Calculator" text here - it's in the AppBar now
                      // Removed the CircleAvatar for the BMI value

                      Text(
                        'Your BMI is',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8), // Slightly transparent white
                          fontSize: 18,
                           fontWeight: FontWeight.w400, // Lighter weight
                        ),
                      ),
                      const SizedBox(height: 8), // Spacing
                      Text(
                         // Display BMI value or '0.0' if null
                        bmi != null ? bmi!.toStringAsFixed(1) : '0.0',
                        style: const TextStyle(
                          color: Colors.white, // White color for the BMI number
                          fontSize: 48, // Larger font size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (bmi != null) ...[ // Show category only if BMI is calculated
                         const SizedBox(height: 8), // Spacing
                         Text(
                           bmiCategory, // Display the calculated category
                           style: TextStyle(
                             color: Colors.white.withOpacity(0.9), // White color for category
                             fontSize: 20,
                             fontWeight: FontWeight.w500,
                           ),
                         ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 20), // Spacing between header and input card

                // Input form card
                Container(
                   // Removed Expanded here - SingleChildScrollView handles scrolling
                  decoration: BoxDecoration(
                    color: Colors.white, // White background for the input card
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                    boxShadow: [ // Added a subtle shadow for depth
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24), // Adjusted padding
                  child: Column( // Inner column for input fields and button
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min, // Column takes minimum space
                    children: [
                      Text( // Added a title for the input section
                        'Enter your details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 20), // Spacing

                      TextField(
                        controller: heightController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true), // Allow decimals
                        decoration: InputDecoration(
                           labelText: 'Height (cm)',
                           labelStyle: TextStyle(color: Colors.black54),
                           hintText: 'e.g. 175', // Added hint text
                           hintStyle: TextStyle(color: Colors.black26),
                           filled: true,
                           fillColor: Colors.grey.shade100,
                           border: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(12),
                             borderSide: BorderSide.none,
                           ),
                           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14), // Padding inside field
                        ),
                        style: TextStyle(color: Colors.black87), // Text color
                      ),
                      const SizedBox(height: 16), // Spacing

                      TextField(
                        controller: weightController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true), // Allow decimals
                        decoration: InputDecoration(
                           labelText: 'Weight (kg)',
                           labelStyle: TextStyle(color: Colors.black54),
                           hintText: 'e.g. 70', // Added hint text
                           hintStyle: TextStyle(color: Colors.black26),
                           filled: true,
                           fillColor: Colors.grey.shade100,
                           border: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(12),
                             borderSide: BorderSide.none,
                           ),
                           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14), // Padding inside field
                        ),
                         style: TextStyle(color: Colors.black87), // Text color
                      ),
                      const SizedBox(height: 24), // Spacing

                      ElevatedButton(
                        onPressed: calculateBMI,
                        style: ElevatedButton.styleFrom(
                           // Using hardcoded colors, replace with AppColors if available
                          backgroundColor: const Color(0xFF6C9EEB), // Button background
                          foregroundColor: Colors.white, // Button text color
                          padding: const EdgeInsets.symmetric(vertical: 16), // Increased padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30), // More rounded button
                          ),
                          elevation: 3, // Add some elevation to the button
                        ),
                        child: const Text(
                          'Calculate BMI',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // Removed the BMI result display from here
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Removed the _PiePainter class as it's no longer used