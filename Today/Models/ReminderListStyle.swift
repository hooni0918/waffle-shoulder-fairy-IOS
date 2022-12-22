
import Foundation

enum ReminderListStyle: Int {
    case today
    case future
    case all
    
    var name: String {
            switch self {
            case .today:
                return NSLocalizedString("동아리", comment: "Today style name")
            case .future:
                return NSLocalizedString("학회", comment: "Future style name")
            case .all:
                return NSLocalizedString("All", comment: "All style name")
            }
        }
        
    func shouldInclude(date: Date) -> Bool {
        let isInToday = Locale.current.calendar.isDateInToday(date)
        switch self {
                case .today:
                    return isInToday
                case .future:
                    return (date > Date.now) && !isInToday
                case .all:
                    return true
                }
    }
}
