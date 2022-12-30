
import UIKit
import Alamofire

class ReminderListViewController: UICollectionViewController {
    var dataSource: DataSource!
    var reminders: [Reminder] = Reminder.sampleData
    
    var filteredReminders: [Reminder] {
        return reminders.filter { listStyle.shouldInclude(date: $0.dueDate) }.sorted { $0.dueDate < $1.dueDate }
    }
    var listStyle: ReminderListStyle = .school
    let listStyleSegmentedControl = UISegmentedControl(items: [
        ReminderListStyle.school.name, ReminderListStyle.club.name, ReminderListStyle.all.name
    ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listLayout = listLayout()
        collectionView.collectionViewLayout = listLayout
        
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        
        dataSource = DataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Reminder.ID) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didPressAddButton(_:)))
        addButton.accessibilityLabel = NSLocalizedString("Add reminder", comment: "Add button accessibility label")
        navigationItem.rightBarButtonItem = addButton

        listStyleSegmentedControl.selectedSegmentIndex = listStyle.rawValue
        listStyleSegmentedControl.addTarget(self, action: #selector(didChangeListStyle(_:)), for: .valueChanged)

        navigationItem.titleView = listStyleSegmentedControl

        updateSnapshot()
        
        collectionView.dataSource = dataSource
    }
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
       
      
        
        //목록 셀 선택하고 거기로 변경하기 or 다른동작 시작하기
        let id = filteredReminders[indexPath.item].id  // 이 경로랑 연결된 식별자를 검색
        showDetail(for: id) // 탐색에서 상세 뷰 컨트롤러 추가해서 상세뷰가 화면에 푸시됨
        return false
    }
    
    func showDetail(for id: Reminder.ID) {  // 미리알람 식별자
        let reminder = reminder(for: id)
        let viewController = ReminderViewController(reminder: reminder) { [ weak self] reminder in
            self?.update(reminder, with: reminder.id)
            self?.updateSnapshot(reloading: [reminder.id]) 
        }// 뭐 검색햇지?
        navigationController?.pushViewController(viewController, animated: true)// 탐색 컨트롤러에 푸시
    }
    
    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.trailingSwipeActionsConfigurationProvider = makeSwipeActions
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
    private func makeSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
           guard let indexPath = indexPath, let id = dataSource.itemIdentifier(for: indexPath) else { return nil }
           let deleteActionTitle = NSLocalizedString("Delete", comment: "Delete action title")
           let deleteAction = UIContextualAction(style: .destructive, title: deleteActionTitle) { [weak self] _, _, completion in
               self?.deleteReminder(with: id)
               self?.updateSnapshot()
               completion(false)
               
               
               func deleteMethod() {
                   AF.request("http://34.64.114.243:8080/category/todos/1", method: .delete, parameters: nil, headers: nil).validate(statusCode: 200 ..< 299).responseData { response in
                       switch response.result {
                           case .success(let data):
                               do {
                                   guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                                       print("Error: Cannot convert data to JSON object")
                                       return
                                   }
                                   guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                                       print("Error: Cannot convert JSON object to Pretty JSON data")
                                       return
                                   }
                                   guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                                       print("Error: Could print JSON in String")
                                       return
                                   }

                                   print(prettyPrintedJson)
                               } catch {
                                   print("Error: Trying to convert JSON data to string")
                                   return
                               }
                           case .failure(let error):
                               print(error)
                       }
                   }
               }
           }
           return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
