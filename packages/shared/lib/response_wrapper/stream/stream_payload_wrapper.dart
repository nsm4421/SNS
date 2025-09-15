enum StreamEvent { insert, update, delete, error }

abstract class StreamPayloadWrapper<T> {
  StreamPayloadWrapper({required this.event});

  final StreamEvent event;
}

class StreamPayloadInserted<T> extends StreamPayloadWrapper<T> {
  StreamPayloadInserted({required this.inserted})
    : super(event: StreamEvent.insert);

  final T inserted;
}

class StreamPayloadUpdated<T> extends StreamPayloadWrapper<T> {
  StreamPayloadUpdated({required this.updated})
    : super(event: StreamEvent.update);

  final T updated;
}

class StreamPayloadDeleted<T> extends StreamPayloadWrapper<T> {
  StreamPayloadDeleted({required this.deleted})
    : super(event: StreamEvent.delete);

  final String deleted; // id
}

class StreamPayloadError<T> extends StreamPayloadWrapper<T> {
  StreamPayloadError() : super(event: StreamEvent.delete);
}
