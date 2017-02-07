//
//  ViewController.swift
//  RealmSwift_Learn
//
//  Created by 陈旭 on 2017/1/20.
//  Copyright © 2017年 陈旭. All rights reserved.
//

import UIKit
import RealmSwift

class DemoObject : Object {
    
    dynamic var title = ""
    dynamic var date  = ""
    dynamic var sectionTitle = ""
    
}

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var notificationToken: NotificationToken?
    var realm :Realm!
    var objectsBySection = [Results<DemoObject>]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
//        let unsortedObjects = realm.objects(DemoObject.self).filter("sectionTitle == haha")
//        let sortedObjects = unsortedObjects.sorted(byProperty: "date", ascending: true)
//        objectsBySection.append(sortedObjects)
//
        realm = try? Realm()
        notificationToken = realm.addNotificationBlock({ [unowned self](note, realm) in
            self.tableView.reloadData()
        })
//        realm = try! Realm()
        objectsBySection = [realm.objects(DemoObject.self)]
        print(objectsBySection[0].count)
        // Do any additional setup after loading the view, typically from a nib.
    }
    func setUI()  {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "+", style: .plain, target: self, action: #selector(ViewController.backgroudAdd))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(ViewController.addRight))
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectsBySection[0].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "cellID"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
//        var cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        if cell == nil {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: cellID)
        }
        let model = objectsBySection[0][indexPath.row]
        
        cell?.textLabel?.text = model.title
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = objectsBySection[0][indexPath.row]
//        model.title = "2222"
   
    }
    func objectForIndexPath(indexPath: IndexPath) -> DemoObject? {
        return objectsBySection[indexPath.section][indexPath.row]
    }

    func backgroudAdd()  {
        DispatchQueue.global().async {
            let realm = try! Realm()
            realm.beginWrite()
            for _ in 0 ..< 5 {
                realm.create(DemoObject.self, value: ["title":self.randomTitle(),"date":"2017-01-21","sectionTitle":"haha"])
            }
            try! realm.commitWrite()
        }
    }
    func addRight() {
         let user = DemoObject()
        user.title = "haha"
        realm = try! Realm()
        try! realm.write {
            realm.add(user)
        }
        
    }
    func randomTitle() -> String {
        return "Title \(arc4random())"
    }
}

