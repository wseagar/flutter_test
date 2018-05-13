import 'package:meta/meta.dart';

@immutable
class CardState {

    // properties
    final double heartOpacity;
    final double crossOpacity;

    // constructor with default
    CardState({
        this.heartOpacity = 0.0,
        this.crossOpacity = 0.0
    });

    // allows to modify AuthState parameters while cloning previous ones
    CardState copyWith({
        double heartOpacity,
        double crossOpacity
    }) {
        return new CardState(
            heartOpacity: heartOpacity ?? this.heartOpacity,
            crossOpacity: crossOpacity ?? this.crossOpacity,
        );
    }

    factory CardState.fromJSON(Map<String, dynamic> json) => new CardState(
        heartOpacity: json['heartOpacity'],
        crossOpacity: json['crossOpacity'],
    );

    Map<String, dynamic> toJSON() => <String, dynamic>{
        'heartOpacity': this.heartOpacity,
        'crossOpacity': this.crossOpacity,
    };

    @override
    String toString() {
        return '''{
                heartOpacity: $heartOpacity,
                crossOpacity: $crossOpacity,
            }''';
    }
}