import 'package:flutter/material.dart';

class MatchCard extends StatelessWidget {
  final String homeTeam;
  final String awayTeam;
  final String time;
  final String league;
  final bool isLive;
  final VoidCallback onTap; // Nueva variable: La acción al tocar

  const MatchCard({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
    required this.time,
    required this.league,
    required this.onTap, // Ahora es obligatorio decir qué pasa al tocar
    this.isLive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Detecta el toque
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.emoji_events, size: 14, color: Colors.grey[400]),
                  const SizedBox(width: 4),
                  Text(
                    league.toUpperCase(),
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  if (isLive)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "LIVE",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Icon(Icons.shield, size: 30, color: Colors.white),
                        const SizedBox(height: 4),
                        Text(
                          homeTeam,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF121212),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Text(
                      time,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isLive ? const Color(0xFF00E676) : Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.shield_outlined,
                          size: 30,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          awayTeam,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
