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
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        self.tableView.reloadData()
    
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        let memeEditorVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        
        // present MemeEditor as per the spec if there are no memes
        if (memes.count == 0){
            presentViewController(memeEditorVC, animated: true, completion: nil)
        }
        
        // show edit button in the navigation bar on the left side
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }

    @IBAction func addMeme(sender: AnyObject) {
        self.performSegueWithIdentifier("showAddMeme", sender: self)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewCell") as! MemeTableViewCell
        
        let meme = self.memes[indexPath.row]
        
        // set the image and texts
        cell.memedImage.image = meme.memedImage
        cell.topLabel.text = meme.topText
        cell.bottomLabel.text = meme.bottomText
        
        return cell
        
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle{
        case UITableViewCellEditingStyle.Delete:
            // remove the deleted item from the shared model
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.removeAtIndex(indexPath.row)
            // remove the deleted item from the local copy of the model
            self.memes.removeAtIndex(indexPath.row)
            
            // remove the deleted item from the `UITableView`
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
        default:
            return
        }
    }
  
        
}