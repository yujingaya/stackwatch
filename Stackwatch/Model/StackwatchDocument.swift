import Foundation

struct StackwatchDocument: Codable {
    var title: String
    var dones: [Done]
    var todos: [Todo]

    init(title: String = "New Stack!") {
        self.title = title
        dones = []
        todos = [.listUpTodos]
    }
}

struct Done: Codable {
    var name: String
    var duration: TimeInterval
}

struct Todo: Codable {
    var name: String
}

extension Todo {
    static var listUpTodos: Todo { Todo(name: "List up to-dos") }
}
