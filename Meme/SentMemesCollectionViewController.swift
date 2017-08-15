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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        self.collectionView?.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addMeme(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "showAddMeme", sender: self)
        
    }
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.item]

        //let imageView = UIImageView(image: meme.memedImage)

        cell.memeImage.image = meme.memedImage
        return cell
    }
    
     
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath)
    {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    
    }
    

    
}
