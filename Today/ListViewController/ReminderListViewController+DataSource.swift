import UIKit
import Alamofire


extension ReminderListViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Reminder.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Reminder.ID>
    
    var reminderCompletedValue: String {
        NSLocalizedString("Completed", comment: "Reminder completed value")
    }
    var reminderNotCompletedValue: String {
        NSLocalizedString("Not completed", comment: "Reminder not completed value")
    }
    
    func updateSnapshot(reloading idsThatChanged: [Reminder.ID] = []) { // 스냅샷 업데이트 + 미리알람 식별자 배열 수락
        let ids = idsThatChanged.filter { id in filteredReminders.contains(where: { $0.id == id }) }
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(filteredReminders.map { $0.id })
        if !ids.isEmpty {   // 배열이 들어있으면 => 스냅샷 식별자 미리알람 로드
            snapshot.reloadItems(ids)
        }
        dataSource.apply(snapshot)
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, id: Reminder.ID) {
        let reminder = reminder(for: id)
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = reminder.title
        contentConfiguration.secondaryText = reminder.dueDate.dayAndTimeText
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .caption1)
        cell.contentConfiguration = contentConfiguration
        
        var doneButtonConfiguration = doneButtonConfiguration(for: reminder)
        doneButtonConfiguration.tintColor = .todayListCellDoneButtonTint
        cell.accessibilityCustomActions = [ doneButtonAccessibilityAction(for: reminder) ]
        cell.accessibilityValue = reminder.isComplete ? reminderCompletedValue : reminderNotCompletedValue
        cell.accessories = [ .customView(configuration: doneButtonConfiguration), .disclosureIndicator(displayed: .always) ]
        
        var backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfiguration.backgroundColor = .todayListCellBackground
        cell.backgroundConfiguration = backgroundConfiguration
    }
    
    func completeReminder(with id: Reminder.ID) {   // 모델에서 미리알람 가져오고
        var reminder = reminder(for: id) // 여기서 미리알람 호출함
        reminder.isComplete.toggle()    //속성전환
        update(reminder, with: id)  //미리알람 업뎃
        updateSnapshot(reloading: [id])
    }
    
    private func doneButtonAccessibilityAction(for reminder: Reminder) -> UIAccessibilityCustomAction {
        let name = NSLocalizedString("Toggle completion", comment: "Reminder done button accessibility label")
        let action = UIAccessibilityCustomAction(name: name) { [weak self] action in
            self?.completeReminder(with: reminder.id)
            return true
        }
        return action
    }
    
    private func doneButtonConfiguration(for reminder: Reminder) -> UICellAccessory.CustomViewConfiguration {
        let symbolName = reminder.isComplete ? "circle.fill" : "circle"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        let button = ReminderDoneButton()   //main에서 버튼이 눌리는지
        button.addTarget(self, action: #selector(didPressDoneButton(_:)), for: .touchUpInside)  // 액션
        button.id = reminder.id //미리알람 속성식별
        button.setImage(image, for: .normal)
        return UICellAccessory.CustomViewConfiguration(customView: button, placement: .leading(displayed: .always))
      

        }
        
        func add(_ reminder: Reminder) {
            reminders.append(reminder)
        }
        func deleteReminder(with id: Reminder.ID) {
            let index = reminders.indexOfReminder(with: id)
            reminders.remove(at: index)
        }
        
        func reminder(for id: Reminder.ID) -> Reminder {
            let index = reminders.indexOfReminder(with: id)
            return reminders[index]
        }
        
        func update(_ reminder: Reminder, with id: Reminder.ID) {
            let index = reminders.indexOfReminder(with: id)
            reminders[index] = reminder
        }
    }
    
