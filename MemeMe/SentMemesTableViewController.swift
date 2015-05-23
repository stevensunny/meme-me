//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Steven on 21/05/2015.
//  Copyright (c) 2015 Horsemen. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Variables
    @IBOutlet weak var sentMemesTable: UITableView!
    
    var memes: [Meme]!
    
    // MARK: - View Lifecycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Retrieve memes data from App Delegate
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memes = appDelegate.memes
        
        // Reload sent memes' table if memes are not empty
        if memes.count > 0 {
            sentMemesTable.reloadData()
        }
    }
    
    // MARK: IB Actions
    /**
    Show meme editor screen
    
    :param: sender
    */
    @IBAction func showMemeEditor(sender: UIBarButtonItem) {
        let memeEditor = storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        presentViewController(memeEditor, animated: true, completion: nil)
    }
    
    // MARK: - Delegate Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SentMemesTableViewCell") as! SentMemesTableViewCell
        let meme = memes[indexPath.row]
        
        // Set the name and image for row
        cell.titleLabel?.text = meme.topText + " " + meme.bottomText
        cell.memeImage?.image = meme.memeImage
        
        return cell
        
    }

}