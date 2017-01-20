//
//  NewsTableViewController.swift
//  swift-workshop
//
//  Created by David Ng on 19/1/2017.
//  Copyright © 2017 Skygear. All rights reserved.
//

import UIKit
import SKYKit

class NewsTableViewController: UITableViewController {

    var posts = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self;
        self.tableView.delegate = self;

        self.fetchData()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Post count : \(self.posts.count)")
        return self.posts.count
    }

    func onCompletion(_ posts:[Any]) {
        print("There are \(posts.count) posts")
        print(posts)
        self.posts = posts
        self.tableView.reloadData()
    }
    
    func fetchData () {
        let publicDB = SKYContainer.default().publicCloudDatabase
        let query = SKYQuery(recordType: "post", predicate: nil)
        let sortDescriptor = NSSortDescriptor(key: "_created_at", ascending: false)
        query?.sortDescriptors = [sortDescriptor]
    
        publicDB?.perform(query!, completionHandler: { posts, error in
            if let error = error {
                print("Error retrieving photos: \(error)")
                self.onCompletion(posts!)
            } else {
                self.onCompletion(posts!)
            }
        })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newsCell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell
        
        // Configure the cell...
        
        let record = self.posts[indexPath.row]
        let post = record as? SKYRecord
        newsCell.titleLabel.text = post?.object(forKey: "title") as! String
        newsCell.contentLabel.text = post?.object(forKey: "content") as! String
        

        return newsCell
    }

    
    @IBAction func addButtonDidTap(_ sender: AnyObject) {
        
        print("add")
        let alertController = UIAlertController(title: "Add New Post", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            
            let titleField = alertController.textFields![0] as UITextField
            let contentField = alertController.textFields![1] as UITextField
            
            print("Title \(titleField.text), content \(contentField.text)")
            
            
            let post = SKYRecord(recordType: "post")
            post?.setObject(titleField.text, forKey: "title"  as! NSCopying)
            post?.setObject(contentField.text, forKey: "content" as! NSCopying)
            post?.setObject(false, forKey: "done" as NSCopying)
            
            SKYContainer.default().publicCloudDatabase.save(post, completion: { (record, error) in
                if (error != nil) {
                    print("error saving post: \(error)")
                    return
                }
                
                self.posts.insert(record, at: 0)
                self.tableView.reloadData()
            })
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Title"
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Content"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

    
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
