import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fcm_topic_notifications/services/firebase_messaging_service.dart';
import 'package:flutter_fcm_topic_notifications/services/api_service.dart';

class TokenNotificationPage extends StatefulWidget {
  const TokenNotificationPage({super.key});

  @override
  State<TokenNotificationPage> createState() => _TokenNotificationPageState();
}

class _TokenNotificationPageState extends State<TokenNotificationPage> {
  // Constants
  static const double _pagePadding = 20.0;
  static const double _cardPadding = 20.0;
  static const double _cardBorderRadius = 20.0;
  static const double _iconContainerPadding = 10.0;
  static const double _iconContainerBorderRadius = 12.0;
  static const double _iconSize = 24.0;
  static const double _spacingSmall = 8.0;
  static const double _spacingMedium = 12.0;
  static const double _spacingLarge = 16.0;
  static const double _spacingXLarge = 20.0;
  static const double _spacingXXLarge = 24.0;
  static const double _inputBorderRadius = 14.0;
  static const double _inputHorizontalPadding = 16.0;
  static const double _inputVerticalPadding = 16.0;
  static const double _inputBorderWidth = 2.0;
  static const double _inputBorderOpacity = 0.2;
  static const double _buttonHeight = 56.0;
  static const double _buttonBorderRadius = 14.0;
  static const double _buttonElevation = 3.0;
  static const double _buttonIconSize = 22.0;
  static const double _loadingIndicatorSize = 24.0;
  static const double _loadingIndicatorStrokeWidth = 2.5;
  static const double _shadowBlurRadius = 20.0;
  static const double _shadowOffsetY = 10.0;
  static const double _shadowOpacity = 0.1;
  static const double _cardShadowOpacity = 0.05;
  static const double _gradientOpacity = 0.7;
  static const double _textOpacityLabel = 0.7;
  static const double _textOpacityHint = 0.4;
  static const double _fontSizeSmall = 13.0;
  static const double _fontSizeMedium = 15.0;
  static const double _fontSizeNormal = 16.0;
  static const double _fontSizeLarge = 17.0;
  static const double _fontSizeXLarge = 18.0;
  static const double _fontSizeXXLarge = 22.0;
  static const double _letterSpacing = 0.5;
  static const int _maxLinesBody = 3;
  static const int _maxLinesToken = 3;
  static const int _snackBarDurationSeconds = 2;

  // Strings
  static const String _pageTitle = 'Token Notifications';
  static const String _fcmTokenCardTitle = 'Your FCM Token';
  static const String _errorTokenFailed = 'Failed to get token';
  static const String _buttonCopyToken = 'Copy Token';
  static const String _cardSendNotificationTitle = 'Send Notification';
  static const String _labelFcmToken = 'FCM Token';
  static const String _hintFcmToken = 'Enter FCM token';
  static const String _labelTitle = 'Title';
  static const String _hintTitle = 'Enter notification title';
  static const String _labelBody = 'Body';
  static const String _hintBody = 'Enter notification body';
  static const String _buttonSendNotification = 'Send Notification';
  static const String _snackBarAllFieldsRequired = 'Please fill in all fields';
  static const String _snackBarTokenCopied = 'Token copied to clipboard';
  static const String _tooltipGoToTopic = 'Go to Topic Notifications';
  final _tokenController = TextEditingController();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _apiService = ApiService();
  String? _currentFCMToken;
  bool _isLoading = false;
  bool _isLoadingToken = false;

  @override
  void initState() {
    super.initState();
    _getFCMToken();
  }

  Future<void> _getFCMToken() async {
    setState(() {
      _isLoadingToken = true;
    });

    try {
      final token = await FirebaseMessagingService.instance().getFCMToken();
      setState(() {
        _currentFCMToken = token;
        _isLoadingToken = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingToken = false;
      });
    }
  }

  Future<void> _sendNotification() async {
    if (_tokenController.text.trim().isEmpty ||
        _titleController.text.trim().isEmpty ||
        _bodyController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(_snackBarAllFieldsRequired),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await _apiService.sendTokenNotification(
      _tokenController.text.trim(),
      _titleController.text.trim(),
      _bodyController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
          backgroundColor: response.success ? Colors.green : Colors.red,
          duration: const Duration(seconds: _snackBarDurationSeconds),
        ),
      );
    }

