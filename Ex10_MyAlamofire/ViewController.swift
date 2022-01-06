//
//  ViewController.swift
//  Ex10_MyAlamofire
//
//  Created by 송윤근 on 2022/01/06.
//

import UIKit
import Alamofire
import SwiftyJSON


class ViewController: UIViewController {

    @IBOutlet weak var TextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onbtnRequest(_ sender: UIButton) {
        
        sendrequest()
        
    }
    
    func sendrequest() {
        //POST 방식
        let param : Parameters = [
            "user_id" : "Song",
            "user_pw" : "1234"
        ]
        let url : String = "http://nissisoft21.dothome.co.kr/login_test.php"
        
        Alamofire.request(url,
                          method: .post,
                          parameters: param,
                          encoding: URLEncoding.httpBody,
                          headers: ["Content-Type" : "application/x-www-form-urlencoded",
                                    "Accept" : "application/json"
                          
                          ]
                          
        ).validate(statusCode: 200..<300)
        .responseJSON(completionHandler: {
            (response) in
            print(response)
            
            self.parseJSON( response )
        })
    }
    
    func parseJSON(_ response: DataResponse<Any> ) {
        switch response.result {
        case .success(_):
            
            if let json = try? JSON(data: response.data!){
                let result = json["login_result"]["result"].string
                print(result!)
                TextView.text.append("\n\(result!)")
                
                let loginmsg = json["login_result"]["message"]
                print(loginmsg)
                TextView.text.append("\n\(loginmsg)")
                
                //배열로 가져올때
                
                let arrdata = json["login_result"]["list"].array
                for data in arrdata!{
                    let name = data["name"].string
                    print(name!)
                    self.TextView.text.append("\n\(name!)")
                    
                    let height = data["height"].string
                    print(height!)
                    self.TextView.text.append("\n\(height!)")
                }
            }
            break
        case .failure(_) :
            print("통신 실패 : ", String(describing: response.result.error))
            
            break
            
        }
    }
    
}

