//
//  ImageUpload.swift
//  Expense
//
//  Created by Dipang Sheth on 11/03/18.
//  Copyright © 2018 Dipang Home. All rights reserved.
//

import Foundation
import UIKit

struct photoActionSheet {
    
    static func UploadPhotos(photoLibary: @escaping  () -> Void, camera : @escaping() -> Void) {
        let alertController = UIAlertController (title: "", message:"", preferredStyle: .actionSheet)
        
        let titleFont = [NSAttributedStringKey.font: fontPopins.Medium.of(size: 16)]
        let messageFont = [NSAttributedStringKey.font: fontPopins.Medium.of(size: 18)]
        let message = "Upload Invoice Receipt"
        let titleAttrString = NSMutableAttributedString(string: "", attributes: titleFont)
        let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
        messageAttrString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSRange(location:0,length:message.count))
        alertController.setValue(titleAttrString, forKey: "attributedTitle")
        alertController.setValue(messageAttrString, forKey: "attributedMessage")
                
        
        let galleryAction = UIAlertAction(title: "Choose from gallery", style: .default, handler: { (actionSheetController) -> Void in
            photoLibary()
        })
        
        let cameraAction = UIAlertAction(title: "Capture from camera", style: .default, handler: { (actionSheetController) -> Void in
            camera()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (actionSheetController) -> Void in
        })
        
        alertController.addAction(galleryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        alertController.view.tintColor = colorType.headerColor.color
        alertController.view.backgroundColor = UIColor.gray
        alertController.view.layer.cornerRadius = 40
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 1;
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}

struct DocumentDirctory {
    
    static func getDirectoryPath() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory
    }
    
    static func userDirctory(userId : String) -> URL {
        return self.getDirectoryPath().appendingPathComponent(userId)
    }
    
    static func folderDirctory(userId : String, folderName : String) -> URL {
        let userDir = self.userDirctory(userId: userId)
        return userDir.appendingPathComponent(folderName)
    }
}

extension UIImage {
    func resizeImage(newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / self.size.width
        let newHeight = newWidth // self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    } }

struct ChatImage {
    
    static func scaleThumbnailImage(maximumWidth: CGFloat, image : UIImage) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        let cgImage: CGImage = image.cgImage!.cropping(to: rect)!
        let scalImage = UIImage(cgImage: cgImage, scale: image.size.width / maximumWidth, orientation: image.imageOrientation)
        return scalImage
    }
    
    static func saveImageDocumentDirectory(ImageName : String, userId : String, folderName: String, image : UIImage){
        let fileManager = FileManager.default
        let folderPaths = DocumentDirctory.folderDirctory(userId:userId , folderName: folderName)
        if !fileManager.fileExists(atPath: folderPaths.path) {
            
            do {
                try FileManager.default.createDirectory(atPath: folderPaths.path, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                print("Error creating directory: \(error.localizedDescription)")
            }
        }
        let temp = folderPaths.appendingPathComponent(ImageName)
        if !fileManager.fileExists(atPath: temp.path) {
            do {
                try UIImagePNGRepresentation(image)!.write(to: temp)
            } catch {
                print(error.localizedDescription)
            }
        }
        print("Save Iamge Path -> \(temp)")
    }
    
    static func getImageFromDocumentDirectory(ImageName : String, userId : String, folderName: String) -> URL {
        
        let fileManager = FileManager.default
        let folderPaths = DocumentDirctory.folderDirctory(userId:userId , folderName: folderName)
        let filePath = folderPaths.appendingPathComponent(ImageName)
        return filePath
    }
    
    
    /*
     func deleteImageFromDocumentDirectory(ImageName : String, userId : String, folderName: String) -> Bool {
     
     let paths = DocumentDirctory.folderDirctory(userId:userId , folderName: folderName)+ImageName
     let fileManager = FileManager.default
     if fileManager.fileExists(atPath: paths){
     try! fileManager.removeItem(atPath: paths)
     return true
     }
     return false
     }
     
     func deleteDocumentDirectoryUserFolder(userId : String) -> Bool {
     
     let paths = DocumentDirctory.userDirctory(userId: userId)
     let fileManager = FileManager.default
     if fileManager.fileExists(atPath: paths){
     try! fileManager.removeItem(atPath: paths)
     return true
     }
     return false
     }*/
}

