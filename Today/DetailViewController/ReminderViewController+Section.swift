
import Foundation

extension ReminderViewController {
    enum Section: Int, Hashable {
        case view
        case title
        case date
        case notes
        case choice
        
        var name: String {
            switch self {
            case .view: return ""
            case .title:
                return NSLocalizedString("제목", comment: "제목을 입력하세요")
            case .date:
                return NSLocalizedString("날짜", comment: "날짜를 작성하세요")
            case .notes:
                return NSLocalizedString("상세내용", comment: "세부내용을 작성하세요")
            case .choice:
                return NSLocalizedString("학회", comment: "짜자잔")

            }
        }
    }
}

