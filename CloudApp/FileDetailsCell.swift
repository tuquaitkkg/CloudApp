//
//  FileDetailsCell.swift
//  CloudApp
//
//  Created by DAO VAN UOC on 6/18/18.
//  Copyright © 2018 Vinh The. All rights reserved.
//

import UIKit
import Alamofire
class FileDetailsCell: UICollectionViewCell {

    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var imgContent: UIImageView!
    var btnDeleteClickClosesure:((Any)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 5
    }

    @IBAction func btnDeleteClick(_ sender: Any) {
        if self.btnDeleteClickClosesure != nil {
            self.btnDeleteClickClosesure!(sender)
        }
    }
    
    func configureCell(file : CloudFile) {
    
        lbName.text = file.name
        
        
        configureImageType(file: file)
        
    }
    
    func configureImageType(file : CloudFile) {
        
        switch file.item_type {
        case ImageType.image.rawValue:
            getDataFromUrl(url: URL(string: file.thumbnailImage!)!) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() {
                    self.imgContent.image = UIImage(data: data)
                }
            }
            break
        case ImageType.text.rawValue:
            getDataFromUrl(url: URL(string: file.thumbnailImage!)!) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() {
                    self.imgContent.image = UIImage(data: data)
                }
            }
        case ImageType.zip.rawValue:
            getDataFromUrl(url: URL(string: file.thumbnailImage!)!) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() {
                    self.imgContent.image = UIImage(data: data)
                }
            }
        case ImageType.audio.rawValue:
            getDataFromUrl(url: URL(string: file.thumbnailImage!)!) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() {
                    self.imgContent.image = UIImage(data: data)
                }
            }
        case ImageType.video.rawValue:
            getDataFromUrl(url: URL(string: file.thumbnailImage!)!) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() {
                    self.imgContent.image = UIImage(data: data)
                }
            }
        default:
            getDataFromUrl(url: URL(string: file.thumbnailImage!)!) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() {
                    self.imgContent.image = UIImage(data: data)
                }
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        print("Download Started")
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
        
    }
}
