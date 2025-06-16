abstract class WebUtilsInterface {
  bool isChrome();
  bool isSafari();
  bool isFireFox();
  bool isFullscreen();
  bool historyPushState(String url);
  String locationOrigin();
}
