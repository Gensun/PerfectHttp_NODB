//
//  ViewController.swift
//  Client
//
//  Created by Cheng Sun on 4/16/19.
//  Copyright © 2019 EF. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


private let BASE_URL = "http://127.0.0.1:8080"

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView! //portrait
    @IBOutlet weak var ageLb: UILabel!
    @IBOutlet weak var sexLb: UILabel!
    
    var token: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func Login(_ sender: UIButton) {
        let pwd = "123456"
        let username = "Genie"
        let url = BASE_URL + "/login"
        let params = ["username": username, "pwd": pwd]
        
        AF.request(url, method: .post, parameters: params).responseJSON { (DataResponse) in
            print(DataResponse)
            
            let value = DataResponse.value
            let json = JSON(value as Any)
            print(json["token"])
            self.token = json["token"].string
            
            // download profile
            self.profile((Any).self)
        }
    }
    
    @IBAction func profile(_ sender: Any) {

        let url = BASE_URL + "/profile"
        let params = ["token": self.token]
        
        AF.request(url, method: .post, parameters: params).responseJSON { (DataResponse) in
            print(DataResponse)
            
            let value = DataResponse.value
            let json = JSON(value as Any)
 
            self.sexLb.text = json["sex"].string
            self.ageLb.text = json["userage"].string
            
            if let path = json["portrait"].string {
                self.downloadPhoto(path)
            }
        }
    }
    
    private func downloadPhoto(_ path: String) {
        let url = BASE_URL + "/photo"
        let params = ["path": path]
        
        AF.request(url, method: .get, parameters: params).responseData { (DataResponse) in
            print(DataResponse)
            
            guard let imageData = DataResponse.value as? Data else {
                return
            }
            
            let image = UIImage(data: imageData)
            self.imageView.image = image
        }
    }
}

