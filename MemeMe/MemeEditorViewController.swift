//
//  MasterViewController.swift
//  MemeMe
//
//  Created by Steven on 16/05/2015.
//  Copyright (c) 2015 Horsemen. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    /// Default text attributes for MemeMe
    let memeTextAttributes = [
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue", size: 40)!,
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSStrokeWidthAttributeName : -4.0
    ]
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set text field delegates
        topText.delegate = self
        bottomText.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Disable camera button if camera is not available
        self.cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        // Default Text Fields behavior
        self.topText.defaultTextAttributes = memeTextAttributes
        self.bottomText.defaultTextAttributes = memeTextAttributes
        self.topText.textAlignment = .Center
        self.bottomText.textAlignment = .Center
        
        // Disable share button by default
        self.shareButton.enabled = false;
        
        // Subscribe to keyboard event
        self.subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unsubscribe from keyboard event
        self.unsubscribeFromKeyboardNotifications()
    }

    /**
    Display image picker
    
    :param: source Type of image picker, default to PhotoLibrary
    */
    func displayImagePicker(source: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.PhotoLibrary) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    /**
    Subscribe to keyboard will show event
    */
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    /**
    Unsubscribe from keyboard will show event
    */
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    /**
    Shift view up if bottom text field is being edited
    
    :param: notification
    */
    func keyboardWillShow(notification: NSNotification) {
        if ( self.bottomText.isFirstResponder() ) {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    /**
    Shift view down if bottom text field finished editing
    
    :param: notification
    */
    func keyboardWillHide(notification: NSNotification) {
        if ( self.bottomText.isFirstResponder() ) {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    /**
    Return height of the keyboard
    
    :param: notification
    */
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    /**
    Generate the meme by capturing image of the current screen
    
    :returns: The meme image (instance of UIImage)
    */
    func generateMeme() -> UIImage {
        
        // Hide toolbar and navbar
        toolbar.hidden = true
        self.navigationController?.navigationBarHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memeImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        toolbar.hidden = false
        self.navigationController?.navigationBarHidden = false
        
        return memeImage
    }
    
    /**
    Save current meme
    */
    func saveMeme() {
        let memeImage = generateMeme()
        var meme = Meme(topText: topText.text, bottomText: bottomText.text, originalImage: memeImageView.image!, memeImage: memeImage)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    
    
    // MARK: Actions
    
    /**
    Show photo album picker
    
    :param: sender Album bar button item
    */
    @IBAction func showPhotoAlbum(sender: UIBarButtonItem) {
        displayImagePicker()
    }
    
    /**
    Show camera
    
    :param: sender Camera bar button item
    */
    @IBAction func showCamera(sender: UIBarButtonItem) {
        displayImagePicker(source: UIImagePickerControllerSourceType.Camera)
    }
    
    /**
    Return to meme list view
    */
    @IBAction func returnToList() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
    Show share menu
    
    :param: sender Share icon bar button item
    */
    @IBAction func showShareMenu(sender: UIBarButtonItem) {
        
        let memeImage = generateMeme()
        
        let shareView = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        self.presentViewController(shareView, animated: true, completion: nil)
        
    }
    
    // MARK: UIImagePickerController Delegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        // Retrieve the picked image and display it in the ImageView
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            self.memeImageView.image = image
        }
        
        self.dismissViewControllerAnimated(true) {
            // Enable share button
            self.shareButton.enabled = true
        }
        
    }
    
    // MARK: UITextField Delegate Methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Empty textfield
        textField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Remove keyboard when 'enter' pressed
        textField.resignFirstResponder()
        return true
    }

}

