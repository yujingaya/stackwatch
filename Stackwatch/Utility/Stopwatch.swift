import Combine

/// A two-state stopwatch that updates its duration on each display frame.
@MainActor
final class Stopwatch: ObservableObject {
    @Published var duration: Duration = .zero
    @Published private var inner = StopwatchInner()

    private var task: Task<Void, Never>?

    var isRunning: Bool {
        inner.isRunning
    }

    func toggle() {
        if isRunning {
            task?.cancel()
            task = nil
        }
        else {
            task = Task {
                for await _ in DisplayLink.frames {
                    duration = inner.duration
                }
            }
        }
        inner.toggle()
    }

    func reset() -> Duration {
        inner.reset()
    }
}

/// This stopwatch does not notify you. Instead you need to poll ``duration`` as needed.
private struct StopwatchInner {
    private var last: ContinuousClock.Instant?
    private var durationUntilLast: Duration = .zero

    var isRunning: Bool {
        last != nil
    }

    var duration: Duration {
        let durationSinceLast = last?.duration(to: .now) ?? .zero
        return durationUntilLast + durationSinceLast
    }

    mutating func toggle() {
        if isRunning {
            durationUntilLast = duration
            last = nil
        } else {
            last = .now
        }
    }

    mutating func reset() -> Duration {
        let duration = duration
        self = .init(last: .now, durationUntilLast: .zero)
        return duration
    }
}
