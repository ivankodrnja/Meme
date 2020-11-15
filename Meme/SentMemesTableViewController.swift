//
//  SentMemesTableViewController.swift
//  Meme
//
//  Created by Ivan Kodrnja on 03/05/15.
//  Copyright (c) 2015 2plus2. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    var memes: [Meme]!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        self.tableView.reloadData()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        let memeEditorVC = self.storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        
        // present MemeEditor as per the spec if there are no memes
        if (memes.count == 0){
            present(memeEditorVC, animated: true, completion: nil)
        }
        
        // show edit button in the navigation bar on the left side
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    @IBAction func addMeme(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "showAddMeme", sender: self)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell") as! MemeTableViewCell
        
        let meme = self.memes[indexPath.row]
        
        // set the image and texts
        cell.memedImage.image = meme.memedImage
        cell.topLabel.text = meme.topText
        cell.bottomLabel.text = meme.bottomText
        
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle{
        case UITableViewCell.EditingStyle.delete:
            // remove the deleted item from the shared model
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.remove(at: indexPath.row)
            // remove the deleted item from the local copy of the model
            self.memes.remove(at: indexPath.row)
            
            // remove the deleted item from the `UITableView`
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            
        default:
            return
        }
    }
  
        
}
