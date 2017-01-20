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
        
        let imageAsset = post?.object(forKey: "asset") as? SKYAsset
        print(imageAsset?.url)
        
        
        newsCell.titleLabel.text = post?.object(forKey: "title") as! String
        newsCell.contentLabel.text = post?.object(forKey: "content") as! String
        
        

        return newsCell
    }

    
    @IBAction func addButtonDidTap(_ sender: AnyObject) {
        
        print("add")
        presentImagePicker();
    }
    
    func presentAddPostAlert(imageData: Data?) {
        let alertController = UIAlertController(title: "Add New Post", message: "", preferredStyle: .alert)
        
        
        PhotoHelper.upload(imageData: imageData!, onCompletion: {uploadedAsset in
            if (uploadedAsset != nil) {
                print("has photo")
                let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
                    alert -> Void in
                    
                    let titleField = alertController.textFields![0] as UITextField
                    let contentField = alertController.textFields![1] as UITextField
                    
                    print("Title \(titleField.text), content \(contentField.text)")
                    
                    
                    let post = SKYRecord(recordType: "post")
                    post?.setObject(titleField.text, forKey: "title"  as! NSCopying)
                    post?.setObject(contentField.text, forKey: "content" as! NSCopying)
                    post?.setObject(false, forKey: "done" as NSCopying)
                    post?.setObject(uploadedAsset, forKey: "asset" as NSCopying)

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
            } else {
                
                print("no photo")
                let alert = UIAlertController(title: "Error uploading photo", message:"Try again.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        })
        
    }
    
}

// MARK: Photo Upload

extension NewsTableViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .popover
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let resizedImageData = PhotoHelper.resize(image: pickedImage, maxWidth: 800, quality: 0.9) {
            presentAddPostAlert(imageData:resizedImageData)
            }
        dismiss(animated: true, completion: {
        })
    }
    
}
