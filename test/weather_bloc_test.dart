import 'package:bloc_test/bloc_test.dart';
import 'package:bloc_test_tutorial/bloc/bloc.dart';
import 'package:bloc_test_tutorial/bloc/weather_bloc.dart';
import 'package:bloc_test_tutorial/data/model/weather.dart';
import 'package:bloc_test_tutorial/data/weather_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  MockWeatherRepository mockWeatherRepository;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
  });

  group('Get weather', () {
    final exampleWeatherResponse =
        Weather(cityName: 'London', temperatureCelsius: 7);
    blocTest(
      'emits [WeatherLoading, WeatherError] when unsuccessful',
      build: () {
        when(mockWeatherRepository.fetchWeather(any)).thenThrow(NetworkError());
        return WeatherBloc(mockWeatherRepository);
      },
      act: (bloc) => bloc.add(GetWeather('London')),
      expect: [
        WeatherInitial(),
        WeatherLoading(),
        WeatherError("Couldn't fetch weather. Is the device online?"),
      ],
    );

    blocTest(
      'emits [WeatherLoading, WeatherLoaded] when successful',
      build: () {
        when(mockWeatherRepository.fetchWeather(any))
            .thenAnswer((_) async => exampleWeatherResponse);
        return WeatherBloc(mockWeatherRepository);
      },
      act: (bloc) => bloc.add(GetWeather('London')),
      expect: [
        WeatherInitial(),
        WeatherLoading(),
        WeatherLoaded(exampleWeatherResponse)
      ],
    );
  });
}
