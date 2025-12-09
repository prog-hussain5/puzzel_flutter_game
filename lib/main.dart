import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:ui' as ui;

void main() {
  runApp(const FriendsPuzzleApp());
}

// CustomClipper for jigsaw puzzle pieces
class JigsawPieceClipper extends CustomClipper<Path> {
  final int row;
  final int col;
  final int totalRows;
  final int totalCols;

  JigsawPieceClipper({
    required this.row,
    required this.col,
    required this.totalRows,
    required this.totalCols,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    
    // We assume the widget size includes padding for the tabs.
    // The "inner" cell size is 2/3 of the total widget size (since we add 0.25 padding on both sides = 0.5 extra, total 1.5)
    // So cell = size / 1.5
    final cellW = size.width / 1.5;
    final cellH = size.height / 1.5;
    
    final offsetX = (size.width - cellW) / 2;
    final offsetY = (size.height - cellH) / 2;

    final neckWidth = cellW * 0.2; // Width of the tab neck
    final tabRadius = cellW * 0.15; // Radius of the tab head

    // Determine tab directions
    // We need consistent directions for shared edges.
    // Horizontal edges (between row and row+1):
    // If _isTabPointingDown(row, col) is true, the tab points DOWN (from row to row+1).
    // Vertical edges (between col and col+1):
    // If _isTabPointingRight(row, col) is true, the tab points RIGHT (from col to col+1).

    final topPointingDown = row > 0 ? _isTabPointingDown(row - 1, col) : false;
    final bottomPointingDown = row < totalRows - 1 ? _isTabPointingDown(row, col) : false;
    final leftPointingRight = col > 0 ? _isTabPointingRight(row, col - 1) : false;
    final rightPointingRight = col < totalCols - 1 ? _isTabPointingRight(row, col) : false;

    // If top tab points down (into me), I have an indentation (IN).
    // If top tab points up (away from me), I have a protrusion (OUT).
    final topOut = !topPointingDown;

    // If bottom tab points down (away from me), I have a protrusion (OUT).
    final bottomOut = bottomPointingDown;

    // If left tab points right (into me), I have an indentation (IN).
    final leftOut = !leftPointingRight;

    // If right tab points right (away from me), I have a protrusion (OUT).
    final rightOut = rightPointingRight;

    // Start at top-left of the cell (shifted by offset)
    path.moveTo(offsetX, offsetY);

    // Top edge
    if (row > 0) {
      final midX = offsetX + cellW / 2;
      path.lineTo(midX - neckWidth / 2, offsetY);
      if (topOut) {
        path.cubicTo(
          midX - neckWidth, offsetY - tabRadius,
          midX + neckWidth, offsetY - tabRadius,
          midX + neckWidth / 2, offsetY,
        );
      } else {
        path.cubicTo(
          midX - neckWidth, offsetY + tabRadius,
          midX + neckWidth, offsetY + tabRadius,
          midX + neckWidth / 2, offsetY,
        );
      }
    }
    path.lineTo(offsetX + cellW, offsetY);

    // Right edge
    if (col < totalCols - 1) {
      final midY = offsetY + cellH / 2;
      path.lineTo(offsetX + cellW, midY - neckWidth / 2);
      if (rightOut) {
        path.cubicTo(
          offsetX + cellW + tabRadius, midY - neckWidth,
          offsetX + cellW + tabRadius, midY + neckWidth,
          offsetX + cellW, midY + neckWidth / 2,
        );
      } else {
        path.cubicTo(
          offsetX + cellW - tabRadius, midY - neckWidth,
          offsetX + cellW - tabRadius, midY + neckWidth,
          offsetX + cellW, midY + neckWidth / 2,
        );
      }
    }
    path.lineTo(offsetX + cellW, offsetY + cellH);

    // Bottom edge
    if (row < totalRows - 1) {
      final midX = offsetX + cellW / 2;
      path.lineTo(midX + neckWidth / 2, offsetY + cellH);
      if (bottomOut) {
        path.cubicTo(
          midX + neckWidth, offsetY + cellH + tabRadius,
          midX - neckWidth, offsetY + cellH + tabRadius,
          midX - neckWidth / 2, offsetY + cellH,
        );
      } else {
        path.cubicTo(
          midX + neckWidth, offsetY + cellH - tabRadius,
          midX - neckWidth, offsetY + cellH - tabRadius,
          midX - neckWidth / 2, offsetY + cellH,
        );
      }
    }
    path.lineTo(offsetX, offsetY + cellH);

    // Left edge
    if (col > 0) {
      final midY = offsetY + cellH / 2;
      path.lineTo(offsetX, midY + neckWidth / 2);
      if (leftOut) {
        path.cubicTo(
          offsetX - tabRadius, midY + neckWidth,
          offsetX - tabRadius, midY - neckWidth,
          offsetX, midY - neckWidth / 2,
        );
      } else {
        path.cubicTo(
          offsetX + tabRadius, midY + neckWidth,
          offsetX + tabRadius, midY - neckWidth,
          offsetX, midY - neckWidth / 2,
        );
      }
    }
    path.close();
    return path;
  }

  bool _isTabPointingDown(int r, int c) {
    // Deterministic random direction for horizontal edge between r and r+1
    return ((r * 7 + c * 13) % 2) == 0;
  }

  bool _isTabPointingRight(int r, int c) {
    // Deterministic random direction for vertical edge between c and c+1
    return ((r * 17 + c * 23) % 2) == 0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class FriendsPuzzleApp extends StatelessWidget {
  const FriendsPuzzleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'لعبة الأصدقاء',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal[700]!),
        useMaterial3: true,
        fontFamily: 'Arial',
      ),
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const PuzzleGamePage(),
    );
  }
}

