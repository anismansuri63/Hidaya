import 'package:com_quranicayah/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../theme/app_colors.dart';


class QazaStepperPage extends StatefulWidget {
  final Color primaryColor;

  const QazaStepperPage({
    super.key,
    required this.primaryColor,
  });

  @override
  State<QazaStepperPage> createState() => _QazaStepperPageState();
}

class _QazaStepperPageState extends State<QazaStepperPage> {
  int _currentStep = 0;

  int? age;
  String? gender;
  int balighAge = 15; // default for male, 12 for female later
  int periodDays = 7;
  bool includeWitr = true;
  // prayer performance percentages (0-100)
  Map<String, double> prayerPerformance = {
    "Fajr": 0,
    "Dhuhr": 0,
    "Asr": 0,
    "Maghrib": 0,
    "Isha": 0,
    "Witr": 0,
  };

  // results
  Map<String, int> missedPrayers = {};
  int totalDays = 0;
  int exemptDays = 0;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  void calculateResults() {

    if (age == null || gender == null) return;

    // adjust default baligh age
    if (gender == "Male") {
      balighAge = 15;
    } else {
      balighAge = 12;
    }

    int yearsResponsible = age! - balighAge;
    if (yearsResponsible < 0) yearsResponsible = 0;

    totalDays = yearsResponsible * 365;

    if (gender == "Female") {
      exemptDays = yearsResponsible * 12 * periodDays;
    } else {
      exemptDays = 0;
    }

    int effectiveDays = totalDays - exemptDays;
    if (effectiveDays < 0) effectiveDays = 0;

    Map<String, int> results = {};
    for (var prayer in ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"]) {
      double prayed = prayerPerformance[prayer]! / 100.0;
      results[prayer] = (effectiveDays * (1 - prayed)).round();
    }

    if (includeWitr) {
      double prayed = prayerPerformance["Witr"]! / 100.0;
      results["Witr"] = (effectiveDays * (1 - prayed)).round();
    }

    setState(() {
      missedPrayers = results;
    });
  }

  List<Step> getSteps() {

    return [
      Step(
        stepStyle: StepStyle(color: widget.primaryColor),
        title: const Text("Your Age"),
        content: TextField(
          decoration: InputDecoration(labelText: "Enter your current age.", hintStyle: TextStyle(color: widget.primaryColor)),
          keyboardType: TextInputType.number,
          onChanged: (val) => age = int.tryParse(val),
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        stepStyle: StepStyle(color: widget.primaryColor),
        title: const Text("Gender"),
        content: Column(
          children: [
            RadioListTile<String>(
              selectedTileColor: widget.primaryColor,
              value: "Male",
              groupValue: gender,
              title: const Text("Male"),
              onChanged: (val) => setState(() => gender = val),
            ),
            RadioListTile<String>(
              value: "Female",
              groupValue: gender,
              title: const Text("Female"),
              onChanged: (val) => setState(() => gender = val),
            ),
          ],
        ),
        isActive: _currentStep >= 1,
      ),
      Step(
        stepStyle: StepStyle(color: widget.primaryColor),
        title: const Text("Puberty Age"),
        content: TextField(
          decoration: InputDecoration(
              labelText: "At what age did you reach puberty? (default ${gender == "Female" ? 12 : 15})"),
          keyboardType: TextInputType.number,
          onChanged: (val) => balighAge = int.tryParse(val) ?? balighAge,
        ),
        isActive: _currentStep >= 2,
      ),
      if (gender == "Female")
        Step(
          stepStyle: StepStyle(color: widget.primaryColor),
          title: const Text("Menstruation Days"),
          content: TextField(
            decoration: const InputDecoration(
                labelText: "Average days of menstruation per month"),
            keyboardType: TextInputType.number,
            onChanged: (val) => periodDays = int.tryParse(val) ?? 7,
          ),
          isActive: _currentStep >= 3,
        ),
      Step(
        stepStyle: StepStyle(color: widget.primaryColor),
        title: const Text("Prayer Performance"),
        content: Column(
          children: [
            ...["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"].map((prayer) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(prayer),
                  Slider(
                    activeColor: widget.primaryColor,
                    value: prayerPerformance[prayer]!,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    label: "${prayerPerformance[prayer]!.round()}%",
                    onChanged: (val) => setState(() {
                      prayerPerformance[prayer] = val;
                    }),
                  )
                ],
              );
            }),
            SwitchListTile(
              activeColor: widget.primaryColor,
              selectedTileColor: widget.primaryColor,
              value: includeWitr,
              onChanged: (val) => setState(() => includeWitr = val),
              title: const Text("Include Witr"),
            ),
            if (includeWitr)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Witr"),
                  Slider(
                    activeColor: widget.primaryColor,
                    value: prayerPerformance["Witr"]!,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    label: "${prayerPerformance["Witr"]!.round()}%",
                    onChanged: (val) => setState(() {
                      prayerPerformance["Witr"] = val;
                    }),
                  )
                ],
              ),
          ],
        ),
        isActive: true,
      ),
      Step(
        stepStyle: StepStyle(color: widget.primaryColor),
        title: const Text("Results"),
        content: ElevatedButton(
          onPressed: calculateResults,
          child: Text("Calculate Qaza", style: TextStyle(color: widget.primaryColor),),
        ),
        isActive: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.primaryColor,
        iconTheme: IconThemeData(
          color: Colors.white, // ← Set your desired color here
        ),
        title: Text("Qaza Namaz",
          style: TextStyle(color: Colors.white),),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: Stepper(
        currentStep: _currentStep,

        // ✅ Line (connector) color
        connectorColor: MaterialStateProperty.all(widget.primaryColor),

        // ✅ Controls (Next / Back buttons)
        controlsBuilder: (context, details) {
          return Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.primaryColor, // Next button color
                ),
                onPressed: details.onStepContinue,
                child: const Text('Next', style: TextStyle(color: Colors.white),),
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: details.onStepCancel,
                child: const Text(
                  'Back',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },

        // ✅ Step icon customization (MOST IMPORTANT)
        stepIconBuilder: (stepIndex, stepState) {
          Color color;

          if (stepState == StepState.complete) {
            color = widget.primaryColor; // completed
          } else if (stepState == StepState.editing) {
            color = Colors.orange; // current
          } else {
            color = Colors.grey; // inactive
          }

          return CircleAvatar(
            backgroundColor: color,
            child: Text('${stepIndex + 1}'),
          );
        },

        onStepContinue: () {
          if (_currentStep < getSteps().length - 1) {
            setState(() => _currentStep++);
          }
        },

        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          }
        },

        steps: getSteps(),
      ),
      bottomSheet: missedPrayers.isNotEmpty
          ? Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Missed Prayers Summary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...missedPrayers.entries.map((e) => Text("${e.key}: ${e.value}")),
            const SizedBox(height: 8),
            Text("Total Days: $totalDays"),
            Text("Exempt Days: $exemptDays"),
          ],
        ),
      )
          : null,
    );
  }
}

