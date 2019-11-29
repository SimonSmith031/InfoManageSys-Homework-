//
//  DetailInfoViewController.swift
//  SoccerPlayerInformationManagementSystem
//
//  Created by iOS_Club-18 on 2019/7/10.
//  Copyright © 2019 iOS_Club-18. All rights reserved.
//

import UIKit
import RealmSwift

class DetailInfoViewController: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //定义常量：图片视图的高度，与实际的约束相对应
    let heightOfImageView:CGFloat = 225
    var player: DBSoccerPlayer?
    
    //滚动视图的插座变量
    @IBOutlet weak var detailScrollView: UIScrollView!
    
    //足球运动员的信息展示控件
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var clubTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var nationTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailScrollView.delegate = self
        showDetail()
    }
    
    @IBAction func changePictureButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "选取图片", message: nil, preferredStyle: .actionSheet)
        let fromLibrary = UIAlertAction(title: "从相册", style: .default, handler: {
            (nothing) in
            
            let photoPicker =  UIImagePickerController()
            photoPicker.delegate = self
            photoPicker.allowsEditing = true
            photoPicker.sourceType = .photoLibrary
            //在需要的地方present出来
            self.present(photoPicker, animated: true, completion: nil)
            
        })
        let fromCamera = UIAlertAction(title: "从相机", style: .default, handler: {
            (nothing) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let  cameraPicker = UIImagePickerController()
                cameraPicker.delegate = self
                cameraPicker.allowsEditing = true
                cameraPicker.sourceType = .camera
                //在需要的地方present出来
                self.present(cameraPicker, animated: true, completion: nil)
            } else {
                print("此设备不支持拍照")
            }
            
        })
        let cancel = UIAlertAction(title: "取消...", style: .destructive, handler: nil)
        alert.addAction(fromCamera)
        alert.addAction(fromLibrary)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        let realm = try! Realm()
        
        if let image = imageView.image, let name = nameTextField.text, let club = clubTextField.text, let ageInString = ageTextField.text, let age = Int(ageInString), let nation = nationTextField.text, let info = descriptionTextView.text{
            
            //检查几个必要信息是否填写完整
            if name.isEmpty || club.isEmpty || nation.isEmpty {
                let alert = UIAlertController(title: "提示", message: "名字、所在俱乐部、国籍是必填项！", preferredStyle: .alert)
                let action = UIAlertAction(title: "我知道了", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                //终止操作
                return
            }
            
            let newPlayer = DBSoccerPlayer()
            //到这里，主键和图片都还没有设置，是默认值
            newPlayer.age = age
            newPlayer.club = club
            newPlayer.info = info
            newPlayer.nation = nation
            newPlayer.name = name
            newPlayer.imageData = image.pngData()
            
            if player == nil{
            //需要添加
                try! realm.write {
                    //设置一个新的id
                    let players = realm.objects(DBSoccerPlayer.self)
                    let id2 = players.max(ofProperty: "id")! + 1
                    newPlayer.id = id2
                    realm.add(newPlayer)
                }
            }else{
            //需要修改
                try! realm.write {
                    newPlayer.id = player!.id
                    realm.add(newPlayer, update: .modified)
                }
            }
            self.navigationController?.popViewController(animated: true)
        }else{
            
            //刚刚绑定失败了，说明年龄不是整数，不满足要求
            let alert = UIAlertController(title: "提示", message: "年龄不是规范的整数！", preferredStyle: .alert)
            let action = UIAlertAction(title: "我知道了", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //收起键盘
        for textField in [nameTextField, clubTextField, ageTextField, nationTextField]{
            if let unwrapedTextField = textField{
                if unwrapedTextField.isFirstResponder{
                    unwrapedTextField.resignFirstResponder()
                }
            }
        }
        if descriptionTextView.isFirstResponder{
            descriptionTextView.resignFirstResponder()
        }
        
        //图片伸缩变换
        let offsetY = scrollView.contentOffset.y
        //对图片做放大变换
        if offsetY < 0 {
            //计算参数
            let scale = (heightOfImageView - offsetY) / heightOfImageView
            let ty = (heightOfImageView - offsetY) / heightOfImageView * offsetY
            imageView.transform = CGAffineTransform(a: scale, b: 0, c: 0, d: scale, tx: 0, ty: ty)
            //矩阵变换太过迷幻更改原点才能正常，原因不详
            imageView.frame.origin.y = offsetY
        }
    }
    
    func showDetail(){
        guard let p = player else {return}
        //显示图片
        if let imagedata = p.imageData, let image = UIImage(data: imagedata){
            imageView.image = image
        }
        //显示其他信息
        nameTextField.text = p.name
        ageTextField.text = String(p.age)
        clubTextField.text = p.club
        nationTextField.text = p.nation
        descriptionTextView.text = p.info
    }
    
    //网上给的方法有点老了，需要使用新的方法
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        //获得照片
        let image:UIImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        
        // 拍照
        if picker.sourceType == .camera {
            //保存相册
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        }
        
        imageView.image = image
        
        self.dismiss(animated: true, completion: nil)
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//    }
    
    
    @objc func image(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject) {
        
        if error != nil {
            print("保存失败")
        } else {
            print("保存成功")
        }
    }
    
}
