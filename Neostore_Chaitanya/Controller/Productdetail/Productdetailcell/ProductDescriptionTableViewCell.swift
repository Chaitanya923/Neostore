//
//  ProductDescriptionTableViewCell.swift
//  Neostore_Chaitanya
//
//  Created by neosoft on 31/01/22.
//

import UIKit
var img_array : [ProductImage] = []

class ProductDescriptionTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  img_array.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlideimgCell", for: indexPath) as! SlideimgCollectionViewCell
        DispatchQueue.global().async {
            // Fetch Image Data
            if let data = try? Data(contentsOf: URL(string: img_array[indexPath.row].image)!) {
                DispatchQueue.main.async {
                    // Create Image and Update Image View
                    cell.img.image = UIImage(data: data)
                    //self.imageView.image = UIImage(data: data)
                }
            }
        }
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.global().async {
            // Fetch Image Data
            if let data = try? Data(contentsOf: URL(string: img_array[indexPath.row].image)!) {
                DispatchQueue.main.async { [self] in
                    // Create Image and Update Image View
                    mainimage.image = UIImage(data: data)
                    //self.imageView.image = UIImage(data: data)
                }
            }
        }
    }
    
    @IBOutlet weak var Cost: UILabel!
    @IBOutlet weak var descriptrion: UILabel!
    @IBOutlet weak var mainimage: UIImageView!
    @IBOutlet weak var imgcollectionview: UICollectionView!
    
    static func loadfromnib(_ img : [ProductImage]) {
        img_array = img
        print("Images Data",img.count)
        print("img array",img_array)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imgcollectionview.delegate = self
        imgcollectionview.dataSource = self
        imgcollectionview.register(UINib(nibName:"SlideimgCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SlideimgCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


