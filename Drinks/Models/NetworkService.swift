//
//  NetworkService.swift
//  Drinks
//
//  Created by Andrii Zuiok on 18.10.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import UIKit

protocol NetworkServiceProtocol {
    func getAllCategories(completion: @escaping ([DrinkCategory]?)->())
    func getCategoryFor(categoryName: String, completion: @escaping (Category)->())
    func getImageForUrl(imageUrl: URL, completion:  @escaping (UIImage?)-> ())
    func endDownload(url: URL)
}

class NetworkService: NetworkServiceProtocol {
    
    private let baseUrlString = "https://www.thecocktaildb.com/api/json/v1/1/"
    
    private var operations: [URL: Operation] = [:]
    private let queue = OperationQueue()
    
    func getAllCategories(completion: @escaping ([DrinkCategory]?)->()) {
        let urlString = baseUrlString + "list.php?c=list"
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil, let data = data else { return }
            do {
                let drinksCategories = try JSONDecoder().decode(DrinksCategories.self, from: data)
                if let categories = drinksCategories.drinksCategories {
                    DispatchQueue.main.async { completion(categories) }
                } else {
                    DispatchQueue.main.async { completion(nil) }
                }
            } catch {
                DispatchQueue.main.async { completion(nil) }
            }
        }.resume()
    }
    
    func getCategoryFor(categoryName: String, completion: @escaping (Category)->()) {
        
        let encodedCategory = categoryName.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        let urlString = baseUrlString + "filter.php?c=\(encodedCategory)"
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil, let data = data else { return }
            do {
                var category = try JSONDecoder().decode(Category.self, from: data)
                category.name = categoryName
                DispatchQueue.main.async { completion(category) }
            } catch {}
        }.resume()
    }
    
    
    func getImageForUrl(imageUrl: URL, completion:  @escaping (UIImage?)-> ()) {
        
        let downloadOp = NetworkImageOperation(url: imageUrl)
        downloadOp.completionBlock = {
            if let downloadedImage = downloadOp.image {
                DispatchQueue.main.async { completion(downloadedImage) }
            }
        }
        queue.addOperation(downloadOp)
        
        if let existingOperation = operations[imageUrl] {
            existingOperation.cancel()
            operations[imageUrl] = nil
        }
        operations[imageUrl] = downloadOp
        
    }
    
    
    func endDownload(url: URL) {
        if let operation = operations[url] {
            operation.cancel()
            operations[url] = nil
        }
    }
}
