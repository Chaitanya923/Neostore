//
//  SliderTableViewCell.swift
//  Neostore_Chaitanya
//
//  Created by Neosoft on 19/01/22.
//

import UIKit

let imagename = ["slider_img1","slider_img2","slider_img3","slider_img4"]

class SliderTableViewCell: UITableViewCell , UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return imagename.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlideimgCell", for: indexPath) as! SlideimgCollectionViewCell
        cell.img.image = #imageLiteral(resourceName: imagename[indexPath.row] )
        return cell
    }
    

    @IBOutlet weak var Slideimagecollectionview: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Slideimagecollectionview.delegate = self
        Slideimagecollectionview.dataSource = self
        Slideimagecollectionview.isPagingEnabled = true
        Slideimagecollectionview.register(UINib(nibName:"SlideimgCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SlideimgCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            let cellWidth = UIScreen.main.bounds.size.width
        return CGSize(width: cellWidth, height: UIScreen.main.bounds.height * 0.3)
        }
    /*
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
    */
    
}
