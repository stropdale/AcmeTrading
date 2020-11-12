//
//  ImageCache.swift
//  Acme Trading Inc
//
//  Created by Richard Stockdale on 12/11/2020.
//

import Foundation
import UIKit

class ImageCache {
    
    class ImageItem {
        var image = UIImage.init(systemName: "person") // Default image
        var url: URL?
        var completed = false
        private var update: (() -> Void)?
        
        init(urlString: String) {
            guard let url = URL(string: urlString) else {
                completed = true
                return
            }
            
            self.url = url
            downloadImage()
        }
        
        private func downloadImage() {
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                guard let data = data, error == nil else {
                    self.completed = true
                    return
                }
                
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                    self.completed = true
                    
                    if let update = self.update {
                        update()
                    }
                }
            }.resume()
        }
        
        func registerForUpdates(update: @escaping () -> Void) {
            self.update = update
        }
    }
    
    var imageItems: [ImageItem]
    
    init(imageUrls: [String]) {
        imageItems = [ImageItem]()
        
        for url in imageUrls {
            imageItems.append(ImageItem(urlString: url))
        }
    }
}
