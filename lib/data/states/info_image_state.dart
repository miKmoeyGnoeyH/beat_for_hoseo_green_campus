import 'package:flutter/material.dart';

sealed class InfoImageState {}

final class InfoImageInitial extends InfoImageState {}

final class InfoImageLoading extends InfoImageState {}

final class InfoImageLoaded extends InfoImageState {
  final List<Image> imageList;

  InfoImageLoaded(this.imageList);
}

final class InfoImageError extends InfoImageState {}
