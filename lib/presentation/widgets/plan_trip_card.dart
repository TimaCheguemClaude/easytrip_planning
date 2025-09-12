import 'package:flutter/material.dart';
import 'package:easytrip/utils/fonts.dart';

class PlanTripCard extends StatelessWidget {
  final VoidCallback onPlanTap;
  const PlanTripCard({super.key, required this.onPlanTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 24),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          SizedBox(
            height: 220,
            width: double.infinity,
            child: Image.asset('assets/plan it.jpg', fit: BoxFit.cover),
          ),
          Positioned(
            top: 16,
            left: 24,
            right: 24,
            child: Text(
              'Ready for your next adventure?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 6,
                    color: Colors.black.withOpacity(1),
                    offset: Offset(1, 2),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: SizedBox(
              width: 80,
              height: 48,
              child: ElevatedButton(
                onPressed: onPlanTap,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: const Color(0xFFFF5722),
                  foregroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // squared
                  ),
                ),
                child: const Text(
                  'Plan your next trip',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
