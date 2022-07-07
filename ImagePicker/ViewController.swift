//
//  ViewController.swift
//  ImagePicker
//
//  Created by Waylon Kumpe on 7/6/22.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

   
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var pickImageButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var sendButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    
    
    let MemeTextFieldDelegate = MemeTextDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTextFields(topTextField)
        initTextFields(bottomTextField)
        initView(clearValues: true, hideToolbars: false)
        initButtons(enableShare: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
  
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {

        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
  
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.image = image
            dismiss(animated: true, completion: nil)
                }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
          
       }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        view.frame.origin.y = -getKeyboardHeight(notification)
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    // MARK: Subscribe to Keyboard Notifications

    // Nofifies when keyboard appears/disappears

    func subscribeToKeyboardNotifications() {

    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    }



    // MARK: Unsubscribe from Keyboard Notifications

    func unsubscribeFromKeyboardNotifications() {



    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)

    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func save(memedImage: UIImage) {
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        initView(clearValues: true, hideToolbars: false)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func share(){
        let image = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        controller.completionWithItemsHandler = { (activityType, completed, returnedItems, activityError) -> () in
            if completed {
                self.save(memedImage: image)
                self.dismiss(animated: true, completion: nil)
                
            }
        }
        present(controller,animated: true, completion: nil)
    }
   
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        initView(clearValues: false, hideToolbars: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        var memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        initView(clearValues: false, hideToolbars: false)
        return memedImage
    }
    
    func initView(clearValues: Bool, hideToolbars: Bool){
        if clearValues{
            topTextField.text = "TOP"
            bottomTextField.text = "BOTTOM"
            imagePickerView.image  = nil
            initButtons(enableShare: false)
        }
        bottomToolBar.isHidden = hideToolbars
        topToolBar.isHidden = hideToolbars
    }
    
    func initButtons(enableShare: Bool){
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        sendButton.isEnabled = enableShare
    }
    
    func initTextFields(_ textField: UITextField){
        textField.delegate = MemeTextFieldDelegate
        textField.defaultTextAttributes = MemeTextFieldDelegate.memeTextAttributes
        textField.textAlignment = .center
    }
}

