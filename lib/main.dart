import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const FlipClockApp());
}

class FlipClockApp extends StatelessWidget {
  const FlipClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flip Clock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const FlipClockScreen(),
    );
  }
}

class FlipClockScreen extends StatefulWidget {
  const FlipClockScreen({super.key});

  @override
  State<FlipClockScreen> createState() => _FlipClockScreenState();
}

class _FlipClockScreenState extends State<FlipClockScreen> {
  late Timer _timer;
  DateTime _currentTime = DateTime.now();

  // Settings State
  bool _is24Hour = false;
  Color _backgroundColor = const Color(0xFF0A0E27);
  Color _digitBackgroundColor = const Color(0xFF2a2e45);
  Color _digitTextColor = Colors.white;

  // New Options
  bool _playSounds = false;
  bool _showAnimation = true;
  bool _showSeconds = true;
  bool _showDate = true;

  // Date Settings
  Color _dateColor = Colors.white54;
  String _dateFont = 'Press Start 2P'; // Default font
  String _datePattern = 'EEEE, MMMM d, yyyy'; // Default pattern

  // Available Fonts for Selection
  final List<String> _availableFonts = [
    'Roboto',
    'Open Sans',
    'Lato',
    'Montserrat',
    'Oswald',
    'Raleway',
    'Lobster',
    'Pacifico',
    'Orbitron',
    'Press Start 2P',
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _is24Hour = prefs.getBool('is24Hour') ?? false;
      _backgroundColor = Color(prefs.getInt('backgroundColor') ?? 0xFF0A0E27);
      _digitBackgroundColor = Color(prefs.getInt('digitBackgroundColor') ?? 0xFF2a2e45);
      _digitTextColor = Color(prefs.getInt('digitTextColor') ?? Colors.white.value);
      _playSounds = prefs.getBool('playSounds') ?? false;
      _showAnimation = prefs.getBool('showAnimation') ?? true;
      _showSeconds = prefs.getBool('showSeconds') ?? true;
      _showDate = prefs.getBool('showDate') ?? true;
      _dateColor = Color(prefs.getInt('dateColor') ?? Colors.white54.value);
      _dateFont = prefs.getString('dateFont') ?? 'Press Start 2P';
      _datePattern = prefs.getString('datePattern') ?? 'EEEE, MMMM d, yyyy';
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      prefs.setBool(key, value);
    } else if (value is int) {
      prefs.setInt(key, value);
    } else if (value is String) {
      prefs.setString(key, value);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _onDigitFlipped() {
    if (_playSounds) {
      // Linux-specific sound playback using aplay (ALSA)
      // In development mode (flutter run), assets/flip.wav exists in the project root.
      // In release mode, paths might differ, but this is a quick fix for the missing gstreamer libs.
      
      // Determine path
      String soundPath = 'assets/flip.wav';
      File sourceFile = File(soundPath);
      
      if (sourceFile.existsSync()) {
        try {
          Process.run('aplay', ['-q', soundPath]);
        } catch (e) {
          // Ignore errors
        }
      } else {
        // Try to handle build location if needed, but for now dev mode is priority
         // In a real Linux bundle, assets are in data/flutter_assets/assets/flip.wav relative to binary
         // But here we are just running from source
      }
    }
  }

  void _pickColor(BuildContext context, String title, Color currentColor, ValueChanged<Color> onColorChanged) {
    showDialog(
      context: context,
      builder: (context) {
        Color tempColor = currentColor;
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: (color) => tempColor = color,
              labelTypes: const [],
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Got it'),
              onPressed: () {
                setState(() => onColorChanged(tempColor));
                // We'll handle saving the specific color key in the caller if needed
                // or just pass a more specific callback. 
                // For simplicity, color changes in pickers happen here.
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _digitBackgroundColor,
      isScrollControlled: true,
      builder: (context) {
        TextEditingController patternController = TextEditingController(text: _datePattern);
        
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: const EdgeInsets.all(24),
              height: MediaQuery.of(context).size.height * 0.85, 
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: Colors.white70),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                
                    // Toggles Section
                    const Text('Options', style: TextStyle(color: Colors.white70, fontSize: 18)),
                    SwitchListTile(
                      title: const Text('24-Hour Format', style: TextStyle(color: Colors.white)),
                      value: _is24Hour,
                      onChanged: (value) {
                        setState(() => _is24Hour = value);
                        _saveSetting('is24Hour', value);
                        setSheetState(() {});
                      },
                      secondary: const Icon(Icons.access_time, color: Colors.white),
                      contentPadding: EdgeInsets.zero,
                    ),
                    SwitchListTile(
                      title: const Text('Show Seconds', style: TextStyle(color: Colors.white)),
                      value: _showSeconds,
                      onChanged: (value) {
                        setState(() => _showSeconds = value);
                        _saveSetting('showSeconds', value);
                        setSheetState(() {});
                      },
                      secondary: const Icon(Icons.timer, color: Colors.white),
                      contentPadding: EdgeInsets.zero,
                    ),
                    SwitchListTile(
                      title: const Text('Show Date', style: TextStyle(color: Colors.white)),
                      value: _showDate,
                      onChanged: (value) {
                        setState(() => _showDate = value);
                        _saveSetting('showDate', value);
                        setSheetState(() {});
                      },
                      secondary: const Icon(Icons.calendar_today, color: Colors.white),
                      contentPadding: EdgeInsets.zero,
                    ),
                    SwitchListTile(
                      title: const Text('Flip Animation', style: TextStyle(color: Colors.white)),
                      value: _showAnimation,
                      onChanged: (value) {
                        setState(() => _showAnimation = value);
                        _saveSetting('showAnimation', value);
                        setSheetState(() {});
                      },
                      secondary: const Icon(Icons.animation, color: Colors.white),
                      contentPadding: EdgeInsets.zero,
                    ),
                     SwitchListTile(
                      title: const Text('Flip Sound', style: TextStyle(color: Colors.white)),
                      value: _playSounds,
                      onChanged: (value) {
                        setState(() => _playSounds = value);
                        _saveSetting('playSounds', value);
                        setSheetState(() {});
                      },
                      secondary: const Icon(Icons.volume_up, color: Colors.white),
                      contentPadding: EdgeInsets.zero,
                    ),

                    const Divider(color: Colors.white24),
                
                    // Colors Section
                    const Text('Colors', style: TextStyle(color: Colors.white70, fontSize: 18)),
                    const SizedBox(height: 10),
                
                    ListTile(
                      title: const Text('App Background', style: TextStyle(color: Colors.white)),
                      trailing: CircleAvatar(backgroundColor: _backgroundColor),
                      onTap: () => _pickColor(context, 'Pick Background Color', _backgroundColor, (c) {
                        _backgroundColor = c;
                        _saveSetting('backgroundColor', c.value);
                        setSheetState(() {});
                      }),
                      contentPadding: EdgeInsets.zero,
                    ),
                    ListTile(
                      title: const Text('Digit Background', style: TextStyle(color: Colors.white)),
                      trailing: CircleAvatar(backgroundColor: _digitBackgroundColor),
                      onTap: () => _pickColor(context, 'Pick Digit Background', _digitBackgroundColor, (c) {
                        _digitBackgroundColor = c;
                        _saveSetting('digitBackgroundColor', c.value);
                        setSheetState(() {});
                      }),
                      contentPadding: EdgeInsets.zero,
                    ),
                    ListTile(
                      title: const Text('Digit Text', style: TextStyle(color: Colors.white)),
                      trailing: CircleAvatar(backgroundColor: _digitTextColor),
                      onTap: () => _pickColor(context, 'Pick Digit Text Color', _digitTextColor, (c) {
                        _digitTextColor = c;
                        _saveSetting('digitTextColor', c.value);
                        setSheetState(() {});
                      }),
                      contentPadding: EdgeInsets.zero,
                    ),
                
                    const Divider(color: Colors.white24),
                    const Text('Date Settings', style: TextStyle(color: Colors.white70, fontSize: 18)),
                    const SizedBox(height: 10),
                
                     ListTile(
                      title: const Text('Date Color', style: TextStyle(color: Colors.white)),
                      trailing: CircleAvatar(backgroundColor: _dateColor),
                      onTap: () => _pickColor(context, 'Pick Date Color', _dateColor, (c) {
                        _dateColor = c;
                        _saveSetting('dateColor', c.value);
                        setSheetState(() {});
                      }),
                      contentPadding: EdgeInsets.zero,
                    ),
                    
                    const SizedBox(height: 10),
                    const Text('Date Font', style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: _availableFonts.contains(_dateFont) ? _dateFont : _availableFonts.first,
                        dropdownColor: _digitBackgroundColor,
                        isExpanded: true,
                        underline: const SizedBox(),
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        items: _availableFonts.map((String font) {
                          return DropdownMenuItem<String>(
                            value: font,
                            child: Text(
                              font, 
                              style: GoogleFonts.getFont(font),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() => _dateFont = newValue);
                            _saveSetting('dateFont', newValue);
                            setSheetState(() {});
                          }
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 15),
                    const Text('Date Format Pattern', style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 5),
                    TextField(
                      controller: patternController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'e.g. MM/dd/yyyy',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                         setState(() => _datePattern = value);
                         _saveSetting('datePattern', value);
                         // No setSheetState needed for this text field itself, but good for preview
                      },
                    ),
                    const SizedBox(height: 5),
                    const Text('Common patterns: EEEE, MM/dd/yyyy, yyyy-MM-dd', style: TextStyle(color: Colors.white30, fontSize: 12)),
                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int hour = _currentTime.hour;
    if (!_is24Hour) {
      hour = hour > 12 ? hour - 12 : hour;
      if (hour == 0) hour = 12;
    }

    final hourStr = hour.toString().padLeft(2, '0');
    final minuteStr = _currentTime.minute.toString().padLeft(2, '0');
    final secondStr = _currentTime.second.toString().padLeft(2, '0');

    TextStyle dateStyle = GoogleFonts.getFont(
      _dateFont,
      fontSize: 18,
      fontWeight: FontWeight.w300,
      color: _dateColor,
    ).copyWith(letterSpacing: 2);

    return Scaffold(
      backgroundColor: _backgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: _showSettings,
        backgroundColor: Colors.white.withOpacity(0.1),
        child: const Icon(Icons.settings, color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0), // Padding to prevent edge touching
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // Hug content vertically
            children: [
              // Time Display - SCALES DOWN, NO WRAPPING
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Hours
                    FlipDigitGroup(
                      value: hourStr,
                      backgroundColor: _digitBackgroundColor,
                      textColor: _digitTextColor,
                      animate: _showAnimation,
                      onFlip: _onDigitFlipped,
                    ),
                    
                    TimeSeparator(color: _digitTextColor),
                    
                    // Minutes
                    FlipDigitGroup(
                      value: minuteStr,
                      backgroundColor: _digitBackgroundColor,
                      textColor: _digitTextColor,
                      animate: _showAnimation,
                      onFlip: _onDigitFlipped,
                    ),
                    
                    // Seconds (Optional)
                    if (_showSeconds) ...[
                      TimeSeparator(color: _digitTextColor),
                      FlipDigitGroup(
                        value: secondStr,
                        backgroundColor: _digitBackgroundColor,
                        textColor: _digitTextColor,
                        animate: _showAnimation,
                        onFlip: _onDigitFlipped,
                      ),
                    ],
                  ],
                ),
              ),
              
              if (_showDate) ...[
                const SizedBox(height: 60),
                
                // Date Display - ALLOWS WRAPPING, SCALES IF NEEDED
                Flexible( // Flexible allows it to take space but shrink/wrap
                  child: Text(
                    _formatDate(_currentTime),
                    style: dateStyle,
                    textAlign: TextAlign.center, // Center aligned when wrapped
                    softWrap: true, // Allow wrapping
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    try {
      return DateFormat(_datePattern).format(date);
    } catch (e) {
      return 'Invalid Pattern';
    }
  }
}

class FlipDigitGroup extends StatelessWidget {
  final String value;
  final Color backgroundColor;
  final Color textColor;
  final bool animate;
  final VoidCallback? onFlip;

  const FlipDigitGroup({
    super.key,
    required this.value,
    required this.backgroundColor,
    required this.textColor,
    required this.animate,
    this.onFlip,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FlipDigit(
          digit: value[0],
          backgroundColor: backgroundColor,
          textColor: textColor,
          animate: animate,
          onFlip: onFlip,
        ),
        const SizedBox(width: 8),
        FlipDigit(
          digit: value[1],
          backgroundColor: backgroundColor,
          textColor: textColor,
          animate: animate,
          onFlip: onFlip,
        ),
      ],
    );
  }
}

class FlipDigit extends StatefulWidget {
  final String digit;
  final Color backgroundColor;
  final Color textColor;
  final bool animate;
  final VoidCallback? onFlip;

  const FlipDigit({
    super.key,
    required this.digit,
    required this.backgroundColor,
    required this.textColor,
    required this.animate,
    this.onFlip,
  });

  @override
  State<FlipDigit> createState() => _FlipDigitState();
}

class _FlipDigitState extends State<FlipDigit> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String _currentDigit = '';
  String _nextDigit = '';

  @override
  void initState() {
    super.initState();
    _currentDigit = widget.digit;
    _nextDigit = widget.digit;
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
    );
    
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _currentDigit = _nextDigit;
          _controller.reset();
        });
      }
    });
  }

  @override
  void didUpdateWidget(FlipDigit oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.digit != widget.digit) {
      _nextDigit = widget.digit;
      if (widget.animate) {
        _controller.forward(from: 0.0);
        widget.onFlip?.call();
      } else {
        // No animation, just update
        setState(() {
          _currentDigit = _nextDigit;
        });
        // We might still want sound? "turning the sound of the digits flipping".
        // If it doesn't flip, does it make sound? Likely no. The sound is the mechanical flip.
        // So no sound if no animation.
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.animate || (!_controller.isAnimating && _currentDigit == _nextDigit)) {
      return _buildStaticDigit(_currentDigit);
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final double angle = _animation.value * math.pi;
        final bool isTopHalf = angle < math.pi / 2;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Half Area
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                _buildHalfDigit(digit: _nextDigit, isTop: true),
                if (isTopHalf)
                  Transform(
                    alignment: Alignment.bottomCenter,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.003)
                      ..rotateX(-angle),
                    child: _buildHalfDigit(
                      digit: _currentDigit,
                      isTop: true,
                      isAnimated: true,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2), // The Hinge Gap
            // Bottom Half Area
            Stack(
              alignment: Alignment.topCenter,
              children: [
                _buildHalfDigit(digit: _currentDigit, isTop: false),
                if (!isTopHalf)
                  Transform(
                    alignment: Alignment.topCenter,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.003)
                      ..rotateX(math.pi - angle),
                    child: _buildHalfDigit(
                      digit: _nextDigit,
                      isTop: false,
                      isAnimated: true,
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildStaticDigit(String digit) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHalfDigit(digit: digit, isTop: true),
        const SizedBox(height: 2), // The Hinge Gap
        _buildHalfDigit(digit: digit, isTop: false),
      ],
    );
  }

  Widget _buildHalfDigit({
    required String digit,
    required bool isTop,
    bool isAnimated = false,
  }) {
    return ClipRect(
      child: Align(
        alignment: isTop ? Alignment.topCenter : Alignment.bottomCenter,
        heightFactor: 0.5,
        child: Container(
          width: 80,
          height: 120,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                isTop ? widget.backgroundColor : widget.backgroundColor.withOpacity(0.85),
                isTop ? widget.backgroundColor.withOpacity(0.85) : widget.backgroundColor,
              ],
            ),
            boxShadow: [
               BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: isAnimated ? 4 : 8,
                  offset: isAnimated ? const Offset(0, 2) : const Offset(0, 4),
               )
            ],
          ),
          child: Stack(
            children: [
              Center(
                child: Text(
                  digit,
                  style: TextStyle(
                    fontSize: 84,
                    fontWeight: FontWeight.bold,
                    color: widget.textColor,
                    height: 1.0,
                  ),
                ),
              ),
              // Subtle Inner Shadow at the hinge for depth
              Positioned(
                bottom: isTop ? 0 : null,
                top: !isTop ? 0 : null,
                left: 0,
                right: 0,
                child: Container(
                  height: 1.5,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TimeSeparator extends StatelessWidget {
  final Color color;
  
  const TimeSeparator({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 100,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _dot(),
          const SizedBox(height: 20),
          _dot(),
        ],
      ),
    );
  }
  
  Widget _dot() {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 8,
          ),
        ],
      ),
    );
  }
}
