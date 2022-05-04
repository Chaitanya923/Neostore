//
//  ProductDetailViewModel.swift
//  Neostore_Chaitanya
//
//  Created by neosoft on 16/03/22.
//

import Foundation

class ProductDetailViewModel {
    let productdetails : ReactiveListener<Demo> = ReactiveListener(Demo.none)
    
    func CallService()
    {
        APIServiceDude.shared.getProductDetails (of: pro_id) {
            result in
            switch result {
            case .success(let fetchedProducts):
                
                p_det = fetchedProducts.data
                
                DispatchQueue.main.async {
                    //self.ProductDetailTableView.reloadData()
                    //self.title = p_det.name
                }
                
            case .failure(let error):
                print("Error in getting Products: \(error)")
            }
        }
    }
}

enum Demo {
    case none
    case start
}
