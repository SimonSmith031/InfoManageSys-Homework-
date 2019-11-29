//
//  Extensions.swift
//  SoccerPlayerInformationManagementSystem
//
//  Created by iOS_Club-18 on 2019/7/10.
//  Copyright © 2019 iOS_Club-18. All rights reserved.
//

import UIKit
import RealmSwift

class DBSoccerPlayer: Object{
    
    //给一个id作为主键
    @objc dynamic var id = 0
    
    //为了方便不提供初始化方法，可以直接使用
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
    @objc dynamic var nation: String = ""
    @objc dynamic var club: String?
    @objc dynamic var info: String?
    @objc dynamic var imageData: Data?
    
    //下面的重载不知何故没有提示，可能是因为用的objc的一部分语法吗？
    override class func primaryKey() -> String? {
        return "id"
    }
    
}


