import SwiftUI

struct ContentView: View {
    @Binding var document: StackwatchDocument

    @StateObject var stopwatch = Stopwatch()

    var body: some View {
        VStack {
            HStack {
                Button {
                    _ = stopwatch.reset()
                } label: {
                    Image(systemName: "checkmark.diamond.fill")
                }

                Button {
                    stopwatch.toggle()
                } label: {
                    Image(systemName: stopwatch.isRunning ? "pause.fill" : "play.fill")
                }
            }

            Text(Duration(secondsOf: stopwatch.duration).formatted())
                .monospacedDigit()

            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(StackwatchDocument()))
    }
}
