import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'mcdata.dart';


void main() {
  runApp(const MyApp());
}
class Block {
  final String name;
  final String id;
  int count = 0;
  Block({required this.name, required this.id});
}

class BlockTracker {
  Map<String, int> blockCounts = {};
  List<int> previousBlockCounts = [];

  //List<Block> availableBlocks = <Block>[];
  List<Block> availableBlocks = [
    Block(name: 'Dirt', id: 'minecraft:dirt'),
    Block(name: 'Stone', id: 'minecraft:stone'),
    // Add more blocks as needed
  ];

  BlockTracker() {
    fetchBlocksFromAPI();
  }

  fetchBlocksFromAPI()  async {
    final response = await http
        .get(Uri.parse('https://raw.githubusercontent.com/PrismarineJS/minecraft-data/master/data/pc/1.9/blocks.json'));
    print("Response status = "+response.statusCode.toString());
    //print("Response body = "+response.body);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      print("Parsing block data");
      List<Mcdata>  blcokList = mcdataFromJson(response.body);
      print("Number of blocks = "+blcokList.length.toString());
      for (Mcdata mcBlock in blcokList) {
        availableBlocks.add(new Block(name: mcBlock.name, id: mcBlock.id.toString()) );
      }
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load teams');
    }
  }

  void addBlock(Block block) {
    final blockId = block.id;
    blockCounts[blockId] = (blockCounts[blockId] ?? 0) + 1;
  }

  void saveBlockCounts() {
    previousBlockCounts.add(blockCounts.values.reduce((a, b) => a + b));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {

      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final BlockTracker blockTracker = BlockTracker();
    return Scaffold(
      appBar: AppBar(
        title: Text('Minecraft Block Tracker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<Block>(
              value: null,
              items: blockTracker.availableBlocks.map((Block block) {
                return DropdownMenuItem<Block>(
                  value: block,
                  child: Row(
                    children: [
                      Text(block.name),
                      Text(" --- count: "),
                      Text(block.count.toString()),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (Block? selectedBlock) {
                if (selectedBlock != null) {
                  blockTracker.addBlock(selectedBlock);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${selectedBlock.name} added!'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 20),
            Text(
              'Current Block Counts:',
              style: TextStyle(fontSize: 18),
            ),
            for (var entry in blockTracker.blockCounts.entries)
              Text('${entry.key}: ${entry.value}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                blockTracker.saveBlockCounts();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Block counts saved!'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: Text('Save Block Counts'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Previous Block Counts'),
                      content: Column(
                        children: [
                          for (var count in blockTracker.previousBlockCounts)
                            Text('Count: $count'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Show Previous Counts'),
            ),
          ],
        ),
      ),
    );
  }
}