class PuzzlePiece {
  final int id;
  final int row;
  final int col;
  bool isPlaced;

  PuzzlePiece({
    required this.id,
    required this.row,
    required this.col,
    this.isPlaced = false,
  });
}

class JigsawPieceWidget extends StatelessWidget {
  final String imagePath;
  final int row;
  final int col;
  final int totalRows;
  final int totalCols;
  final double size; // This is the full widget size (including padding)

  const JigsawPieceWidget({
    super.key,
    required this.imagePath,
    required this.row,
    required this.col,
    required this.totalRows,
    required this.totalCols,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.Image>(
      future: _loadImage(context, imagePath),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(
            width: size,
            height: size,
            child: const Center(child: SizedBox()),
          );
        }

        return CustomPaint(
          size: Size(size, size),
          painter: _ImagePiecePainter(
            image: snapshot.data!,
            row: row,
            col: col,
            totalRows: totalRows,
            totalCols: totalCols,
          ),
        );
      },
    );
  }

  Future<ui.Image> _loadImage(BuildContext context, String path) async {
    final data = await DefaultAssetBundle.of(context).load(path);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    return frame.image;
  }
}

class _ImagePiecePainter extends CustomPainter {
  final ui.Image image;
  final int row;
  final int col;
  final int totalRows;
  final int totalCols;

  _ImagePiecePainter({
    required this.image,
    required this.row,
    required this.col,
    required this.totalRows,
    required this.totalCols,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate the base cell size in the image
    final imageCellW = image.width / totalCols;
    final imageCellH = image.height / totalRows;

    // We want to grab a larger area from the image to account for tabs.
    // The widget size corresponds to 1.5x the cell size (0.25 padding on each side).
    // So we should grab 1.5x the cell size from the image, centered on the cell.
    
    final srcX = (col * imageCellW) - (imageCellW * 0.25);
    final srcY = (row * imageCellH) - (imageCellH * 0.25);
    final srcW = imageCellW * 1.5;
    final srcH = imageCellH * 1.5;

    final fullSrcRect = Rect.fromLTWH(srcX, srcY, srcW, srcH);
    final imageRect = Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    
    // Intersect to avoid reading outside image bounds
    final visibleSrcRect = fullSrcRect.intersect(imageRect);

    // Map the visible part of the source to the destination
    // Calculate scale factors
    final scaleX = size.width / srcW;
    final scaleY = size.height / srcH;

    final dstLeft = (visibleSrcRect.left - fullSrcRect.left) * scaleX;
    final dstTop = (visibleSrcRect.top - fullSrcRect.top) * scaleY;
    final dstWidth = visibleSrcRect.width * scaleX;
    final dstHeight = visibleSrcRect.height * scaleY;

    final dstRect = Rect.fromLTWH(dstLeft, dstTop, dstWidth, dstHeight);

    canvas.drawImageRect(image, visibleSrcRect, dstRect, Paint());
  }

  @override
  bool shouldRepaint(_ImagePiecePainter oldDelegate) => false;
}

class PuzzleGamePage extends StatefulWidget {
  const PuzzleGamePage({super.key});

  @override
  State<PuzzleGamePage> createState() => _PuzzleGamePageState();
}

class _PuzzleGamePageState extends State<PuzzleGamePage> {
  final int rows = 3;
  final int cols = 3;
  final String fullImagePath = 'assets/images/friends_full.png';
  late List<PuzzlePiece> pieces;
  bool isGameComplete = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    pieces = List.generate(9, (index) {
      final row = index ~/ cols;
      final col = index % cols;
      return PuzzlePiece(
        id: index,
        row: row,
        col: col,
        isPlaced: false,
      );
    });
    isGameComplete = false;
    setState(() {});
  }

  void _onPiecePlaced(int pieceId, int targetIndex) {
    if (pieceId == targetIndex) {
      setState(() {
        pieces[pieceId].isPlaced = true;
        _checkWinCondition();
      });
    }
  }

