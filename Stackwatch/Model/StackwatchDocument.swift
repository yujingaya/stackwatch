import Foundation

struct StackwatchDocument: Codable {
    var title: String
    private(set) var dones: [Done]
    private(set) var todos: [Todo]

    init(title: String = "New Stack!") {
        self.title = title
        dones = []
        todos = []
    }
}

extension StackwatchDocument {
    mutating func appendTodo(_ name: String) {
        let todo = Todo(id: nextID, name: name)
        todos.append(todo)
    }

    mutating func done(with duration: TimeInterval) {
        assert(!todos.isEmpty)

        let todo = todos.removeFirst()
        let done = Done(todo, duration: duration)
        dones.append(done)
    }

    var totalDuration: TimeInterval {
        dones.map { $0.duration }.reduce(0, +)
    }

    private var nextID: Int {
        if let lastTodo = todos.last {
            return lastTodo.id + 1
        }
        if let lastDone = dones.last {
            return lastDone.id + 1
        }
        return 0
    }
}

struct Done: Codable, Identifiable {
    let id: Int
    var name: String
    var duration: TimeInterval

    init(_ todo: Todo, duration: TimeInterval) {
        self.id = todo.id
        self.name = todo.name
        self.duration = duration
    }
}

struct Todo: Codable, Identifiable {
    let id: Int
    var name: String
}
