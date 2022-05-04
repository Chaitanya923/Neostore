//
//  ProductViewModel.swift
//  Neostore_Chaitanya
//
//  Created by neosoft on 15/03/22.
//

import Foundation

class ProductListViewModel {
    let productlist : ReactiveListener<[ProductModel]> = ReactiveListener(Array<ProductModel>())
    
    func CallService(_ catid : Int) {
        APIServiceDude.shared.getProductList(of: catid) { Response in
            switch Response{
            
            case .success(let resps):
                self.productlist.value = resps.data
            case .failure(let respf):
                print(respf)
            }
        }
    }
}
