

import UIKit

class DatePickerContentView: UIView, UIContentView {
    struct Configuration: UIContentConfiguration {
        var date = Date.now
        var onChange: (Date) ->Void = { _ in }
        
        func makeContentView() -> UIView & UIContentView {
            return DatePickerContentView(self)
        }
    }
    
    let datePicker = UIDatePicker()
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }

    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        addPinnedSubview(datePicker)
        datePicker.addTarget(self, action: #selector(didPick(_ :)), for: .valueChanged) //
        datePicker.preferredDatePickerStyle = .inline
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        datePicker.date = configuration.date
    }

    //MARK: - 미리알림날짜 편집내용 저장
    @objc private func didPick(_ sender: UIDatePicker) { // 미리알림날짜 편집내용 저장
        guard let configuration = configuration as? DatePickerContentView.Configuration else { return }
        configuration.onChange(sender.date) //새 날짜 전달
    }

}
extension UICollectionViewListCell {
    func datePickerConfiguration() -> DatePickerContentView.Configuration {
        DatePickerContentView.Configuration()
    }
}

