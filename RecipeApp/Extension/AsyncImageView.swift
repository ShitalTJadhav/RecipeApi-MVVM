//
//  AsyncImageView.swift
//  RecipeApp
//
//  Created by Tushar  Jadhav on 2019-01-18.
//  Copyright © 2019 Shital  Jadhav. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class AsyncImageView : UIImageView {
    
    var imageUrlString : String?
    var dataTask : URLSessionTask?
    
    func setImage(from urlString : String)  {
        
        self.image = nil

        imageUrlString = urlString
        
        //Check url is correct
        guard let url = URL(string: urlString) else {
            return
        }

        //Return cache image is if it alrady downloaded
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        // Start background thread so that image loading does not make app unresponsive
       DispatchQueue.global(qos: .background).async {
            
            guard let imageData = NSData(contentsOf: url) else {
                return
            }
            
            // When from background thread, UI needs to be updated on main_queue
            DispatchQueue.main.async {
                
                let imageToCache = UIImage(data: imageData as Data)!
                
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                
                self.image = imageToCache
            }
        }
    }
    
    func imageFromServerURL(_ URLString: String, placeHolder: UIImage?) {
        
        
        self.image = nil
        if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
            self.image = cachedImage as? UIImage
            return
        }
        
        if let url = URL(string: URLString) {
        dataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                //print("RESPONSE FROM API: \(response)")
                if error != nil {
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage, forKey: NSString(string: URLString))
                            self.image = downloadedImage
                        }
                    }
                }
            })
            dataTask?.resume()
        }
    }
    
    func cancelImageDownloading() {
        
        dataTask?.cancel()
    }
}


/*extension UIImageView {
    
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        
        // Start background thread so that image loading does not make app unresponsive
        DispatchQueue.global(qos: .background).async {
            
            let imageData:NSData = NSData(contentsOf: url)!
            
            // When from background thread, UI needs to be updated on main_queue
            DispatchQueue.main.async {
                let image = UIImage(data: imageData as Data)
                self.image = image
            }
        }
    }
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
    
}
*/
