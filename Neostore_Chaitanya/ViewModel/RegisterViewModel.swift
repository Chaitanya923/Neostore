//
//  RegisterViewModel.swift
//  Neostore_Chaitanya
//
//  Created by neosoft on 15/03/22.
//

import Foundation

class RegisterViewModel {
    
    
    func Register(_ usermodel: UserModel,onhandleresponse:@escaping((Int)->Void)) {
        APIServiceDude.shared.register(userModel: usermodel) {  result in
            switch result {
            case .success(let resps):
                print("temp")
                KeychainManagement().addUserEmailAndPassword(userModel: usermodel)
                KeychainManagement().addAccessToken(accessToken: resps.data?.accessToken)
                onhandleresponse(1)
            case .failure(_):
                onhandleresponse(0)
            }
        }
    }
}



