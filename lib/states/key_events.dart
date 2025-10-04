// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/services.dart';
import 'package:signals/signals.dart';

enum Modifier { main, shift }

class ModifierState {
  final List<Modifier> modifiers;

  const ModifierState({
    required this.modifiers,
  });

  bool get isMainPressed => modifiers.contains(Modifier.main);
  bool get isShiftPressed => modifiers.contains(Modifier.shift);

  ModifierState addModifierCopy(Modifier modifier) {
    final mods = List<Modifier>.from(modifiers);

    if (!mods.contains(modifier)) {
      mods.add(modifier);
    }

    return ModifierState(modifiers: mods);
  }

  ModifierState removeModifierCopy(Modifier modifier) {
    final mods = List<Modifier>.from(modifiers);
    mods.remove(modifier);
    return ModifierState(modifiers: mods);
  }
}

final modifierSignal = signal(const ModifierState(modifiers: []));

class ModifierController {
  static void listenToGlobalKeyboardEvents() {
    ServicesBinding.instance.keyboard.addHandler(_onKey);
  }

  void addModifier(Modifier? modifier) {
    if (modifier == null) {
      return;
    }
    modifierSignal.value = modifierSignal.value.addModifierCopy(modifier);
  }

  void removeModifier(Modifier? modifier) {
    if (modifier == null) {
      return;
    }

    modifierSignal.value = modifierSignal.value.removeModifierCopy(modifier);
  }
}

bool _onKey(KeyEvent event) {
  final key = event.logicalKey.keyLabel;

  if (event is KeyDownEvent) {
    ModifierController().addModifier(_getModifierFromKey(key));
  } else if (event is KeyUpEvent) {
    ModifierController().removeModifier(_getModifierFromKey(key));
  }

  return false;
}

Modifier? _getModifierFromKey(String pressedKey) {
  final key = pressedKey.toLowerCase();

  if (key.contains('meta') || key.contains('control')) {
    return Modifier.main;
  } else if (key.contains('shift')) {
    return Modifier.shift;
  }
  return null;
}
