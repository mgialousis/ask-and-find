// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Di y Encuentra';

  @override
  String get appTagline => 'El Juego de Trivia Definitivo';

  @override
  String get newGame => 'Nuevo Juego';

  @override
  String get howToPlay => 'Cómo Jugar';

  @override
  String get settings => 'Ajustes';

  @override
  String get startGame => 'Iniciar Juego';

  @override
  String get continueButton => 'Continuar';

  @override
  String get playAgain => 'Jugar de Nuevo';

  @override
  String get newSetup => 'Nueva Partida';

  @override
  String get shareResults => 'Compartir';

  @override
  String get home => 'Inicio';

  @override
  String get close => 'Cerrar';

  @override
  String get endGame => 'Terminar Juego';

  @override
  String get endTurn => 'Terminar Turno';

  @override
  String get showQuestion => 'Mostrar Pregunta';

  @override
  String get refreshQuestion => 'Nueva pregunta';

  @override
  String get showAnswers => 'Mostrar Respuestas';

  @override
  String get hideAnswers => 'Ocultar Respuestas';

  @override
  String get restoreDefaults => 'Restaurar';

  @override
  String get gameSetup => 'Configuración';

  @override
  String get numberOfTeams => 'Número de Equipos';

  @override
  String get teamSetup => 'Equipos';

  @override
  String get gameSettings => 'Ajustes del Juego';

  @override
  String get numberOfRounds => 'Número de Rondas';

  @override
  String get roundDuration => 'Duración';

  @override
  String get difficulty => 'Dificultad';

  @override
  String get teamName => 'Nombre';

  @override
  String get teamColor => 'Color del Equipo';

  @override
  String get enterTeamName => 'Ingrese nombre';

  @override
  String get team => 'Equipo';

  @override
  String get teams => 'Equipos';

  @override
  String teamWithNumber(int number) {
    return 'Equipo $number';
  }

  @override
  String get easy => 'Fácil';

  @override
  String get medium => 'Medio';

  @override
  String get hard => 'Difícil';

  @override
  String get seconds30 => '30s';

  @override
  String get seconds45 => '45s';

  @override
  String get seconds60 => '60s';

  @override
  String get seconds90 => '90s';

  @override
  String roundOf(int current, int total) {
    return 'Ronda $current de $total';
  }

  @override
  String findAnswersInTime(int seconds) {
    return 'Encuentra 10 respuestas en $seconds segundos';
  }

  @override
  String passDeviceMessage(String currentTeam, String nextTeam) {
    return 'Turno de $currentTeam, pasa el dispositivo a $nextTeam';
  }

  @override
  String get readyStartTurn => '¿Listo? Iniciar Turno';

  @override
  String get tapToStartTimer => 'Toca la tarjeta para iniciar';

  @override
  String get gameOver => '¡Fin del Juego!';

  @override
  String teamWins(String teamName) {
    return '¡$teamName Gana!';
  }

  @override
  String get itsATie => '¡Empate!';

  @override
  String get noWinner => 'Sin ganador';

  @override
  String get noScoresRecorded => 'Sin puntuaciones';

  @override
  String nPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count puntos',
      one: '1 punto',
    );
    return '$_temp0';
  }

  @override
  String nPts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ptos',
      one: '1 pto',
    );
    return '$_temp0';
  }

  @override
  String get roundComplete => '¡Ronda Completa!';

  @override
  String foundOf(int found, int total) {
    return 'Encontradas $found de $total';
  }

  @override
  String get scoresSoFar => 'Puntuaciones';

  @override
  String get finalScores => 'Puntuaciones Finales';

  @override
  String foundWithCount(int count, int points) {
    return 'Encontradas ($count) ($points ptos)';
  }

  @override
  String missedWithCount(int count) {
    return 'Falladas ($count)';
  }

  @override
  String get rank1st => '1°';

  @override
  String get rank2nd => '2°';

  @override
  String get rank3rd => '3°';

  @override
  String rankNth(int rank) {
    return '$rank°';
  }

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get audio => 'Audio';

  @override
  String get haptics => 'Vibración';

  @override
  String get appearance => 'Apariencia';

  @override
  String get privacy => 'Privacidad';

  @override
  String get language => 'Idioma';

  @override
  String get soundEffects => 'Efectos de Sonido';

  @override
  String get soundEffectsDesc => 'Reproducir sonidos durante el juego';

  @override
  String get hapticFeedback => 'Vibración Háptica';

  @override
  String get hapticFeedbackDesc => 'Vibrar en las interacciones';

  @override
  String get darkMode => 'Modo Oscuro';

  @override
  String get darkModeDesc => 'Próximamente';

  @override
  String get analytics => 'Analíticas';

  @override
  String get analyticsDesc =>
      'Ayuda a mejorar el juego enviando datos anónimos';

  @override
  String get settingsRestored => 'Ajustes restaurados';

  @override
  String versionNumber(String number) {
    return 'Versión $number';
  }

  @override
  String get validationNameEmpty => 'El nombre no puede estar vacío';

  @override
  String get validationNameDuplicate => 'El nombre debe ser único';

  @override
  String get validationFixErrors => 'Corrige los errores antes de comenzar';

  @override
  String get howToPlayTitle => 'Cómo Jugar';

  @override
  String get step1Title => 'Configura Equipos';

  @override
  String get step1Desc =>
      'Crea de 2 a 4 equipos con nombres y colores únicos. Cada equipo se turnará para adivinar respuestas.';

  @override
  String get step2Title => 'Lee la Pregunta';

  @override
  String get step2Desc =>
      'Cada ronda, el equipo activo ve una pregunta (como \"Nombra capitales europeas\"). Su objetivo es adivinar 10 respuestas correctas.';

  @override
  String get step3Title => 'Vence al Reloj';

  @override
  String get step3Desc =>
      'Los equipos tienen un límite de tiempo (30-90 segundos) para encontrar respuestas. Toca las fichas para revelar respuestas correctas.';

  @override
  String get step4Title => 'Gana Puntos';

  @override
  String get step4Desc =>
      'Cada respuesta correcta gana puntos. No hay penalizaciones por respuestas incorrectas. Solo cuentan las 10 respuestas seleccionadas.';

  @override
  String get step5Title => 'Toma Turnos';

  @override
  String get step5Desc =>
      'Los equipos se turnan para jugar rondas hasta completar todas las configuradas. El juego alterna entre equipos.';

  @override
  String get step6Title => 'Gana el Juego';

  @override
  String get step6Desc =>
      '¡Después de todas las rondas, el equipo con más puntos gana! Si hay empate, las rondas extra determinan al ganador.';

  @override
  String get proTips => 'Consejos';

  @override
  String get tip1 =>
      '¡La comunicación es clave! Discute las respuestas con tu equipo.';

  @override
  String get tip2 =>
      'Piensa en variaciones de una respuesta (ej., \"EE.UU.\" vs \"Estados Unidos\").';

  @override
  String get tip3 =>
      '¡Vigila el temporizador! Los últimos 10 segundos son críticos.';

  @override
  String get tip4 =>
      'Aprende de las respuestas reveladas al final de cada ronda.';

  @override
  String get shareTitle => 'Di y Encuentra - Resultados';

  @override
  String get shareWinner => 'Ganador:';

  @override
  String get shareTie => 'Empate entre:';

  @override
  String get shareScore => 'Puntuación:';

  @override
  String get shareFinalStandings => 'Posiciones Finales:';

  @override
  String get english => 'Inglés';

  @override
  String get spanish => 'Español';

  @override
  String get community => 'Comunidad';

  @override
  String get submitNewCard => 'Enviar nueva tarjeta';

  @override
  String get submitNewCardDesc => 'Propón una nueva tarjeta para revisión.';

  @override
  String get reportIssue => 'Reportar problema';

  @override
  String get reportIssueDesc => 'Señala un problema en una tarjeta existente.';

  @override
  String get pendingSubmissions => 'Envíos pendientes';

  @override
  String pendingSubmissionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count envíos pendientes',
      one: '1 envío pendiente',
    );
    return '$_temp0';
  }

  @override
  String get retrySubmissions => 'Reintentar';

  @override
  String get submitCardTitle => 'Enviar nueva tarjeta';

  @override
  String get reportIssueTitle => 'Reportar un problema';

  @override
  String get questionLabel => 'Pregunta';

  @override
  String get questionHint => 'p. ej., Nombra 10 capitales europeas';

  @override
  String get answersLabel => 'Respuestas';

  @override
  String get answersHint => 'Agrega 10 respuestas correctas.';

  @override
  String answersCount(int count, int min) {
    return '$count de $min respuestas completadas';
  }

  @override
  String get addAnswer => 'Agregar respuesta';

  @override
  String get sourceLabel => 'Fuente';

  @override
  String get sourceHint => 'Fuente o referencia (opcional)';

  @override
  String get yourNameLabel => 'Tu nombre';

  @override
  String get yourNameHint => 'Opcional';

  @override
  String get yourEmailLabel => 'Tu correo';

  @override
  String get yourEmailHint => 'Opcional, para contacto';

  @override
  String get optional => 'opcional';

  @override
  String get previewCard => 'Vista previa';

  @override
  String get submitCard => 'Enviar tarjeta';

  @override
  String get submitReport => 'Enviar reporte';

  @override
  String get offlineSubmissionSaved =>
      'Estás sin conexión. Lo enviaremos cuando vuelvas a estar en línea.';

  @override
  String get submissionError => 'No se pudo enviar. Intenta de nuevo.';

  @override
  String get submissionSuccess => 'Envío recibido';

  @override
  String get submissionSuccessMessage =>
      'Gracias por ayudar a mejorar el juego.';

  @override
  String get submitAnother => 'Enviar otra';

  @override
  String get backToSettings => 'Volver a ajustes';

  @override
  String get cardBeingCorrected => 'Tarjeta a corregir';

  @override
  String get selectCard => 'Seleccionar tarjeta';

  @override
  String get changeCard => 'Cambiar tarjeta';

  @override
  String get searchCards => 'Buscar tarjetas';

  @override
  String get filterByDifficulty => 'Filtrar por dificultad';

  @override
  String get all => 'Todas';

  @override
  String get errorLoadingCards => 'No se pudieron cargar las tarjetas.';

  @override
  String get noCardsFound => 'No se encontraron tarjetas.';

  @override
  String get issueTypeLabel => 'Tipo de problema';

  @override
  String get issueTypeWrongAnswer => 'Respuesta incorrecta';

  @override
  String get issueTypeWrongAnswerDesc => 'Falta una respuesta o es incorrecta.';

  @override
  String get issueTypeOutdated => 'Info desactualizada';

  @override
  String get issueTypeOutdatedDesc => 'La tarjeta tiene datos antiguos.';

  @override
  String get issueTypeSpelling => 'Ortografía/gramática';

  @override
  String get issueTypeSpellingDesc => 'Corrige ortografía o gramática.';

  @override
  String get issueTypeUnclear => 'Pregunta confusa';

  @override
  String get issueTypeUnclearDesc => 'El enunciado es ambiguo o confuso.';

  @override
  String get issueTypeOther => 'Otro';

  @override
  String get issueTypeOtherDesc => 'Otro problema a revisar.';

  @override
  String get describeIssue => 'Describe el problema';

  @override
  String get describeIssueHint => 'Cuéntanos qué está mal y cómo corregirlo.';

  @override
  String get validationQuestionRequired => 'La pregunta es obligatoria';

  @override
  String get validationQuestionTooShort =>
      'La pregunta debe tener al menos 10 caracteres';

  @override
  String get validationDescriptionRequired => 'La descripción es obligatoria';

  @override
  String get validationDescriptionTooShort =>
      'La descripción debe tener al menos 20 caracteres';

  @override
  String get validationInvalidEmail => 'Formato de correo inválido';
}
