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
    
    var deleteButton: UIBarButtonItem!
    
    var selectedMeme: Meme!
    var selectedIndex: Int!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deleteButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: "deleteAction")
        navigationItem.rightBarButtonItem = deleteButton

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
    
    // MARK: Actions
    func deleteAction() {
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(selectedIndex)
        navigationController?.popViewControllerAnimated(true)
    }

}
