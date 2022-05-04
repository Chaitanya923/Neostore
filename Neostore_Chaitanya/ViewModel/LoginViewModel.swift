//
//  LoginViewModel.swift
//  Neostore_Chaitanya
//
//  Created by neosoft on 22/03/22.
//

import Foundation

class LoginViewModel {
    func login(_ email : String,_ password : String,onhandleresponse:@escaping((Int)->Void))  {
        
        APIServiceDude.shared.login(email: email, password: password){
            result in
            switch result{
            case .success(let resps) :
                let dataofuser = UserModel(firstName: resps.data?.firstName ?? "", lastName: resps.data?.lastName ?? "", email: resps.data?.email ?? "", password: password, confirmPassword: password, isMale: resps.data?.gender=="M" ? true : false , phoneNo: resps.data?.phoneNo ?? "")
                KeychainManagement().addUserEmailAndPassword(userModel: dataofuser)
                KeychainManagement().addAccessToken(accessToken: resps.data?.accessToken)
                onhandleresponse(1)
                
            case .failure(let repf) :
                onhandleresponse(0)
                
            }
        }
}
}
