import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get hintSearchText => 'Ćwiczenia, trenerzy, ćwiczenia';

  @override
  String yourTrainingPlan(num length) {
    String _temp0 = intl.Intl.pluralLogic(
      length,
      locale: localeName,
      other: 'Twoje Plany Treningowe',
      one: 'Twój Plan Treningowy',
    );
    return '$_temp0';
  }

  @override
  String get seeAll => 'Zobacz wszystkie';

  @override
  String recentTitle(String title) {
    String _temp0 = intl.Intl.selectLogic(
      title,
      {
        'video': 'Ostatnie Lekcje Wideo',
        'training': 'Ostatnie Plany Treningowe',
        'workout': 'Ostatnie Ćwiczenia',
        'search': 'Ostatnie Wyszukiwania',
        'visit': 'Ostatnio Odwiedzone',
        'audio': 'Lekcje Audio',
        'other': 'Nie Znaleziono Żadnych',
      },
    );
    return '$_temp0';
  }

  @override
  String recentSubtitle(String title) {
    String _temp0 = intl.Intl.selectLogic(
      title,
      {
        'training': 'Słodkie Plany',
        'workout': 'Świeża Zawartość dla Ciebie',
        'other': 'Nie Znaleziono Żadnych',
      },
    );
    return '$_temp0';
  }

  @override
  String get nextUp => 'Następny';

  @override
  String get whatLookingFor => 'Czego Szukasz?';

  @override
  String titleText(String title) {
    String _temp0 = intl.Intl.selectLogic(
      title,
      {
        'video': 'Klasy wideo',
        'training': 'Plany treningowe',
        'workout': 'Treningi',
        'audio': 'Klasy dźwiękowe',
        'audios': 'Nagrania dźwiękowe',
        'videos': 'Filmy',
        'other': 'nie znaleziono',
      },
    );
    return '$_temp0';
  }

  @override
  String get cancelText => 'Anuluj';

  @override
  String get clearText => 'Wyczyść';

  @override
  String get hintSearchText2 => 'Joga, HIIT, cardio';

  @override
  String get levelText => 'Poziom';

  @override
  String get instructorText => 'Instruktor';

  @override
  String get equipmentText => 'Wyposażenie';

  @override
  String buttonText(String title) {
    String _temp0 = intl.Intl.selectLogic(
      title,
      {
        'play': 'Odtwórz Lekcję',
        'startWorkout': 'Rozpocznij Trening',
        'letsGo': 'Zaczynamy',
        'previous': 'Poprzedni',
        'nextWorkout': 'Następne Ćwiczenie',
        'startFollow': 'Zacznij Śledzić',
        'other': 'Nie Znaleziono Żadnych',
      },
    );
    return '$_temp0';
  }

  @override
  String get resetText => 'Resetuj';

  @override
  String get filterText => 'Filtruj';

  @override
  String get doneText => 'Gotowe';

  @override
  String get goalText => 'Cel';

  @override
  String get bodyPartText => 'Części Ciała';

  @override
  String get alertBoxTitle => 'Rozpocząć Trening Poza Kolejnością?';

  @override
  String get alertBoxBody => 'Wszelkie Niekompletne Treningi Wymienione Przed Tym Zostaną Oznaczone Jako Zakończone.';

  @override
  String get alertBoxButton1 => 'Anuluj';

  @override
  String get alertBoxButton2 => 'Rozpocznij Trening';

  @override
  String get alertBoxTitle2 => 'Zakończyć Trening?';

  @override
  String get alertBoxBody2 => 'Nie Będziesz Mógł Wznowić Treningu.';

  @override
  String get alertBox2Button2 => 'Zakończ';

  @override
  String get alertBoxTitle3 => 'Zatrzymać Obserwację Planu Treningowego?';

  @override
  String get alertBoxBody3 => 'Jeśli Zatrzymasz Obserwację Planu Treningowego, Cały Postęp Zostanie Usunięty.';

  @override
  String get alertBox3Button2 => 'Zatrzymaj';

  @override
  String phaseTitle(String title) {
    String _temp0 = intl.Intl.selectLogic(
      title,
      {
        'warmUp': 'Rozgrzewka',
        'training': 'Trening',
        'coolDown': 'Schładzanie',
        'other': 'Nie Znaleziono',
      },
    );
    return '$_temp0';
  }

  @override
  String get workoutText => 'Trening';

  @override
  String get getReadyForText => 'Przygotuj Się Na';

  @override
  String get getReadyText => 'Przygotuj Się!';

  @override
  String get durationText => 'Czas Trwania';

  @override
  String get typeText => 'Typ';

  @override
  String get whatYouNeedText => 'Czego Będziesz Potrzebować';

  @override
  String get upNext => 'Następne';

  @override
  String get roundText => 'Rundy';

  @override
  String get exerciseText => 'Ćwiczenie';

  @override
  String get overviewText => 'Przegląd';

  @override
  String get trainerNotesText => 'Notatki Trenera';

  @override
  String get trainingAll => 'Wszystkie';

  @override
  String get trainingFollow => 'Śledzone';

  @override
  String workoutPluraText(num length) {
    String _temp0 = intl.Intl.pluralLogic(
      length,
      locale: localeName,
      other: 'Ćwiczenia',
      one: 'Ćwiczenie',
    );
    return '$_temp0';
  }

  @override
  String get followingText => 'Śledzenie';

  @override
  String get nextText => 'Następne';

  @override
  String get completeText => 'Ukończyłeś';

  @override
  String get totalDurationText => 'Całkowity Czas Trwania';

  @override
  String get progressUpdateText => 'Aktualizacja Postępu';

  @override
  String get completedFollowPlan => 'Zakończyłeś Plan Treningowy i Zostanie On Usunięty. Jeśli Chcesz Zacząć Go Ponownie, Kliknij „Rozpocznij Ponownie” Poniżej.';

  @override
  String get startAgainText => 'Rozpocznij Ponownie';

  @override
  String get unFollowTrainingPlanText => 'Zatrzymaj Obserwację Planu Treningowego';

  @override
  String get scheduleText => 'Harmonogram';

  @override
  String get nothingToLoadText => 'Nic do Załadowania';

  @override
  String get minText => 'min';

  @override
  String get workoutOverviewText => 'Przegląd Treningu';

  @override
  String get workoutCompletedText => 'Treningi Ukończone';

  @override
  String popupText(String title) {
    String _temp0 = intl.Intl.selectLogic(
      title,
      {
        'show': 'Pokaż Informacje',
        'here': 'Tutaj',
        'other': 'Nie Znaleziono',
      },
    );
    return '$_temp0';
  }

  @override
  String itemTypeInfo(String title) {
    String _temp0 = intl.Intl.selectLogic(
      title,
      {
        'single': 'Ćwiczenia można Łączyć w Wiele Zestawów z Różnymi Metrykami Połączonymi Z Nimi.',
        'circuit': 'Obwód Czasowy to Kombinacja Ćwiczeń Wykonywanych w Określonym Interwale Pracy-i-Odpoczynku. Każda Runda Może Mieć Inny Interwał Pracy-i-Odpoczynku i/lub Inne Ćwiczenia.',
        'reps': 'Obwód Oparty na Powtórzeniach to Kombinacja Ćwiczeń Wykonywanych z Krótkimi Przerwami Między Nimi przez Określoną Liczbę Powtórzeń. Każda Runda Może Mieć Inną Liczbę Powtórzeń, Interwał Odpoczynku i/lub Inne Ćwiczenia.',
        'ss': 'Koncepcja Supersetu Polega na Wykonaniu 2 Ćwiczeń Bezpośrednio Po Sobie, Po Czym Następuje Krótka Przerwa (Ale Nie Zawsze).',
        'rft': 'RFT to Skrót Od \'Rounds for Time\'. Uczestnicy Muszą Ukończyć Określoną Liczbę Rund i Powtórzeń Jak Najszybciej. Runda To Sekwencja Wszystkich Ćwiczeń. Czas, W Jakim Uczestnicy Ukończą Określoną Liczbę Rund, Jest Ich Wynikiem.',
        'amrap': 'AMRAP to Skrót Od \'As Many Reps As Possible\'. Uczestnicy Muszą Wykonać Jak Najwięcej Powtórzeń Danej Sekwencji Ćwiczeń W Określonym Czasie. Całkowita Liczba Wykonanych Powtórzeń Jest Wynikiem Uczestnika.',
        'emom': 'EMOM to Skrót Od \'Every Minute on the Minute\'. W Tego Typu Treningu Uczestnik Musi Wykonać Ćwiczenia na Początku Każdej Minuty Przez Określoną Liczbę Minut. Każda Minuta Może Mieć Różne Ćwiczenia z Różnymi Wartościami.',
        'other': 'Nie Znaleziono',
      },
    );
    return '$_temp0';
  }

  @override
  String get skip => 'Pomiń';

  @override
  String get setDone => 'Ustaw jako zakończone';

  @override
  String titleTargetText(String title) {
    String _temp0 = intl.Intl.selectLogic(
      title,
      {
        'kg': 'KG',
        'deg': 'DEG',
        'm': 'DŁUGOŚĆ',
        'sec': 'CZAS',
        'cm': 'WYSOKOŚĆ',
        'irm': 'IRM',
        'lvl': 'POZIOM',
        'reps': 'POWTÓRZENIA',
        'w': 'WAT',
        'kcal': 'KCAL',
        'rpm': 'RPM',
        'other': 'PRĘDKOŚĆ',
      },
    );
    return '$_temp0';
  }
}
