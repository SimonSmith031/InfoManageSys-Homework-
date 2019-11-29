//
//  HistoryViewController.swift
//  SoccerPlayerInformationManagementSystem
//
//  Created by iOS_Club-18 on 2019/7/10.
//  Copyright © 2019 iOS_Club-18. All rights reserved.
//
import WebKit
import UIKit

class HistoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBOutlet weak var textField: UITextField!
    //网页视图
    @IBOutlet weak var webView: WKWebView!
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        guard let words = textField.text else {
            showAlert(msg: "绑定文本框失败！")
            return
        }
        guard let url = URL(string: "https://www.baidu.com/") else {
            showAlert(msg: "网页丢失！")
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
        showAlert(msg: "请在稍后出现的网页搜索框重新输入。")
    }
    
    func showAlert(msg: String){
        let alert = UIAlertController(title: "警告", message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}


