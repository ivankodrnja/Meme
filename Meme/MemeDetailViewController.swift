//
//  MemeDetailViewController.swift
//  Meme
//
//  Created by Ivan Kodrnja on 16/05/15.
//  Copyright (c) 2015 2plus2. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var meme: Meme!
    
    @IBOutlet weak var memeImage: UIImageView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        memeImage.image = meme.memedImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
