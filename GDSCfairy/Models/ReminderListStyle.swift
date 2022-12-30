
import Foundation

enum ReminderListStyle: Int {
    case school
    case club
    case all
    
    var name: String {
            switch self {
            case .school:
                return NSLocalizedString("학교", comment: "")
            case .club:
                return NSLocalizedString("동아리", comment: "")
            case .all:
                return NSLocalizedString("All", comment: "")
            }
        }
        
    func shouldInclude(date: Date) -> Bool {
        let isInToday = Locale.current.calendar.isDateInToday(date)
        switch self {
                case .school:
                    return isInToday
                case .club:
                    return (date > Date.now) && !isInToday
                case .all:
                    return true
                }
    }
}
