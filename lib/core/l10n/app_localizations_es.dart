// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'The Movie App';

  @override
  String get errorNetwork => 'Sin conexión a internet';

  @override
  String get errorUnknown => 'Error desconocido';

  @override
  String get errorServer => 'Error del servidor';

  @override
  String get homeGreeting => 'Saludos nuevamente';

  @override
  String get categorySelectPlaceholder => 'Selecciona una categoría';

  @override
  String get popularMoviesTitle => 'Películas populares';

  @override
  String get moviesByCategoryTitle => 'Películas de';

  @override
  String get loadMore => 'Cargar más';
}
