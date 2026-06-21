enum ReadingStatus {
  wantToRead,
  currentlyReading,
  finished,
  dropped;

  String toDb() {
    switch (this) {
      case ReadingStatus.wantToRead:
        return 'want_to_read';
      case ReadingStatus.currentlyReading:
        return 'currently_reading';
      case ReadingStatus.finished:
        return 'finished';
      case ReadingStatus.dropped:
        return 'dropped';
    }
  }

  static ReadingStatus fromDb(String s) {
    switch (s) {
      case 'want_to_read':
        return ReadingStatus.wantToRead;
      case 'currently_reading':
        return ReadingStatus.currentlyReading;
      case 'finished':
        return ReadingStatus.finished;
      case 'dropped':
        return ReadingStatus.dropped;
      default:
        return ReadingStatus.wantToRead;
    }
  }

  String get label => switch (this) {
    wantToRead => 'Want to Read',
    currentlyReading => 'Currently Reading',
    finished => 'Finished',
    dropped => 'Dropped',
  };
}
