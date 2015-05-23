//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Steven on 23/05/2015.
//  Copyright (c) 2015 Horsemen. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    // MARK: Variables
    @IBOutlet weak var memeImageView: UIImageView!
    
    var selectedMeme: Meme!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        memeImageView.image = selectedMeme.memeImage
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
    }

}
