//
//  SoccerPlayersTableViewController.swift
//  SoccerPlayerInformationManagementSystem
//
//  Created by iOS_Club-18 on 2019/7/9.
//  Copyright © 2019 iOS_Club-18. All rights reserved.
//

import UIKit
import RealmSwift

class SoccerPlayersTableViewController: UITableViewController {

    var players: Results<DBSoccerPlayer>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //获取Realm对象
        let realm = try! Realm()
        //初始化数据库
        initDataBase()
        players = realm.objects(DBSoccerPlayer.self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //按下添加按钮
    @IBAction func addButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "detailInfo", sender: nil)
    }
    
    //section数
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //行数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players!.count
    }

    //高度
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    //指定每一行的内容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "soccerPlayerCell")!
        let player = players![indexPath.row]
        
        //用tag获取控件
        let imageView = cell.contentView.viewWithTag(11) as! UIImageView
        let nameLabel = cell.contentView.viewWithTag(12) as! UILabel
        let infoLabel = cell.contentView.viewWithTag(13) as! UILabel
        
        //图片赋值
        if let data = player.imageData{
            imageView.image = UIImage(data: data)
        }else{
            imageView.image = UIImage(named: "缺省头像")
        }
        //设置图片的圆角，得到圆形的蒙板
        imageView.layer.cornerRadius = imageView.frame.width / 2
        //文本赋值
        nameLabel.text = player.name
        infoLabel.text = player.nation + "，\(player.age)岁"
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let player = players![indexPath.row]
        performSegue(withIdentifier: "detailInfo", sender: player)
    }
    
    //添加的时候则传送一个nil，如果是编辑则传送一个player的引用
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailInfo"{
            guard let nextViewController = segue.destination as? DetailInfoViewController else { return }
            //传过来的都是可以转换成DBSoccerPlayer类型的，但是可能传过来的是空的，如果是空的，我们就给一个nil作为sender
            nextViewController.player = sender as? DBSoccerPlayer
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let realm = try! Realm()
            try! realm.write {
                realm.delete(players![indexPath.row])
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}

extension SoccerPlayersTableViewController{
    
    //配置数据库的函数
    func initDataBase(){
        //使用默认的数据库
        let realm = try! Realm()
        //查询所有的记录
        let items = realm.objects(DBSoccerPlayer.self)
        //打印出数据库地址方面使用可视化工具辅助查看
        print(NSHomeDirectory())
        //已经有记录的话就不插入了
        
        if items.count>0 {
            return
        }
        //接下来数据库是空的
        let alert = UIAlertController(title: "提示", message: "目前数据库中没有任何记录，您希望添加我们为您准备的默认记录吗？", preferredStyle: .alert)
        let permitAction = UIAlertAction(title: "好的", style: .default, handler: {
            (nothing) in //传入一个闭包
            //设置第一个球员
            let p1 = DBSoccerPlayer()
            p1.name = "梅西"
            p1.age = 32
            p1.nation = "阿根廷"
            p1.info = "里奥·梅西（Lionel Messi），1987年6月24日出生于阿根廷圣菲省罗萨里奥市，阿根廷足球运动员，司职前锋，现效力于巴塞罗那足球俱乐部。"
            p1.imageData = UIImage(named: "Messi")!.jpegData(compressionQuality: 1)
            p1.club = "巴塞罗那足球俱乐部"
            p1.id = 1
            
            //设置第二个球员
            let p2 = DBSoccerPlayer()
            p2.name = "贝利"
            p2.age = 33
            p2.nation = "巴西"
            p2.info = "贝利（Pelé），全名埃德森·阿兰特斯·多·纳西门托（Edson Arantes do Nascimento），1940年10月23日出生于巴西，前巴西著名足球运动员，司职前锋，在巴西曾被誉为“球王”。"
            p2.imageData = UIImage(named: "贝利")!.pngData()
            p2.club = "不清楚"
            p2.id = 2
            
            //设置第三个球员
            let p3 = DBSoccerPlayer()
            p3.name = "内马尔"
            p3.age = 27
            p3.nation = "巴西"
            p3.info = "内马尔·达·席尔瓦·儒尼奥尔（Neymar da Silva Santos Júnior），1992年2月5日出生于巴西圣保罗州，巴西足球运动员，身兼巴西国家队队长，司职前锋。"
            p3.imageData = UIImage(named: "内马尔")!.jpegData(compressionQuality: 1)
            p3.club = "巴黎圣日耳曼"
            p3.id = 3
            
            //设置第四个球员
            let p4 = DBSoccerPlayer()
            p4.name = "苏亚雷斯"
            p4.age = 32
            p4.nation = "乌拉圭"
            p4.info = "路易斯·阿尔贝托·苏亚雷斯（Luis Alberto Suarez ），1987年1月24日出生于乌拉圭萨尔托 [1]  ，乌拉圭足球运动员，场上司职前锋，现效力于西甲的巴塞罗那足球俱乐部。"
            p4.imageData = UIImage(named: "苏亚雷斯")!.jpegData(compressionQuality: 1)
            p4.club = "巴塞罗那足球俱乐部"
            p4.id = 4
            
            //设置第五个球员
            let p5 = DBSoccerPlayer()
            p5.name = "Ronaldo"
            p5.age = 34
            p5.nation = "葡萄牙"
            p5.info = "克里斯蒂亚诺·罗纳尔多（Cristiano Ronaldo、C罗）1985年2月5日出生于葡萄牙马德拉岛丰沙尔，葡萄牙职业足球运动员，司职边锋、中锋，效力于意甲尤文图斯足球俱乐部。"
            p5.imageData = UIImage(named: "Ronaldo")!.jpegData(compressionQuality: 1)
            p5.club = "意甲尤文图斯足球俱乐部"
            p5.id = 5
            
            //数据持久化操作（类型记录也会自动添加的）
            try! realm.write {
                realm.add(p1)
                realm.add(p2)
                realm.add(p3)
                realm.add(p4)
                realm.add(p5)
            }
            
            //添加之后记得要刷新列表
            self.tableView.reloadData()
            
        })
        let cancelAction = UIAlertAction(title: "不用了", style: .cancel, handler: nil)
        alert.addAction(permitAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)

    }
    
}
