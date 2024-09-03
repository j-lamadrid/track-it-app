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
            Navigator.pop(context);
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
              _buildStrategySection(context,
                  title: 'Strategies to Enhance Social Attention',
                  icon: Icons.visibility,
                  children: [
                    _buildSubStrategy(
                        'Use baby talk',
                        'Remember to speak to your child in a playful manner. '
                            'Use exaggerated intonation, simple grammar, '
                            'high pitch, and slow tempo.',
                        ''),
                    _buildSubStrategy(
                        'Face to face positioning',
                        "Children learn "
                            "by watching their parent's face. When interacting with "
                            "your child, position yourself in front of your child.",
                        ''),
                    _buildSubStrategy(
                        'Face directing activities',
                        'During playtime '
                            'engage in face-directing activities such as making faces '
                            'and exaggerating facial expressions, smiling and exaggerating '
                            'the speech sounds your child is in the process of learning.',
                        'Peek a boo\nFace painting\nBlowing bubbles\n'
                            'Blowing kisses\nBrushing hair\nBlowing up '
                            'small balloons'),
                    _buildSubStrategy(
                        'Be silly!',
                        'Activities do not have to be in '
                            'a set order or sequence! Have fun with your child and take '
                            'opportunities for tickling and sharing enjoyment.',
                        ''),
                    _buildSubStrategy(
                        'Social routines',
                        'Many children enjoy '
                            'routines like "pat-a-cake" and "twinkle-twinkle". These '
                            'routines encourage verbal language, social engagement, '
                            'and nonverbal communication like gestures. Make it even '
                            'more fun by embellishing your gestures and expressions '
                            'to make it more salient for your child and encourage '
                            'social attention.',
                        'Itsy Bitsy Spider\nWheels on the bus\nPat a cake'),
                    _buildSubStrategy(
                        'Play singing',
                        'Many children enjoy singing, '
                            'or listening to others sing. Does your child? If so, sing '
                            'while they are looking at you.',
                        ''),
                  ],
                  color: Colors.orangeAccent[100]),
              const SizedBox(height: 16.0),

              // Strategy 2
              _buildStrategySection(context,
                  title: 'Strategies to Enhance Turn-Taking',
                  icon: Icons.loop,
                  children: [
                    _buildSubStrategy(
                        'Use predictable phrases',
                        'Establishing predictable '
                            "routines with turn-taking and using predictable phrases "
                            "will help your child anticipate what is expected next "
                            "This will boost your child's confidence and success "
                            "in turn-taking.",
                        '"My turn. Your turn!"\n"You go. I go!"'),
                    _buildSubStrategy(
                        'Take short turns and accept short turns from your child',
                        "When you first start turn-taking, expect that your child's "
                            "turn will be short. To support your child in feeling "
                            "successful, treat any sound, look or gesture as your "
                            "child's turn. Make sure to pause long enough to allow "
                            "your child to engage in any action that could constitute "
                            "a turn and make sure to take a turn that is no more than "
                            "twice the length of your child's turn.",
                        ''),
                    _buildSubStrategy(
                        'Establish turn-taking routines and games',
                        "Watch what "
                            "activities your child likes to do and make a game out of "
                            "it.",
                        'Pushing a ball back and forth\nStacking thick Lego blocks\n'
                            'Dropping objects into a cup'),
                    _buildSubStrategy(
                        'Expand',
                        "Use initial routines as a foundation "
                            "and expand activites by adding on new routines. This will "
                            "increase your child's length of social attention, social "
                            "interest, and communication behaviors.",
                        ''),
                    _buildSubStrategy(
                        'Gentle blocking',
                        "Playfully block access "
                            "to a toy by holding it out of reach or covering it with "
                            "your hand to increase your child's eye contact and shared "
                            'enjoyment. Make it fun by using a funny noise, like "ah!" '
                            'or "ope!" during blocking. Try to wait until your child '
                            'uses eye contact with or without a word or word attempt '
                            'to take her turn.',
                        ''),
                    _buildSubStrategy(
                        'TrackiT!',
                        "Look at your app daily in the "
                            "'Trends' section to know how often you are successfully "
                            "taking turns with your child and try to increase your turn "
                            "taking number by at least 2.",
                        ''),
                  ],
                  color: Colors.green[100]),
              const SizedBox(height: 16.0),

              // Strategy 3
              _buildStrategySection(context,
                  title: 'Strategies to Enhance Child Motivation',
                  icon: Icons.lightbulb,
                  children: [
                    _buildSubStrategy(
                        "Follow your child's lead",
                        'Children will '
                            'be more motivated to interact if they are engaging in '
                            'activities that they are interested in.',
                        ''),
                    _buildSubStrategy(
                        'Reinforce all attempts',
                        'A primary goal '
                            'is to encourage your child and keep them motivated and '
                            'engaged; so it is important to reinforce any attempt at '
                            'social engagement, talk, play, or responding to a prompt '
                            'or instruction.',
                        ''),
                    _buildSubStrategy(
                        'Imitate your child',
                        'Many children enjoy '
                            'being copied, and imitating your child sends the message '
                            'that their actions, sounds, and words have meaning to others.',
                        ''),
                    _buildSubStrategy('Child choice', '', ''),
                  ],
                  color: Colors.redAccent[100]),
              const SizedBox(height: 16.0),

              // Strategy 4
              _buildStrategySection(context,
                  title: 'Strategies to Enhance Therapy',
                  icon: Icons.handshake_rounded,
                  children: [
                    _buildSubStrategy("It's a family affair", '', ''),
                    _buildSubStrategy(
                        "Model play that is at your child's level as "
                            "well as play that is slightly in advance",
                        '',
                        ''),
                    _buildSubStrategy('Natural reinforcer', '', ''),
                  ],
                  color: Colors.deepPurple[100]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStrategySection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
    required Color? color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 140.0,
          width: 140.0,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              const SizedBox(
                height: 8.0,
              ),
              Icon(
                icon,
                color: Colors.black54,
                size: 28.0,
              ),
              const SizedBox(
                height: 4.0,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                textHeightBehavior: const TextHeightBehavior(
                    leadingDistribution: TextLeadingDistribution.even),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 16.0,
        ),
        ...children,
      ],
    );
  }

  Widget _buildSubStrategy(String title, String description, String examples) {
    return ExpansionTile(
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      backgroundColor: Colors.white24,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontStyle: FontStyle.italic,
        ),
      ),
      children: [
        if (description.isNotEmpty) ...[
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
        if (examples.isNotEmpty) ...[
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Examples:',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              examples,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
          const SizedBox(height: 8),
        ]
      ],
    );
  }
}
