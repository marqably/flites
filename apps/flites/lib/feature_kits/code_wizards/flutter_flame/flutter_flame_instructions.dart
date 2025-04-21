/// This file contains the instructions for adding your Flites Spritesheet to Flutter Flame.
/// It is used to generate the code for the sprite file and the sprite state enum.
const flutterFlameInstructions = '''
# Adding your Flites Spritesheet to Flutter Flame

## Save the Image

After clicking export, you will get the generated sprite sheet for saving.
Save it somewhere in your `/asset/images` or where ever you keep your game assets within your project.
Make sure to remember the location for later.

## Add the generated code

Paste the following code in to a file named `{{sprite_name}}_sprite.g.dart`.
This file will used as a [mixin](https://dart.dev/language/mixins) for your own character/object Sprite file and should ideally not be changed, so you can always overwrite it with the latest generated version.

```dart
// {{sprite_name}}_sprite.g.dart
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

/// All available states of the {{spriteName}} sprite
enum {{SpriteName}}SpriteState { {{listOfStates}} }

/// A Mixin that provides a {{spriteName}} sprite for your game
/// 
/// Use it by adding it to your component and implementing the `load` method
/// 
/// ```dart
/// class {{SpriteName}} extends SpriteAnimationGroupComponent<{{SpriteName}}SpriteState> with {{SpriteName}}Sprite, HasGameReference<FlameGame>, ... {
///   {{SpriteName}}({super.position});
/// 
///   @override
///   Future<void> onLoad() async {
///     // initiate the sprite here
///     await load(game);
///   }
/// 
///   /// This is how you can switch between animations
///   @override
///   void onTapUp(TapUpEvent info) {
///     if (current == {{alternativeAnimationState}}) {
///       setState({{firstAnimationState}});
///       return;
///     }
/// 
///     // switch to the kicking animation by simply calling setState method with the new state
///     setState({{alternativeAnimationState}});
///   }
/// }
/// ```
mixin {{SpriteName}}Sprite on SpriteAnimationGroupComponent<{{SpriteName}}SpriteState> {
  /// the name of the sprite sheet
  final String sheetName = '{{spriteName}}';

  /// The raw animations
  final Map<{{SpriteName}}SpriteState, Map<String, String>> animationRows = {
    {{listOfAnimationRowConfigurations}}
  };

  /// The size of each tile
  final Vector2 tileSize = Vector2(100, 100);

  /// The animation, that will be used as the default animation
  late final {{SpriteName}}SpriteState defaultAnimation = {{firstAnimationState}};

  /// The sprite sheet image
  late final SpriteSheet spriteSheet;

  /// A map of all our loaded animations
  @override
  final Map<{{SpriteName}}SpriteState, SpriteAnimation> animations = {};

  Future<void> load(FlameGame game, String spriteMapPath) async {
    // load the sprite sheet
    final image = await game.images.load(spriteMapPath);
    spriteSheet = SpriteSheet(image: image, srcSize: tileSize);

    // create the animations
    final animationObj = <{{SpriteName}}SpriteState, SpriteAnimation>{};
    for (final row in animationRows.entries) {
      animationObj[row.key] = getAnimation(row.key);
    }

    animations = animationObj;

    // set the default animation
    current = defaultAnimation;
  }

  void setState({{SpriteName}}SpriteState state) {
    // set the current animation
    current = state;
  }

  SpriteAnimation getAnimation(
    {{SpriteName}}SpriteState row, {
    int? to,
    int? from,
    double? stepTime,
    bool? loop,
  }) {
    // get the row animation
    final rowIndex = animationRows[row];

    // check if the row is valid
    if (rowIndex == null) {
      throw Exception(
        'SpriteSheet \$sheetName is missing row \$row in animationRows',
      );
    }

    // create a new animation from the row
    return spriteSheet.createAnimation(
      row: int.parse(rowIndex['row']!),
      stepTime: stepTime ?? double.parse(rowIndex['stepTime']!),
      loop: loop ?? (rowIndex['loop'] == 'true'),
      from: from ?? int.parse(rowIndex['from']!),
      to: to ?? int.parse(rowIndex['to']!),
    );
  }
}
```

## Create main Sprite file

Create a sprite file and use the mixin as part of it.
This is the file you can make changes in and should adjust logic, if you need it.

(the following code is just a first time template to get started)


```dart
// {{sprite_name}}.dart
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

import '{{sprite_name}}_sprite.g.dart';

class {{SpriteName}} extends SpriteAnimationGroupComponent<{{SpriteName}}SpriteState> with {{SpriteName}}Sprite, TapCallbacks, HasGameReference<FlameGame> {
  {{SpriteName}}({super.position});

  @override
  Future<void> onLoad() async {
    // initializing flites generated {{SpriteName}} animations
    // the second parameter is the file path relative to /assets/images.
    // If it differs from /assets/images/{{file_name}}, you might have to adjust it.
    await load(game, '{{file_name}}');
  }
  
  // example of how to change the animations on tap events
  @override
  void onTapUp(TapUpEvent info) {
    // using `current` you can get the currently active state
    if (current == {{alternativeAnimationState}}) {
      // using setState you change to another animation state
      setState({{firstAnimationState}});
      return;
    }
    
    setState({{alternativeAnimationState}});
  }
}
```

## Getting current state

The get your currently active animation, you can just use the `current` prop on your `{{sprite_name}}.dart` class.

```dart
    print('Active animation: \$current');
}
```

## Switching animations

To switch animations, you can just call `setState({{SpriteName}}SpriteState newState)` in your `{{sprite_name}}.dart` file.

```dart
  setState({{alternativeAnimationState}});
```

## Performing actions before/after/... animation change

We use Flames [SpriteAnimationGroupComponent](https://docs.flame-engine.org/latest/flame/components.html#spriteanimationgroupcomponent) here, so you can easily hook into the different actions and use them.

You can also use it just like a regular manually created `SpriteAnimationGroupComponent`. So check out the Flame documentation about this:
https://docs.flame-engine.org/latest/flame/components.html#spriteanimationgroupcomponent
''';
