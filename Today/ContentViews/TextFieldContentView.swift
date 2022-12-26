
import UIKit
import Alamofire

class TextFieldContentView: UIView, UIContentView {
    struct Configuration: UIContentConfiguration {
        var text: String? = ""
        var onChange: (String) ->Void = { _ in } // 빈 작업 핸들러 추가해서 텍스트필드의 텍스트 편집하려는 동작 포착
        
        func makeContentView() -> UIView & UIContentView {
            return TextFieldContentView(self)
        }
    }
    
    let textField = UITextField()
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 44)
    }
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        addPinnedSubview(textField, insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        textField.addTarget(self, action: #selector(didChange(_:)), for: .editingChanged) //이벤트 대상동작
        textField.clearButtonMode = .whileEditing
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        textField.text = configuration.text
    }
    
    //MARK: - 내용 편집내용 저장
    @objc private func didChange(_ sender: UITextField) {
        guard let configuration = configuration as? TextFieldContentView.Configuration else { return }
        configuration.onChange(textField.text ?? "")
        
        //  MARK: get
        //        AF.request("http://localhost:8080/category").responseJSON() { response in
        //          switch response.result {
        //          case .success:
        //            if let data = try! response.result.get() as? [String: Any] {
        //              print(data)
        //            }
        //          case .failure(let error):
        //            print("Error: \(error)")
        //            return
        //          }
        //        }
        //MARK: 피오니코드 (실패함)
        //        AF.request("http://34.64.114.243:8080/category", method: .post, parameters: ["key": "hello!"], encoding: URLEncoding.httpBody, headers: ["Content-Type":"application/json", "Accept":"application/json"] ).responseJSON() { response in
        //          switch response.result {
        //          case .success:
        //            if let data = try! response.result.get() as? [String: Any] {
        //              print(data)
        //            }
        //          case .failure(let error):
        //            print("Error: \(error)")
        //            return
        //          }
        //        }
        //
        //    }
        // MARK - 이거 됨
        let url = "http://34.64.114.243:8080/category"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        // POST 로 보낼 정보
        let params = ["제목":"내용", "상세내용":"내용상세"] as Dictionary
        //let params2 = ["제목":"이야", "상세내용":"우와" ] as Dictionary

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
            
            
            //        func getTest() {
            //                let url = "http://34.64.114.243:8080/category"
            //                AF.request(url,
            //                           method: .get,
            //                           parameters: nil,
            //                           encoding: URLEncoding.default,
            //                           headers: ["Content-Type":"application/json", "Accept":"application/json"])
            //                    .validate(statusCode: 200..<300)
            //                    .responseJSON { (json) in
            //                        //여기서 가져온 데이터를 자유롭게 활용하세요.
            //                        print(json)
            //                }
            //            }
            //        }
            //
        }
        
    }
    
}
//}

extension UICollectionViewListCell {
    func textFieldConfiguration() -> TextFieldContentView.Configuration {
        TextFieldContentView.Configuration()
    }
}