    _titleController.clear();
    _bodyController.clear();
  }

  void _copyTokenToClipboard() {
    if (_currentFCMToken != null) {
      Clipboard.setData(ClipboardData(text: _currentFCMToken!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(_snackBarTokenCopied),
          duration: Duration(seconds: _snackBarDurationSeconds),
        ),
      );
    }
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          _pageTitle,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: _spacingSmall),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(_iconContainerBorderRadius),
            ),
            child: IconButton(
              icon: const Icon(Icons.swap_horiz),
              onPressed: () {
                Navigator.pushNamed(context, '/topic');
              },
              tooltip: _tooltipGoToTopic,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(_pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // FCM Token Card
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primaryContainer,
                    colorScheme.primaryContainer
                        .withValues(alpha: _gradientOpacity),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(_cardBorderRadius),
                boxShadow: [
                  BoxShadow(
                    color:
                        colorScheme.primary.withValues(alpha: _shadowOpacity),
                    blurRadius: _shadowBlurRadius,
                    offset: const Offset(0, _shadowOffsetY),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(_cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(_iconContainerPadding),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(
                                _iconContainerBorderRadius),
                          ),
                          child: const Icon(
                            Icons.vpn_key,
                            size: _iconSize,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: _spacingMedium),
                        const Expanded(
                          child: Text(
                            _fcmTokenCardTitle,
                            style: TextStyle(
                              fontSize: _fontSizeXLarge,
                              fontWeight: FontWeight.w700,
                              letterSpacing: _letterSpacing,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: _spacingXLarge),
                    _isLoadingToken
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(_spacingXLarge),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : _currentFCMToken == null
                            ? Container(
                                padding: const EdgeInsets.all(_spacingLarge),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  borderRadius: BorderRadius.circular(
                                      _iconContainerBorderRadius),
                                  border: Border.all(color: Colors.red[200]!),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.error_outline,
                                        color: Colors.red),
                                    SizedBox(width: _spacingSmall),
                                    Text(
                                      _errorTokenFailed,
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.all(_spacingLarge),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(_spacingLarge),
                                  border: Border.all(
                                    color: colorScheme.outline
                                        .withValues(alpha: _inputBorderOpacity),
                                  ),
                                ),
                                child: Text(
                                  _currentFCMToken!,
                                  style: TextStyle(
                                    fontSize: _fontSizeSmall,
                                    fontFamily: 'monospace',
                                    color: colorScheme.onSurface,
                                    height: 1.5,
                                  ),
                                  maxLines: _maxLinesToken,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                    if (_currentFCMToken != null) ...[
                      const SizedBox(height: _spacingLarge),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _copyTokenToClipboard,
                          icon: const Icon(Icons.copy, size: _spacingXLarge),
                          label: const Text(
                            _buttonCopyToken,
                            style: TextStyle(
                              fontSize: _fontSizeMedium,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: _spacingXLarge,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(_inputBorderRadius),
                            ),
                            backgroundColor: colorScheme.primary,
                            foregroundColor: Colors.white,
                            elevation: 2,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: _spacingXXLarge),
            // Send Notification Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(_cardBorderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: _cardShadowOpacity),
                    blurRadius: _shadowBlurRadius,
                    offset: const Offset(0, _shadowOffsetY),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(_cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(_iconContainerPadding),
                          decoration: BoxDecoration(
                            color: colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(
                                _iconContainerBorderRadius),
                          ),
                          child: Icon(
                            Icons.send_rounded,
                            color: colorScheme.onSecondaryContainer,
                            size: _iconSize,
                          ),
                        ),
                        const SizedBox(width: _spacingMedium),
                        const Text(
                          _cardSendNotificationTitle,
                          style: TextStyle(
                            fontSize: _fontSizeXXLarge,
                            fontWeight: FontWeight.w700,
                            letterSpacing: _letterSpacing,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: _spacingXLarge),
                    TextField(
                      controller: _tokenController,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: _fontSizeNormal,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        labelText: _labelFcmToken,
                        labelStyle: TextStyle(
                          color: colorScheme.onSurface
                              .withValues(alpha: _textOpacityLabel),
                          fontWeight: FontWeight.w500,
                        ),
                        hintText: _hintFcmToken,
                        hintStyle: TextStyle(
                          color: colorScheme.onSurface
                              .withValues(alpha: _textOpacityHint),
                          fontSize: _fontSizeNormal,
                        ),
                        prefixIcon: Icon(
                          Icons.fingerprint,
                          color: colorScheme.primary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(_inputBorderRadius),
                          borderSide: BorderSide(
                            color: colorScheme.outline
                                .withValues(alpha: _inputBorderOpacity),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(_inputBorderRadius),
                          borderSide: BorderSide(
                            color: colorScheme.outline
                                .withValues(alpha: _inputBorderOpacity),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(_inputBorderRadius),
                          borderSide: BorderSide(
                            color: colorScheme.primary,
                            width: _inputBorderWidth,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: _inputHorizontalPadding,
                          vertical: _inputVerticalPadding,
                        ),
                      ),
                    ),
                    const SizedBox(height: _spacingMedium),
                    TextField(
                      controller: _titleController,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: _fontSizeNormal,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        labelText: _labelTitle,
                        labelStyle: TextStyle(
                          color: colorScheme.onSurface
                              .withValues(alpha: _textOpacityLabel),
                          fontWeight: FontWeight.w500,
                        ),
                        hintText: _hintTitle,
                        hintStyle: TextStyle(
                          color: colorScheme.onSurface
                              .withValues(alpha: _textOpacityHint),
                          fontSize: _fontSizeNormal,
                        ),
                        prefixIcon: Icon(
                          Icons.title,
                          color: colorScheme.primary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(_inputBorderRadius),
                          borderSide: BorderSide(
                            color: colorScheme.outline
                                .withValues(alpha: _inputBorderOpacity),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(_inputBorderRadius),
                          borderSide: BorderSide(
                            color: colorScheme.outline
                                .withValues(alpha: _inputBorderOpacity),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(_inputBorderRadius),
                          borderSide: BorderSide(
                            color: colorScheme.primary,
                            width: _inputBorderWidth,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: _inputHorizontalPadding,
                          vertical: _inputVerticalPadding,
                        ),
                      ),
                    ),
                    const SizedBox(height: _spacingMedium),
                    TextField(
                      controller: _bodyController,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: _fontSizeNormal,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        labelText: _labelBody,
                        labelStyle: TextStyle(
                          color: colorScheme.onSurface
                              .withValues(alpha: _textOpacityLabel),
                          fontWeight: FontWeight.w500,
                        ),
                        hintText: _hintBody,
                        hintStyle: TextStyle(
                          color: colorScheme.onSurface
                              .withValues(alpha: _textOpacityHint),
                          fontSize: _fontSizeNormal,
                        ),
                        prefixIcon: Icon(
                          Icons.description,
                          color: colorScheme.primary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(_inputBorderRadius),
                          borderSide: BorderSide(
                            color: colorScheme.outline
                                .withValues(alpha: _inputBorderOpacity),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(_inputBorderRadius),
                          borderSide: BorderSide(
                            color: colorScheme.outline
                                .withValues(alpha: _inputBorderOpacity),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(_inputBorderRadius),
                          borderSide: BorderSide(
                            color: colorScheme.primary,
                            width: _inputBorderWidth,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: _inputHorizontalPadding,
                          vertical: _inputVerticalPadding,
                        ),
                      ),
                      maxLines: _maxLinesBody,
                    ),
                    const SizedBox(height: _spacingXLarge),
                    SizedBox(
                      height: _buttonHeight,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _sendNotification,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(_buttonBorderRadius),
                          ),
                          backgroundColor: colorScheme.primary,
                          foregroundColor: Colors.white,
                          elevation: _buttonElevation,
                          shadowColor:
                              colorScheme.primary.withValues(alpha: 0.4),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: _loadingIndicatorSize,
                                width: _loadingIndicatorSize,
                                child: CircularProgressIndicator(
                                  strokeWidth: _loadingIndicatorStrokeWidth,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.send_rounded,
                                      size: _buttonIconSize),
                                  SizedBox(width: _spacingSmall),
                                  Text(
                                    _buttonSendNotification,
                                    style: TextStyle(
                                      fontSize: _fontSizeLarge,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: _letterSpacing,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
