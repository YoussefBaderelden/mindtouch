enum Direction {
  up,
  down,
  left,
  right,
  confirm,
  cancel;

  String get label => switch (this) {
        up => 'Up',
        down => 'Down',
        left => 'Left',
        right => 'Right',
        confirm => 'Confirm',
        cancel => 'Cancel',
      };

  String get hint => switch (this) {
        up => 'Imagine moving up',
        down => 'Imagine moving down',
        left => 'Imagine moving left',
        right => 'Imagine moving right',
        confirm => 'Imagine confirming',
        cancel => 'Imagine going back',
      };
}
