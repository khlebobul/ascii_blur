import 'dart:io';

class BlurState {
  final File? image;
  final double blurValue;
  final double asciiThreshold;

  const BlurState({
    this.image,
    this.blurValue = 0.0,
    this.asciiThreshold = 0.4,
  });

  BlurState copyWith({File? image, double? blurValue, double? asciiThreshold}) {
    return BlurState(
      image: image ?? this.image,
      blurValue: blurValue ?? this.blurValue,
      asciiThreshold: asciiThreshold ?? this.asciiThreshold,
    );
  }

  BlurState clear() {
    return const BlurState();
  }

  bool get hasImage => image != null;
}
