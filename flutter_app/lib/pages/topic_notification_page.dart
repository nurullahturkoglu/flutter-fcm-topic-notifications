import 'package:flutter/material.dart';
import 'package:flutter_fcm_topic_notifications/services/firebase_messaging_service.dart';
import 'package:flutter_fcm_topic_notifications/services/shared_preferences_helper.dart';
import 'package:flutter_fcm_topic_notifications/services/api_service.dart';

class TopicNotificationPage extends StatefulWidget {
  const TopicNotificationPage({super.key});

  @override
  State<TopicNotificationPage> createState() => _TopicNotificationPageState();
}

class _TopicNotificationPageState extends State<TopicNotificationPage> {
  // Constants
  static const double _pagePadding = 20.0;
  static const double _cardPadding = 20.0;
  static const double _cardBorderRadius = 20.0;
  static const double _iconContainerPadding = 10.0;
  static const double _iconContainerBorderRadius = 12.0;
  static const double _iconSize = 24.0;
  static const double _spacingSmall = 6.0;
  static const double _spacingMedium = 8.0;
  static const double _spacingLarge = 12.0;
  static const double _spacingXLarge = 16.0;
  static const double _spacingXXLarge = 20.0;
  static const double _spacingXXXLarge = 24.0;
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
  static const double _fontSizeSmall = 14.0;
  static const double _fontSizeNormal = 16.0;
  static const double _fontSizeLarge = 17.0;
  static const double _fontSizeXLarge = 18.0;
  static const double _fontSizeXXLarge = 22.0;
  static const double _letterSpacing = 0.5;
  static const double _switchScale = 1.1;
  static const int _maxLinesBody = 3;
  static const int _snackBarDurationSeconds = 2;

  // Strings
  static const String _pageTitle = 'Topic Notifications';
  static const String _cardSubscribeTitle = 'Subscribe to Topic';
  static const String _cardSubscribeDescription =
      'Enable notifications for "everyone" topic';
  static const String _cardSendNotificationTitle = 'Send Notification';
  static const String _labelTitle = 'Title';
  static const String _hintTitle = 'Enter notification title';
  static const String _labelBody = 'Body';
  static const String _hintBody = 'Enter notification body';
  static const String _buttonSendNotification = 'Send Notification';
  static const String _snackBarBothFieldsRequired =
      'Please fill in both title and body';
  static const String _tooltipGoToToken = 'Go to Token Notifications';
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _apiService = ApiService();
  bool _isSubscribed = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSubscriptionStatus();
  }

  Future<void> _loadSubscriptionStatus() async {
    final status = await SharedPreferencesHelper.isNotificationEnabled();
    setState(() {
      _isSubscribed = status;
    });
  }

  Future<void> _toggleSubscription(bool value) async {
    setState(() {
      _isSubscribed = value;
    });

    if (value) {
      await FirebaseMessagingService.instance().subscribeToGeneralTopic();
    } else {
      await FirebaseMessagingService.instance().unsubscribeFromGeneralTopic();
    }
  }

  Future<void> _sendNotification() async {
    if (_titleController.text.trim().isEmpty ||
        _bodyController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(_snackBarBothFieldsRequired),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await _apiService.sendTopicNotification(
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

  @override
  void dispose() {
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
            margin: const EdgeInsets.only(right: _spacingMedium),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(_iconContainerBorderRadius),
            ),
            child: IconButton(
              icon: const Icon(Icons.swap_horiz),
              onPressed: () {
                Navigator.pushNamed(context, '/token');
              },
              tooltip: _tooltipGoToToken,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(_pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Subscribe Card
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.secondaryContainer,
                    colorScheme.secondaryContainer
                        .withValues(alpha: _gradientOpacity),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(_cardBorderRadius),
                boxShadow: [
                  BoxShadow(
                    color:
                        colorScheme.secondary.withValues(alpha: _shadowOpacity),
                    blurRadius: _shadowBlurRadius,
                    offset: const Offset(0, _shadowOffsetY),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(_cardPadding),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(_iconContainerPadding),
                      decoration: BoxDecoration(
                        color: colorScheme.secondary,
                        borderRadius:
                            BorderRadius.circular(_iconContainerBorderRadius),
                      ),
                      child: Icon(
                        _isSubscribed
                            ? Icons.notifications_active
                            : Icons.notifications_off,
                        size: _iconSize,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: _spacingXLarge),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            _cardSubscribeTitle,
                            style: TextStyle(
                              fontSize: _fontSizeXLarge,
                              fontWeight: FontWeight.w700,
                              letterSpacing: _letterSpacing,
                            ),
                          ),
                          const SizedBox(height: _spacingSmall),
                          Text(
                            _cardSubscribeDescription,
                            style: TextStyle(
                              fontSize: _fontSizeSmall,
                              color: colorScheme.onSecondaryContainer
                                  .withValues(alpha: _textOpacityLabel),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Transform.scale(
                      scale: _switchScale,
                      child: Switch(
                        value: _isSubscribed,
                        onChanged: _toggleSubscription,
                        activeThumbColor: colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: _spacingXXXLarge),
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
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(
                                _iconContainerBorderRadius),
                          ),
                          child: Icon(
                            Icons.send_rounded,
                            color: colorScheme.onPrimaryContainer,
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
                    const SizedBox(height: _spacingXXLarge),
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
                    const SizedBox(height: _spacingLarge),
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
                    const SizedBox(height: _spacingXXLarge),
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
                                  SizedBox(width: _spacingMedium),
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
