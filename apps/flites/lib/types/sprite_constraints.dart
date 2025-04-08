sealed class SpriteConstraints {}

class SpriteHeightConstrained extends SpriteConstraints {
  final int heightPx;

  SpriteHeightConstrained(this.heightPx);
}

class SpriteWidthConstrained extends SpriteConstraints {
  final int widthPx;

  SpriteWidthConstrained(this.widthPx);
}

class SpriteSizeConstrained extends SpriteConstraints {
  final int widthPx;
  final int heightPx;

  SpriteSizeConstrained(this.widthPx, this.heightPx);
}
