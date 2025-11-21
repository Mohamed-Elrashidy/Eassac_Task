/// ****************** FILE INFO ******************
/// File Name: web_view_page.dart
/// Purpose: Display web pages in a WebView with navigation controls
/// Author: Mohamed Elrashidy
/// Created At: 21/11/2025

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// ****************** CLASS: WebViewPage ******************
class WebViewPage extends StatefulWidget {
  final String? url;

  const WebViewPage({super.key, this.url});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _controller;
  bool _isLoading = true;
  String _currentUrl = '';
  double _loadingProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  /// Function Name: _initializeWebView
  ///
  /// Purpose: Initialize the WebView controller with settings and load URL
  ///
  /// Parameters: None
  ///
  /// Returns: Future<void>
  Future<void> _initializeWebView() async {
    String urlToLoad = widget.url ?? '';

    // If no URL provided, try to load from SharedPreferences
    if (urlToLoad.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      urlToLoad = prefs.getString('web_url') ?? 'https://www.google.com';
    }

    // Ensure URL has a valid scheme
    if (!urlToLoad.startsWith('http://') && !urlToLoad.startsWith('https://')) {
      urlToLoad = 'https://$urlToLoad';
    }

    setState(() {
      _currentUrl = urlToLoad;
    });

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _loadingProgress = progress / 100;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _currentUrl = url;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
              _currentUrl = url;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
            });
            _showErrorSnackBar('Error loading page: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(urlToLoad));
  }

  /// Function Name: _showErrorSnackBar
  ///
  /// Purpose: Display an error message in a SnackBar
  ///
  /// Parameters:
  /// - message: The error message to display
  ///
  /// Returns: void
  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Web View', style: TextStyle(fontSize: 18)),
            if (_currentUrl.isNotEmpty)
              Text(
                _currentUrl.length > 40
                    ? '${_currentUrl.substring(0, 40)}...'
                    : _currentUrl,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 2,
      ),
      body: Column(
        children: [
          // Loading progress indicator
          if (_isLoading)
            LinearProgressIndicator(
              value: _loadingProgress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),

          // WebView
          Expanded(child: WebViewWidget(controller: _controller)),
        ],
      ),
    );
  }
}
