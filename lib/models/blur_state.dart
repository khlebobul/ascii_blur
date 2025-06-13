import 'dart:io';

class BlurState {
  final File? image;
  final double blurValue;

  const BlurState({this.image, this.blurValue = 0.0});

  BlurState copyWith({File? image, double? blurValue}) {
    return BlurState(
      image: image ?? this.image,
      blurValue: blurValue ?? this.blurValue,
    );
  }

  BlurState clear() {
    return const BlurState();
  }

  bool get hasImage => image != null;
}
