extension Duration {
    /// Creates a new duration using seconds component of the given duration.
    ///
    /// - Parameter source: A duration to be converted.
    init(secondsOf source: Duration) {
        self = .init(secondsComponent: source.components.seconds, attosecondsComponent: 0)
    }
}
