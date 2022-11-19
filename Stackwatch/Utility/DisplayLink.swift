#if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst)
import QuartzCore
#elseif os(macOS)
import CoreVideo
#endif

/// A namespace for utilities related to the display link
enum DisplayLink {
    /// An asynchronous sequence of display frames.
    static var frames: AsyncStream<Void> {
        AsyncStream { continuation in
            let displayLink = RawDisplayLink {
                continuation.yield()
            }

            guard let displayLink else {
                continuation.finish()
                return
            }

            continuation.onTermination = { _ in
                displayLink.stop()
            }
        }
    }
}

#if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst)
// MARK: - CADisplayLink

private final class RawDisplayLink {
    private var displayLink: CADisplayLink!
    private let handler: () -> Void

    init?(_ handler: @escaping () -> Void) {
        self.handler = handler
        displayLink = CADisplayLink(target: self, selector: #selector(handle(_:)))
        displayLink.add(to: .current, forMode: .common)
    }

    func stop() {
        displayLink.invalidate()
    }

    @objc
    private func handle(_: CADisplayLink) {
        handler()
    }
}

#elseif os(macOS)
// MARK: - CVDisplayLink

private struct RawDisplayLink {
    private let displayLink: CVDisplayLink

    // This is a failable initializer instead of throwing one because
    // we think there's no good way to cope with these failures.
    init?(_ handler: @escaping () -> Void) {
        let handler: CVDisplayLinkOutputHandler = { _, _, _, _, _ in
            handler()
            return 0
        }

        var displayLink: CVDisplayLink?
        guard CVDisplayLinkCreateWithActiveCGDisplays(&displayLink) == 0,
              let displayLink,
              CVDisplayLinkSetOutputHandler(displayLink, handler) == 0,
              CVDisplayLinkStart(displayLink) == 0 else {
            return nil
        }

        self.displayLink = displayLink
    }

    // CVDisplayLink deinit seems to be taking care of stopping it
    // but just to make sure
    func stop() {
        CVDisplayLinkStop(displayLink)
    }
}

#endif
// TODO: Fallback timer implementation?
