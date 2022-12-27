
import Foundation

struct Reminder: Equatable, Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var dueDate: Date
    var notes: String? = nil
    var isComplete: Bool = false
}

extension Array where Element == Reminder {
    func indexOfReminder(with id: Reminder.ID) -> Self.Index {
        guard let index = firstIndex(where: { $0.id == id }) else {
            fatalError()
        }
        return index
    }
}

// 아니 왜안돼
#if DEBUG
extension Reminder {
    static var sampleData = [
        Reminder(title: "테스트", dueDate: Date().addingTimeInterval(800.0), notes: "안녕하세요"),
        Reminder(title: "테스트트", dueDate: Date().addingTimeInterval(14000.0), notes: "오늘의 날씨는요", isComplete: true),
        Reminder(title: "테스트트트", dueDate: Date().addingTimeInterval(24000.0), notes: "날이 추워요"),
        Reminder(title: "테스트트트트", dueDate: Date().addingTimeInterval(3200.0), notes: "개추워 크레용", isComplete: true),
        Reminder(title: "테스트트트트트", dueDate: Date().addingTimeInterval(60000.0), notes: "감기 조심하세요"),
        Reminder(title: "테테스스트트", dueDate: Date().addingTimeInterval(72000.0), notes: "감기야 조심해!"),
    ]
}
#endif

