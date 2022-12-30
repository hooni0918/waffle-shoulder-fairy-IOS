import UIKit
import Alamofire

extension ReminderListViewController {
    
    @objc func didPressDoneButton(_ sender: ReminderDoneButton) {
        guard let id = sender.id else { return }
        completeReminder(with: id)
    }
    
    
    //              func getTest() {
    //                let url = "http://34.64.114.243:8080/category/1/todo"
    //                AF.request(url,
    //                      method: .get,
    //                      parameters: nil,
    //                      encoding: URLEncoding.default,
    //                      headers: [ "Content-Type":"application/json", "Accept":"application/json"])
    //                .validate(statusCode: 200..<300)
    //                .responseJSON { (json) in
    //                  //여기서 가져온 데이터를 자유롭게 활용하세요.
    //                  print(json)
    //                  print("1번")
    //                }
    //              }
    // }
    
    
    @objc func didPressAddButton(_ sender: UIBarButtonItem) {
        
        
        let reminder = Reminder(title: "", dueDate: Date.now)
        let viewController = ReminderViewController(reminder: reminder) { [ weak self] reminder in
            self?.add(reminder)
            self?.updateSnapshot()
            self?.dismiss(animated: true)
            
            let url = "http://34.64.114.243:8080/category/1/todo"
            
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.timeoutInterval = 10
            
            // POST 로 보낼 정보
            //        let params = ["categoryId": 1,
            //                      "content": title,
            //                      "isChecked": true,
            //                      "memo": notes] as Dictionary
            
            let params: [String: Any] = [
                "categoryId": 1,
                "content": "title",
                "isChecked": true,
                "memo": "223"]
            
            // httpBody 에 parameters 추가
            do {
                try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
            } catch {
                print("http Body Error")
            }
            
            AF.request(request).responseString { (response) in
                switch response.result {
                case .success:
                    print("POST 성공")
                case .failure(let error):
                    print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                }
                
            }
        }
        
        
        viewController.isAddingNewReminder = true
        viewController.setEditing(true, animated: false)
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didCancelAdd(_:)))
        viewController.navigationItem.title = NSLocalizedString("Add Reminder", comment: "Add Reminder view controller title")
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
        
    }
    
    @objc func didCancelAdd(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
        
        
    }
    
    
    @objc func didChangeListStyle(_ sender: UISegmentedControl) { // 필터링
        listStyle = ReminderListStyle(rawValue: sender.selectedSegmentIndex) ?? .school
        updateSnapshot()
        
        if listStyle == ReminderListStyle.school  {
            func getTest() {
                let url = "http://34.64.114.243:8080/category/1"
                AF.request(url,
                           method: .get,
                           parameters: nil,
                           encoding: URLEncoding.default,
                           headers: [ "Content-Type":"application/json", "Accept":"application/json"])
                
                
                .validate(statusCode: 200..<300)
                .responseJSON { (json) in
                    //여기서 가져온 데이터를 자유롭게 활용하세요.
                    print(json)
                    print("1번")
                }
            }
        }
        
        if listStyle == ReminderListStyle.club  {
            func getTest() {
                let url = "http://34.64.114.243:8080/category/2"
                AF.request(url,
                           method: .get,
                           parameters: nil,
                           encoding: URLEncoding.default,
                           headers: [ "Content-Type":"application/json", "Accept":"application/json"])
                
                
                .validate(statusCode: 200..<300)
                .responseJSON { (json) in
                    //여기서 가져온 데이터를 자유롭게 활용하세요.
                    print(json)
                    print("2번")
                }
            }
        }
        
        if listStyle == ReminderListStyle.all  {
            func getTest() {
                let url = "http://34.64.114.243:8080/category/3"
                AF.request(url,
                           method: .get,
                           parameters: nil,
                           encoding: URLEncoding.default,
                           headers: [ "Content-Type":"application/json", "Accept":"application/json"])
                
                
                .validate(statusCode: 200..<300)
                .responseJSON { (json) in
                    //여기서 가져온 데이터를 자유롭게 활용하세요.
                    print(json)
                    print("3번")
                }
                
                
            }
            
        }
        
        
    }
}
