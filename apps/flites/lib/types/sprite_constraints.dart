sealed class SpriteConstraints {}

class SpriteHeightConstrained extends SpriteConstraints {
  SpriteHeightConstrained(this.heightPx);
  final int heightPx;
}

class SpriteWidthConstrained extends SpriteConstraints {
  SpriteWidthConstrained(this.widthPx);
  final int widthPx;
}

class SpriteSizeConstrained extends SpriteConstraints {
  SpriteSizeConstrained(this.widthPx, this.heightPx);
  final int widthPx;
  final int heightPx;
}
