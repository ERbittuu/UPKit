    //
    //  ImageLoader.swift
    //  UPKit
    //
    //  Created by Utsav Patel on 05/11/2024.
    //

import UIKit
import CommonCrypto

public class ImageLoader {
    
    public static let shared = ImageLoader()
    private let imageCache = NSCache<NSString, UIImage>()
    
    private init() {} // Private initializer to prevent instantiation
    
        // Loads an image from a URL into the specified UIImageView
    public func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
            // Check cache first
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            completion(cachedImage)
            return
        }
        
            // Check local storage
        if let localImage = loadImageFromDisk(forKey: urlString) {
            imageCache.setObject(localImage, forKey: urlString as NSString)
            completion(localImage)
            return
        }
        
            // Fetch image from URL
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
                // Cache the image
            self.imageCache.setObject(image, forKey: urlString as NSString)
            
                // Save image permanently
            self.saveImageToDisk(image: image, forKey: urlString)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
    
        // Sets a placeholder image and animates the transition to the new image
    public func setImageWithTransition(to imageView: UIImageView, newImage: UIImage, duration: TimeInterval = 0.5) {
        UIView.transition(with: imageView, duration: duration, options: .transitionFlipFromLeft, animations: {
            imageView.image = newImage
        }, completion: nil)
    }
    
        // Saves an image to the local file system
    private func saveImageToDisk(image: UIImage, forKey key: String) {
        guard let data = image.pngData() else { return }
        let filename = generateFileName(for: key)
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent("\(filename).png")
        
        do {
            try data.write(to: fileURL)
        } catch {
            print("Error saving image: \(error)")
        }
    }
    
        // Loads an image from the local file system
    private func loadImageFromDisk(forKey key: String) -> UIImage? {
        let filename = generateFileName(for: key)
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent("\(filename).png")
        
        return UIImage(contentsOfFile: fileURL.path)
    }
    
        // Generate a safe filename based on the SHA256 hash of the URL
    private func generateFileName(for urlString: String) -> String {
        let data = Data(urlString.utf8)
        let hash = data.sha256()
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}

    // Extension to compute SHA256 hash
extension Data {
    func sha256() -> [UInt8] {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        self.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(self.count), &hash)
        }
        return hash
    }
}
