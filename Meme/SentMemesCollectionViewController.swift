//
//  SentMemesCollectionViewController.swift
//  Meme
//
//  Created by Ivan Kodrnja on 16/05/15.
//  Copyright (c) 2015 2plus2. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {




    var memes: [Meme]!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        self.collectionView?.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addMeme(sender: AnyObject) {
        self.performSegueWithIdentifier("showAddMeme", sender: self)
        
    }
    

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.item]

        //let imageView = UIImageView(image: meme.memedImage)

        cell.memeImage.image = meme.memedImage
        return cell
    }
    
     
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    
    }
    

    
}
