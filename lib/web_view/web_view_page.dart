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

  /// Function Name: _canGoBack
  ///
  /// Purpose: Check if WebView can navigate back
  ///
  /// Parameters: None
  ///
  /// Returns: Future<bool>
  Future<bool> _canGoBack() async {
    return await _controller.canGoBack();
  }

  /// Function Name: _canGoForward
  ///
  /// Purpose: Check if WebView can navigate forward
  ///
  /// Parameters: None
  ///
  /// Returns: Future<bool>
  Future<bool> _canGoForward() async {
    return await _controller.canGoForward();
  }

  /// Function Name: _goBack
  ///
  /// Purpose: Navigate back in WebView history
  ///
  /// Parameters: None
  ///
  /// Returns: Future<void>
  Future<void> _goBack() async {
    if (await _canGoBack()) {
      await _controller.goBack();
    }
  }

  /// Function Name: _goForward
  ///
  /// Purpose: Navigate forward in WebView history
  ///
  /// Parameters: None
  ///
  /// Returns: Future<void>
  Future<void> _goForward() async {
    if (await _canGoForward()) {
      await _controller.goForward();
    }
  }

  /// Function Name: _reload
  ///
  /// Purpose: Reload the current page
  ///
  /// Parameters: None
  ///
  /// Returns: Future<void>
  Future<void> _reload() async {
    await _controller.reload();
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reload,
            tooltip: 'Reload',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pop(context);
            },
            tooltip: 'Back to Settings',
          ),
        ],
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Back button
                FutureBuilder<bool>(
                  future: _canGoBack(),
                  builder: (context, snapshot) {
                    final canGoBack = snapshot.data ?? false;
                    return IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: canGoBack ? _goBack : null,
                      tooltip: 'Back',
                      color: canGoBack
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                    );
                  },
                ),

                // Forward button
                FutureBuilder<bool>(
                  future: _canGoForward(),
                  builder: (context, snapshot) {
                    final canGoForward = snapshot.data ?? false;
                    return IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: canGoForward ? _goForward : null,
                      tooltip: 'Forward',
                      color: canGoForward
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                    );
                  },
                ),

                // Reload button
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _reload,
                  tooltip: 'Reload',
                  color: Theme.of(context).colorScheme.primary,
                ),

                // Home button (back to settings)
                IconButton(
                  icon: const Icon(Icons.home),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  tooltip: 'Home',
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
