import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get hintSearchText => 'Workouts, trainers, oefeningen';

  @override
  String yourTrainingPlan(num length) {
    String _temp0 = intl.Intl.pluralLogic(
      length,
      locale: localeName,
      other: 'Jouw Trainingsplannen',
      one: 'Jouw Trainingsplan',
    );
    return '$_temp0';
  }

  @override
  String get seeAll => 'Bekijk alles';

  @override
  String recentTitle(String title) {
    String _temp0 = intl.Intl.selectLogic(
      title,
      {
        'video': 'Recente Videoklassen',
        'training': 'Recente Trainingsplannen',
        'workout': 'Recente Workouts',
        'search': 'Recente Zoekopdrachten',
        'visit': 'Recentelijk Bezocht',
        'audio': 'Audioklassen',
        'other': 'geen gevonden',
      },
    );
    return '$_temp0';
  }

  @override
  String recentSubtitle(String title) {
    String _temp0 = intl.Intl.selectLogic(
      title,
      {
        'training': 'Heerlijke plannen',
        'workout': 'Wat nieuws voor jou',
        'other': 'geen gevonden',
      },
    );
    return '$_temp0';
  }

  @override
  String get nextUp => 'Volgende';

  @override
  String get whatLookingFor => 'Waar ben je naar op zoek?';

  @override
  String titleText(String title) {
    String _temp0 = intl.Intl.selectLogic(
      title,
      {
        'video': 'Videolessen',
        'training': 'Trainingsplannen',
        'workout': 'Workouts',
        'audio': 'Audiocursussen',
        'audios': 'Audio\'s',
        'videos': 'Video\'s',
        'other': 'niet gevonden',
      },
    );
    return '$_temp0';
  }

  @override
  String get cancelText => 'Annuleren';

  @override
  String get clearText => 'Wissen';

  @override
  String get hintSearchText2 => 'Yoga, HIIT, cardio';

  @override
  String get levelText => 'niveau';

  @override
  String get instructorText => 'Instructeur';

  @override
  String get equipmentText => 'Apparatuur';

  @override
  String buttonText(String title) {
    String _temp0 = intl.Intl.selectLogic(
      title,
      {
        'play': 'Klasse afspelen',
        'startWorkout': 'Workout starten',
        'letsGo': 'Laten we gaan',
        'previous': 'Vorige',
        'nextWorkout': 'Volgende Workout',
        'startFollow': 'Volgen starten',
        'other': 'geen gevonden',
      },
    );
    return '$_temp0';
  }

  @override
  String get resetText => 'Resetten';

  @override
  String get filterText => 'Filteren';

  @override
  String get doneText => 'Klaar';

  @override
  String get goalText => 'Doel';

  @override
  String get bodyPartText => 'Lichaamsdelen';

  @override
  String get alertBoxTitle => 'Workout buiten volgorde starten?';

  @override
  String get alertBoxBody => 'Alle onvoltooide workouts die voor deze staan zullen als voltooid worden gemarkeerd.';

  @override
  String get alertBoxButton1 => 'Annuleren';

  @override
  String get alertBoxButton2 => 'Workout starten';

  @override
  String get alertBoxTitle2 => 'Workout afbreken?';

  @override
  String get alertBoxBody2 => 'Je zult de workout niet kunnen hervatten.';

  @override
  String get alertBox2Button2 => 'Afbreken';

  @override
  String get alertBoxTitle3 => 'Trainingsplan niet meer volgen?';

  @override
  String get alertBoxBody3 => 'Als je het trainingsplan niet meer volgt, worden alle vorderingen verwijderd.';

  @override
  String get alertBox3Button2 => 'Niet meer volgen';

  @override
  String phaseTitle(String title) {
    String _temp0 = intl.Intl.selectLogic(
      title,
      {
        'warmUp': 'Opwarming',
        'training': 'Training',
        'coolDown': 'CoolDown',
        'other': 'geen gevonden',
      },
    );
    return '$_temp0';
  }

  @override
  String get workoutText => 'Workout';

  @override
  String get getReadyForText => 'Maak je klaar voor';

  @override
  String get getReadyText => 'Maak je klaar!';

  @override
  String get durationText => 'Duur';

  @override
  String get typeText => 'Type';

  @override
  String get whatYouNeedText => 'Wat je nodig hebt';

  @override
  String get upNext => 'Binnenkort';

  @override
  String get roundText => 'RONDE';

  @override
  String get exerciseText => 'OEFENING';

  @override
  String get overviewText => 'Overzicht';

  @override
  String get trainerNotesText => 'Trainersnotities';

  @override
  String get trainingAll => 'Alle';

  @override
  String get trainingFollow => 'Gevolgd';

  @override
  String workoutPluraText(num length) {
    String _temp0 = intl.Intl.pluralLogic(
      length,
      locale: localeName,
      other: 'workouts',
      one: 'workout',
    );
    return '$_temp0';
  }

  @override
  String get followingText => 'Volgen';

  @override
  String get nextText => 'Volgende';

  @override
  String get completeText => 'Je hebt voltooid';

  @override
  String get totalDurationText => 'Totale Duur';

  @override
  String get progressUpdateText => 'Voortgangsupdate';

  @override
  String get completedFollowPlan => 'Je hebt het trainingsplan voltooid en het zal worden verwijderd uit je gevolgde trainingsplannen. Als je het opnieuw wilt volgen, kun je hieronder op Opnieuw starten klikken.';

  @override
  String get startAgainText => 'Opnieuw starten';

  @override
  String get unFollowTrainingPlanText => 'Trainingsplan niet meer volgen';

  @override
  String get scheduleText => 'Schema';

  @override
  String get nothingToLoadText => 'Niets te laden';

  @override
  String get minText => 'min';

  @override
  String get workoutOverviewText => 'Workout Overzicht';

  @override
  String get workoutCompletedText => 'Workouts voltooid';

  @override
  String popupText(String title) {
    String _temp0 = intl.Intl.selectLogic(
      title,
      {
        'show': 'Info weergeven',
        'here': 'Hierheen gaan',
        'other': 'geen gevonden',
      },
    );
    return '$_temp0';
  }

  @override
  String itemTypeInfo(String title) {
    String _temp0 = intl.Intl.selectLogic(
      title,
      {
        'single': 'Oefeningen kunnen worden gecombineerd in meerdere sets met verschillende metrieken die eraan zijn gekoppeld.',
        'circuit': 'Een op tijd gebaseerd circuit is een combinatie van oefeningen uitgevoerd met een voorgeschreven werk-rustinterval. Elke ronde kan een ander werk-rustinterval en/of verschillende oefeningen hebben.',
        'reps': 'Een herhalingsgebaseerd circuit is een combinatie van oefeningen uitgevoerd met korte rustperiodes tussen hen voor een vast aantal herhalingen. Elke ronde kan een ander aantal herhalingen, rustinterval en/of oefeningen hebben.',
        'ss': 'Het concept van een superset is om 2 oefeningen achter elkaar uit te voeren, gevolgd door een korte rust (maar niet altijd).',
        'rft': 'RFT staat voor \'rondes voor tijd\'. Deelnemers moeten het vastgestelde aantal rondes en herhalingen zo snel mogelijk voltooien. Een ronde is een volgorde van alle oefeningen. De tijd die de deelnemers nodig hebben om het vastgestelde aantal rondes te voltooien, is hun score.',
        'amrap': 'AMRAP staat voor \'zo veel mogelijk herhalingen\'. Deelnemers moeten zo veel mogelijk herhalingen van de gegeven oefenreeks voltooien in een vastgestelde tijd. Het totale aantal voltooide herhalingen is de score van de deelnemer.',
        'emom': 'EMOM staat voor \'elke minuut op de minuut\'. In dit type workout moet de deelnemer de oefeningen aan het begin van elke minuut voor een vastgesteld aantal minuten voltooien. Elke minuut kan verschillende oefeningen met verschillende waarden hebben.',
        'other': 'geen gevonden',
      },
    );
    return '$_temp0';
  }

  @override
  String get skip => 'Overslaan';

  @override
  String get setDone => 'Instellen als voltooid';

  @override
  String titleTargetText(String title) {
    String _temp0 = intl.Intl.selectLogic(
      title,
      {
        'kg': 'KG',
        'deg': 'GRADEN',
        'm': 'AFSTAND',
        'sec': 'TIJD',
        'cm': 'HOOGTE',
        'irm': 'IRM',
        'lvl': 'NIVEAU',
        'reps': 'HERHALINGEN',
        'w': 'WATT',
        'kcal': 'CAL',
        'rpm': 'RPM',
        'other': 'SNELHEID',
      },
    );
    return '$_temp0';
  }
}
