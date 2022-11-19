import Foundation

struct StackwatchDocument: Codable {
    var title: String
    private(set) var dones: [Done]
    private(set) var todos: [Todo]

    init(title: String = "New Stack!") {
        self.title = title
        dones = []
        todos = [.listUpTodos]
    }
}

extension StackwatchDocument {
    mutating func appendTodo(_ todo: Todo) {
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
}

struct Done: Codable {
    var name: String
    var duration: TimeInterval

    init(_ todo: Todo, duration: TimeInterval) {
        self.name = todo.name
        self.duration = duration
    }
}

struct Todo: Codable {
    var name: String
}

extension Todo {
    static var listUpTodos: Todo { Todo(name: "List up to-dos") }
}
