//
//  ViewController.swift
//  SoccerPlayerInformationManagementSystem
//
//  Created by iOS_Club-18 on 2019/7/9.
//  Copyright © 2019 iOS_Club-18. All rights reserved.
//

import UIKit
import RealmSwift

class LogInViewController: UIViewController {

    var userName = ""
    var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //把下面那句话注释了之后就能够免密码登录
        (userName, password) = generateNewUserNameAndPassword()
    }

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func logInButtonPressed(_ sender: Any){
        if let userNameInput = userNameTextField.text, let passwordInput = passwordTextField.text{
            if userNameInput == userName && passwordInput == password{
                //满足登录条件
                performSegue(withIdentifier: "logInSucceeded", sender: nil)
            }else{
                showAlert()
            }
        }else{
            showAlert()
        }
    }
    
    //收起键盘
    @IBAction func keyboardResignButtonPressed(_ sender: Any) {
        if userNameTextField.isFirstResponder{
            userNameTextField.resignFirstResponder()
        }else if passwordTextField.isFirstResponder{
            passwordTextField.resignFirstResponder()
        }
    }
    
    @IBAction func infoGettingButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "获取到了您的用户！", message: "您的用户名是：\(userName)，密码是：\(password)", preferredStyle: .alert)
        let action = UIAlertAction(title: "我知道了", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //生成随机数和密码的函数
    func generateNewUserNameAndPassword() -> (uerName: String, password: String){
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let length = 4 // 用户名和密码的长度，后期可以修改
        var userName = ""
        var password = ""
        //生成空的用户名
        for _ in 0..<length{
            let index = Int(arc4random_uniform(UInt32(characters.count)))
            userName.append(characters[characters.index(characters.startIndex, offsetBy: index)])
        }
        for _ in 0..<length{
            let index = Int(arc4random_uniform(UInt32(characters.count)))
            password.append(characters[characters.index(characters.startIndex, offsetBy: index)])
        }
        return (userName, password)
    }
    
    //展示弹窗说明登录失败
    func showAlert(){
        let alert = UIAlertController(title: "登录失败", message: "用户名或密码不正确，或未完成输入", preferredStyle: .alert)
        let action = UIAlertAction(title: "我知道了", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

