//
//  ScannerViewController.swift
//  FoodAppMaster
//
//  Created by Abby Breitfeld on 7/11/17.
//  Copyright © 2017 Princeton University. All rights reserved.
//

import UIKit
import Foundation

class ScannerViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var activityIndicator : UIActivityIndicatorView!
    let app = PublicMethods.sharedInstance
    var ingredients = [[Ingredient]]()
    var foundItems = [[Bool]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredients = app.loadAllIngredients()!
        
        for i in 0..<ingredients.count {
            foundItems.append([Bool]())
            for _ in 0..<ingredients[i].count {
                foundItems[i].append(false)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    
    @IBAction func backgroundTapped(_ sender: UIButton) {
        let imagePickerActionSheet = UIAlertController(title: "Upload or Take Photo", message: nil, preferredStyle: .actionSheet)
        // 3
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraButton = UIAlertAction(title: "Take Photo", style: .default) { (alert) -> Void in
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
            imagePickerActionSheet.addAction(cameraButton)
        }
        // 4
        let libraryButton = UIAlertAction(title: "Choose Existing", style: .default) { (alert) -> Void in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        imagePickerActionSheet.addAction(libraryButton)
        // 5
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (alert) -> Void in
        }
        imagePickerActionSheet.addAction(cancelButton)
        // 6
        present(imagePickerActionSheet, animated: true, completion: nil)
    }
    
    //MARK: Private Functions
    
    func scaleImage(_ image: UIImage, maxDimension: CGFloat) -> UIImage {
        
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        var scaleFactor:CGFloat
        
        if image.size.width > image.size.height {
            scaleFactor = image.size.height / image.size.width
            scaledSize.width = maxDimension
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            scaleFactor = image.size.width / image.size.height
            scaledSize.height = maxDimension
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        image.draw(in: CGRect(x: 0, y: 0, width: scaledSize.width, height: scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
    
    func performImageRecognition(_ image: UIImage) {
        // 1
        let tesseract = G8Tesseract()
        // 2
        tesseract.language = "eng+fra"
        // 3
        tesseract.engineMode = .tesseractCubeCombined
        // 4
        tesseract.pageSegmentationMode = .auto
        // 5
        tesseract.maximumRecognitionTime = 60.0
        // 6
        tesseract.image = image.g8_blackAndWhite()
        tesseract.recognize()
        // 7
        findIngredients(from: tesseract.recognizedText)
        // 8
        removeActivityIndicator()
        performSegue(withIdentifier: "showFoundIngredients", sender: nil)
    }
    
    func findIngredients(from string: String) {
        for i in 0..<ingredients.count {
            for j in 0..<ingredients[i].count {
                var name = ingredients[i][j].name
                if "s" == name.characters.last {
                    name = name.substring(to: name.index(name.endIndex, offsetBy: -1))
                }
                if string.localizedCaseInsensitiveContains(name) {
                    print(name)
                    foundItems[i][j] = true
                }
            }
        }
    }
    
    //MARK: Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        // Get the new view controller using segue.destinationViewController.
        guard let destinationController = segue.destination as? FoundItemsTableViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        // Pass the selected object to the new view controller.
        destinationController.ingredients = self.ingredients
        destinationController.foundItems = self.foundItems
    }
    
    //MARK: Activity Indicator methods
    
    func addActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: view.bounds)
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.25)
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    func removeActivityIndicator() {
        activityIndicator.removeFromSuperview()
        activityIndicator = nil
    }
    
    /*func addActivityIndicator() {
     activityIndicator = UIView(frame: view.bounds)
     activityIndicator.backgroundColor = UIColor.white
     activityIndicator.alpha = 1
     
     view.addSubview(activityIndicator)
     view.bringSubview(toFront: activityIndicator)
     UIView.animate(withDuration: 2.0, delay: 0, options: [.repeat, .autoreverse], animations: {
     self.activityIndicator.alpha = 0.5
     }, completion: nil)
     }*/
    
    //MARK: Delegate Methods
    
    // Image picker delegate method
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedPhoto = info[UIImagePickerControllerOriginalImage] as! UIImage
        let scaledImage = scaleImage(selectedPhoto, maxDimension: 640)
        
        addActivityIndicator()
        
        dismiss(animated: true, completion: {
            self.performImageRecognition(scaledImage)
        })
    }
    
    //MARK: Actions
    
    @IBAction func unwindToScanner(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? FoundItemsTableViewController {
            for i in 0..<sourceViewController.foundItems.count {
                for j in 0..<sourceViewController.foundItems[i].count {
                    if sourceViewController.foundItems[i][j] {
                        // Add to pantry
                        app.addToPantry(item: ingredients[i][j])
                    }
                }
            }
            for i in 0..<sourceViewController.foundItems.count {
                app.saveIngredients(section: i, ingredients: ingredients[i])
            }
        }
    }
}