  void _checkWinCondition() {
    if (pieces.every((p) => p.isPlaced)) {
      setState(() {
        isGameComplete = true;
      });
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('أحسنت!'),
        content: const Text('لقد أكملت الصورة بنجاح.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _initializeGame();
            },
            child: const Text('العب مرة أخرى'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لعبة تركيب الصور'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initializeGame,
            tooltip: 'إعادة اللعب',
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isLandscape = constraints.maxWidth > constraints.maxHeight;
          if (isLandscape) {
            return _buildLandscapeLayout();
          } else {
            return _buildPortraitLayout();
          }
        },
      ),
    );
  }

  Widget _buildPortraitLayout() {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              children: [             
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: _buildBoard(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(height: 1, thickness: 2),
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.grey.shade100,
            child: _buildPiecesTray(),
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('الصورة الأصلية', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Expanded(
                  child: Image.asset(
                    fullImagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (c, o, s) => const Center(child: Icon(Icons.image, size: 65, color: Colors.grey)),
                  ),
                ),
              ],
            ),
          ),
        ),
        const VerticalDivider(width: 1, thickness: 2),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: AspectRatio(aspectRatio: 1, child: _buildBoard())),
          ),
        ),
        const VerticalDivider(width: 1, thickness: 2),
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.grey.shade100,
            child: _buildPiecesTray(),
          ),
        ),
      ],
    );
  }

  Widget _buildBoard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boardSize = constraints.maxWidth;
        final cellSize = boardSize / cols;
        
        // The widget size is 1.5x the cell size to allow for tabs
        final widgetSize = cellSize * 1.5;
        final offset = cellSize * 0.25;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Background Guide Image (Faint)
            Positioned.fill(
              child: Opacity(
                opacity: 0.25,
                child: Image.asset(
                  fullImagePath,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            
            // Grid Slots (Drop Targets)
            ...List.generate(rows * cols, (index) {
              final row = index ~/ cols;
              final col = index % cols;
              return Positioned(
                left: col * cellSize,
                top: row * cellSize,
                width: cellSize,
                height: cellSize,
                child: _buildDropTarget(index),
              );
            }),

            // Placed Pieces
            ...pieces.where((p) => p.isPlaced).map((p) {
              return Positioned(
                left: (p.col * cellSize) - offset,
                top: (p.row * cellSize) - offset,
                width: widgetSize,
                height: widgetSize,
                child: IgnorePointer(
                  child: ClipPath(
                    clipper: JigsawPieceClipper(
                      row: p.row,
                      col: p.col,
                      totalRows: rows,
                      totalCols: cols,
                    ),
                    child: JigsawPieceWidget(
                      imagePath: fullImagePath,
                      row: p.row,
                      col: p.col,
                      totalRows: rows,
                      totalCols: cols,
                      size: widgetSize,
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildDropTarget(int index) {
    final piece = pieces[index];
    
    return DragTarget<int>(
      onWillAcceptWithDetails: (details) => !piece.isPlaced,
      onAcceptWithDetails: (details) {
        _onPiecePlaced(details.data, index);
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          decoration: BoxDecoration(
            color: candidateData.isNotEmpty 
              ? Colors.blue.withValues(alpha: 0.1) 
              : Colors.transparent,
            border: candidateData.isNotEmpty
              ? Border.all(color: Colors.blue, width: 1)
              : null,
          ),
        );
      },
    );
  }

  Widget _buildPiecesTray() {
    final unplacedPieces = pieces.where((p) => !p.isPlaced).toList();
    final displayPieces = List<PuzzlePiece>.from(unplacedPieces)..shuffle();

    if (displayPieces.isEmpty) {
      return const Center(
        child: Text(
          'أحسنت! اكتملت الصورة.',
          style: TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 120,
        childAspectRatio: 1.0,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: displayPieces.length,
      itemBuilder: (context, index) {
        final piece = displayPieces[index];
        
        const trayPieceSize = 100.0;
        const feedbackSize = 130.0; // Bigger size when dragging
        
        return Draggable<int>(
          data: piece.id,
          feedback: Material(
            color: Colors.transparent,
            child: SizedBox(
              width: feedbackSize,
              height: feedbackSize,
              child: ClipPath(
                clipper: JigsawPieceClipper(
                  row: piece.row,
                  col: piece.col,
                  totalRows: rows,
                  totalCols: cols,
                ),
                child: JigsawPieceWidget(
                  imagePath: fullImagePath,
                  row: piece.row,
                  col: piece.col,
                  totalRows: rows,
                  totalCols: cols,
                  size: feedbackSize,
                ),
              ),
            ),
          ),
          childWhenDragging: Opacity(
            opacity: 0.2,
            child: SizedBox(
              width: trayPieceSize,
              height: trayPieceSize,
              child: ClipPath(
                clipper: JigsawPieceClipper(
                  row: piece.row,
                  col: piece.col,
                  totalRows: rows,
                  totalCols: cols,
                ),
                child: JigsawPieceWidget(
                  imagePath: fullImagePath,
                  row: piece.row,
                  col: piece.col,
                  totalRows: rows,
                  totalCols: cols,
                  size: trayPieceSize,
                ),
              ),
            ),
          ),
          child: Tooltip(
            message: 'قطعة ${piece.id + 1}',
            child: SizedBox(
              width: trayPieceSize,
              height: trayPieceSize,
              child: ClipPath(
                clipper: JigsawPieceClipper(
                  row: piece.row,
                  col: piece.col,
                  totalRows: rows,
                  totalCols: cols,
                ),
                child: JigsawPieceWidget(
                  imagePath: fullImagePath,
                  row: piece.row,
                  col: piece.col,
                  totalRows: rows,
                  totalCols: cols,
                  size: trayPieceSize,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
