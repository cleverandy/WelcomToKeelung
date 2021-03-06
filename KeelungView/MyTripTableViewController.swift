//
//  MyTripTableViewController.swift
//  KeelungView
//
//  Created by Andy on 2017/6/25.
//  Copyright © 2017年 AndyChung. All rights reserved.
//

import UIKit

class MyTripTableViewController: UITableViewController {

    
    
    @IBOutlet var MyTripTable: UITableView!
    
    var isUpdate = false
    var Triplist:[[String:String]] = []
    
    @IBOutlet weak var ViewName: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        
        let addNotificationName = Notification.Name("addNotification")
        NotificationCenter.default.addObserver(self, selector: #selector(self.addNotification(noti:)), name: addNotificationName, object: nil)
        
        let saveNotificationName = Notification.Name("saveNotification")
        NotificationCenter.default.addObserver(self, selector: #selector(self.saveNotification(noti:)), name: saveNotificationName, object: nil)
        
        //讀檔
        readFile()

    }
    //讀檔
    func readFile(){
        let fileManager = FileManager.default
        let docUrls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let docUrl = docUrls.first
        let url = docUrl?.appendingPathComponent("list.txt")
        if let listFile = NSArray(contentsOf: url!){
            Triplist = listFile as![Dictionary<String,String>]
        }
        
    }
    //寫檔
    func saveFile() {
        let fileManager = FileManager.default
        let docUrls =
            fileManager.urls(for: .documentDirectory,
                             in: .userDomainMask)
        let docUrl = docUrls.first
        let url = docUrl?.appendingPathComponent("list.txt")
        (Triplist as NSArray).write(to: url!, atomically:true)
        
        print("檔案路徑：")
        print(url)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isUpdate {
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at:[indexPath], with: UITableViewRowAnimation.automatic)
            isUpdate = false
        }
        
    }
    //刪除
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        Triplist.remove(at: indexPath.row)
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with:
                UITableViewRowAnimation.fade)
        }
        //寫檔
        saveFile()
    }
    
    
    func addNotification(noti:Notification) {
        self.Triplist.insert(noti.userInfo as! [String:String], at: 0)
        //寫檔
        saveFile()
        //更新畫面
        tableView.reloadData()
    }
    
    
    //編輯
    func saveNotification(noti:Notification) {
        if MyTripTable.indexPathForSelectedRow != nil {
            Triplist[MyTripTable.indexPathForSelectedRow!.row] = noti.userInfo as! [String:String]
        }
        //寫檔
        saveFile()
        //更新畫面
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure the cell...
        let dic = Triplist[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! TripPointTableViewCell
        
        cell.nameLabel.text = dic["name"]
        
        //讀相片
        let filePath = NSTemporaryDirectory() + dic["fileName"]! + ".png"
        let image = UIImage(contentsOfFile: filePath)
        
        //顯示相片
        cell.cellImageView.image = image
        
        return cell
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.destination is TripPointViewController {
            let controller = segue.destination as? TripPointViewController
            
            let indexPath = tableView.indexPathForSelectedRow
            controller?.listDic = Triplist[indexPath!.row]
        }
    }
    
}
