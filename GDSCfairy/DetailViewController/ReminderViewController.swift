import UIKit
import Alamofire

class ReminderViewController: UICollectionViewController {
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Row>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    
    var reminder: Reminder {    //미리알람 추가시 호출
        didSet {
            onChange(reminder)
        }
    }
    
    var workingReminder: Reminder   // 임시알람 저장
    var isAddingNewReminder = false
    var onChange: (Reminder) -> Void
    private var dataSource: DataSource!
    
    init(reminder: Reminder, onChange: @escaping (Reminder) -> Void ) {  //미리알람 수락+초기화
        self.reminder = reminder
        self.workingReminder = reminder //초기내용 속성에 복사하기
        self.onChange = onChange
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)  //목록구성
        listConfiguration.showsSeparators = false   //셀 구분선 삭제하기
        listConfiguration.headerMode = .firstItemInSection
        let listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration) //레이아웃 정보 표시하기
        super.init(collectionViewLayout: listLayout)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("Always initialize ReminderViewController using init(reminder:)")
        
    }
    
    var nextButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        dataSource = DataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Row) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        navigationItem.title = NSLocalizedString("Reminder", comment: "Reminder view controller title")
        navigationItem.rightBarButtonItem = editButtonItem //edit done 자동으로 바꿔줌  (setEditing 에서)
        
        updateSnapshotForViewing()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            prepareForEditing() //현재 편집중인 모드와 일치하도록 제목 자동변경
        } else {
            if !isAddingNewReminder {
                prepareForViewing()
            } else {
                onChange(workingReminder)
            }
        }
    }
        
        func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: Row) {  // 셀 인덱스 경로 와 행
            let section = section(for: indexPath)
            switch (section, row) {
            case (_, .header(let title)):
                cell.contentConfiguration = headerConfiguration(for: cell, with: title)
            case (.view, _):
                cell.contentConfiguration = defaultConfiguration(for: cell, at: row)
            case (.title, .editText(let title)):
                cell.contentConfiguration = titleConfiguration(for: cell, with: title)
            case (.date, .editDate(let date)):
                cell.contentConfiguration = dateConfiguration(for: cell, with: date)
            case (.notes, .editText(let notes)):
                cell.contentConfiguration = notesConfiguration(for: cell, with: notes)
            default:
                fatalError("Unexpected combination of section and row.")
            }
            cell.tintColor = .todayPrimaryTint
        }
        
        @objc func didCancelEdit() {
            workingReminder = reminder
            setEditing(false, animated: true) //편집표시
        }
        
        private func prepareForEditing() {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didCancelEdit))
            updateSnapshotForEditing()
        }
        
        private func updateSnapshotForEditing() {   //스냅샷 섹션추가
            var snapshot = Snapshot()
            snapshot.appendSections([.title, .date, .notes])
            snapshot.appendItems([.header(Section.title.name), .editText(reminder.title)], toSection: .title)
            snapshot.appendItems([.header(Section.date.name), .editDate(reminder.dueDate)], toSection: .date)
            snapshot.appendItems([.header(Section.notes.name), .editText(reminder.notes)], toSection: .notes)
            dataSource.apply(snapshot)
        }
        
        private func prepareForViewing() {  // 편집내용 저장하기위한 임시알림 섹션 (들어가고 나갈때 설정작업 설정)
            navigationItem.leftBarButtonItem = nil  // 편집모드이면 == 취소버튼 생성
            if workingReminder != reminder {
                reminder = workingReminder // 미리알람 업뎃
            }
            updateSnapshotForViewing()
        }
        
        private func updateSnapshotForViewing() {
            var snapshot = Snapshot()
            snapshot.appendSections([.view])
            snapshot.appendItems([.header(""), .viewTitle, .viewDate, .viewTime, .viewNotes], toSection: .view)
            
            dataSource.apply(snapshot)
        }
        
        private func section(for indexPath: IndexPath) -> Section { //인덱스 경로
            let sectionNumber = isEditing ? indexPath.section + 1 : indexPath.section
            guard let section = Section(rawValue: sectionNumber) else {
                fatalError("Unable to find matching section")
            }
            return section
        }
    }
    

