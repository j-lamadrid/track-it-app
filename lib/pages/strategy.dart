import 'package:flutter/material.dart';
import 'package:track_it/pages/home.dart';

class StrategyPage extends StatefulWidget {
  const StrategyPage({super.key, required this.title});

  final String title;

  @override
  State<StrategyPage> createState() => _StrategyPage();
}

class _StrategyPage extends State<StrategyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ASE Strategies'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const MyHomePage(title: 'Home Page')),
            );
          },
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent[100]!, Colors.blueAccent[100]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent[100]!, Colors.yellow[100]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListView(
            children: [
              // Strategy 1
              _buildStrategySection(
                context,
                title: 'Strategies to Enhance Social Attention',
                icon: Icons.visibility,
                children: [
                  _buildSubStrategy('Use baby talk',
                      'Remember to speak to your child in a playful manner. '
                          'Use exaggerated intonation, simple grammar, '
                          'high pitch, and slow tempo.'),
                  _buildSubStrategy('Face to face positioning', "Children learn "
                      "by watching their parent's face. When interacting with "
                      "your child, position yourself in front of your child."),
                  _buildSubStrategy('Face directing activities', 'During playtime '
                      'engage in face-directing activities such as making faces '
                      'and exaggerating facial expressions, smiling and exaggerating '
                      'the speech sounds your child is in the process of learning. '
                      'Also engage in activities such as '
                      'peek a boo, face painting, blowing bubbles, blowing kisses, '
                      'brushing hair, and blowing up small balloons.'),
                  _buildSubStrategy('Be silly!', 'Activities do not have to be in '
                      'a set order or sequence! Have fun with your child and take '
                      'opportunities for tickling and sharing enjoyment.'),
                  _buildSubStrategy('Social routines', 'Many children enjoy '
                      'routines like "pat-a-cake" and "twinkle-twinkle". These '
                      'routines encourage verbal language, social engagement, '
                      'and nonverbal communication like gestures. Make it even '
                      'more fun by embellishing your gestures and expressions '
                      'to make it more salient for your child and encourage '
                      'social attention.'),
                  _buildSubStrategy('Play singing', 'Many children enjoy singing, '
                      'or listening to others sing. Does your child? If so, sing '
                      'while they are looking at you.'),
                ],
                  color: Colors.orangeAccent[100]
              ),
              const SizedBox(height: 16.0),

              // Strategy 2
              _buildStrategySection(
                context,
                title: 'Strategies to Enhance Turn-Taking',
                icon: Icons.loop,
                children: [
                  _buildSubStrategy('Use predictable phrases', ''),
                  _buildSubStrategy('Take short turns and accept short turns from your child', ''),
                  _buildSubStrategy('Establish turn-taking routines and games', ''),
                  _buildSubStrategy('Expand', ''),
                  _buildSubStrategy('Gentle blocking', ''),
                  _buildSubStrategy('TrackiT!', ''),
                ],
                  color: Colors.green[100]
              ),
              const SizedBox(height: 16.0),

              // Strategy 3
              _buildStrategySection(
                context,
                title: 'Strategies to Enhance Child Motivation',
                icon: Icons.lightbulb,
                children: [
                  _buildSubStrategy("Follow your child's lead", ''),
                  _buildSubStrategy('Reinforce all attempts', ''),
                  _buildSubStrategy('Imitate your child', ''),
                  _buildSubStrategy('Child choice', ''),
                ],
                  color: Colors.redAccent[100]
              ),
              const SizedBox(height: 16.0),

              // Strategy 4
              _buildStrategySection(
                context,
                title: 'Strategies to Enhance Therapy Best Practices',
                icon: Icons.handshake_rounded,
                children: [
                  _buildSubStrategy("It's a family affair", ''),
                  _buildSubStrategy("Model play that is at your child's level as well as play that is slightly in advance", ''),
                  _buildSubStrategy('Natural reinforcer', ''),
                ],
                color: Colors.deepPurple[100]
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStrategySection(BuildContext context,
      {required String title,
        required IconData icon,
        required List<Widget> children,
        required Color? color,
      }
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: color
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.black54),
              const SizedBox(width: 8.0),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildSubStrategy(String title, String description) {
    return ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontStyle: FontStyle.italic,
        ),
      ),
      children: [
        if (description.isNotEmpty)
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              description,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
          const SizedBox(height: 8),
      ],
    );
  }
}

