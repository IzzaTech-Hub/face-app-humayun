part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const ONBOARDING = _Paths.ONBOARDING;
  static const HOME = _Paths.HOME;
  static const FACE = _Paths.FACE;
  static const FACE_EDITOR = _Paths.FACE_EDITOR;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const ONBOARDING = '/onboarding';
  static const HOME = '/home';
  static const FACE = '/face';
  static const FACE_EDITOR = '/face-editor';
}
