import 'package:flutter/material.dart';

void main() {
  runApp(const ExcelApp());
}

class ExcelApp extends StatelessWidget {
  const ExcelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Excel Assumptions',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SpreadsheetScreen(),
      },
    );
  }
}

class SpreadsheetScreen extends StatefulWidget {
  const SpreadsheetScreen({super.key});

  @override
  State<SpreadsheetScreen> createState() => _SpreadsheetScreenState();
}

class _SpreadsheetScreenState extends State<SpreadsheetScreen> {
  // Simple data structure for our grid: 10 rows, 5 columns.
  final int rows = 15;
  final int cols = 5;

  // Cell types: 0 = Normal, 1 = Assumption (Yellow), 2 = Highlight (Green)
  late List<List<Map<String, dynamic>>> gridData;

  @override
  void initState() {
    super.initState();
    _initializeGrid();
  }

  void _initializeGrid() {
    gridData = List.generate(
      rows,
      (r) => List.generate(
        cols,
        (c) {
          int type = 0;
          String value = '';
          
          if (r == 0) {
            value = 'Col ${String.fromCharCode(65 + c)}'; // A, B, C...
          } else if (c == 0) {
            value = 'Row $r';
          } else {
            // Assign some mock data and colors
            if (r == 2 && c == 1) {
              type = 1; // Assumption
              value = '5.0%';
            } else if (r == 2 && c == 2) {
              type = 1; // Assumption
              value = '1000';
            } else if (r == 3 && c == 3) {
              type = 2; // Green
              value = 'Active';
            } else if (r == 4 && c == 1) {
              type = 1; // Assumption
              value = '24 mo';
            } else if (r == 5 && c == 4) {
              type = 2; // Green
              value = 'Verified';
            } else {
              value = '-';
            }
          }
          return {'value': value, 'type': type};
        },
      ),
    );
  }

  Color _getCellColor(int type, int r, int c) {
    if (r == 0 || c == 0) return Colors.grey.shade300; // Headers
    if (type == 1) return Colors.yellow.shade200;
    if (type == 2) return Colors.green.shade300;
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Excel Viewer'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegend(Colors.yellow.shade200, 'Assumption'),
                  const SizedBox(width: 24),
                  _buildLegend(Colors.green.shade300, 'Calculated / Valid'),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Table(
                      border: TableBorder.all(color: Colors.grey.shade400),
                      defaultColumnWidth: const FixedColumnWidth(100.0),
                      children: List.generate(
                        rows,
                        (r) => TableRow(
                          children: List.generate(
                            cols,
                            (c) {
                              final cell = gridData[r][c];
                              return Container(
                                height: 40,
                                color: _getCellColor(cell['type'], r, c),
                                alignment: Alignment.center,
                                child: Text(
                                  cell['value'],
                                  style: TextStyle(
                                    fontWeight: (r == 0 || c == 0)
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.grey),
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
