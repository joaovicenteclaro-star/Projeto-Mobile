import 'package:flutter/material.dart';

/// Paleta central do TaskFlow.
/// Mantendo as cores aqui, todas as telas usam a mesma identidade visual.
class AppColors {
  AppColors._();

  static const ink = Color(0xFF1E2A38); // texto principal
  static const cloud = Color(0xFFF3F5F8); // fundo do app
  static const surface = Color(0xFFFFFFFF); // cartões e superfícies
  static const teal = Color(0xFF2F6F6B); // cor de destaque (marca)
  static const tealTint = Color(0xFFE1EDEC); // fundo suave da cor de destaque
  static const slate = Color(0xFF6B7785); // texto secundário
  static const outline = Color(0xFFE3E7EC); // bordas sutis

  // Cores funcionais de prioridade
  static const prioridadeBaixa = Color(0xFF4C9A6A);
  static const prioridadeMedia = Color(0xFFD9A441);
  static const prioridadeAlta = Color(0xFFD9534F);
}
