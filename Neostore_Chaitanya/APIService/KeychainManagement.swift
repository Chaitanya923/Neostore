//
//  KeychainManagement.swift
//  Neostore_Chaitanya
//
//  Created by neosoft on 06/02/22.
//

import Foundation
import SwiftKeychainWrapper

class KeychainManagement {
    /*
    static let shared = KeychainManagement()
    private init (){
        
    }
    */
    lazy private var emailKey = "email"
    lazy private var passwordKey = "password"
    lazy private var tokenKey = "access_token"
    lazy private var fname = "fname"
    lazy private var lname = "lname"
    lazy private var phone = "phone"
    lazy private var dob = "dob"
    private let keychain = KeychainWrapper(serviceName: "Save")
    
    
    
    func addUserEmailAndPassword(userModel: UserModel)  {
        keychain.set(userModel.email, forKey: emailKey)
        keychain.set(userModel.password, forKey: passwordKey)
        keychain.set(userModel.firstName, forKey: fname)
        keychain.set(userModel.lastName, forKey: lname)
        keychain.set(userModel.phoneNo, forKey: phone)
    }
    
    
    func addAccessToken(accessToken: String?){
        keychain.set(accessToken ?? "", forKey: tokenKey)
    }
    
    func getAccessToken() -> String? {
        return keychain.string(forKey: tokenKey)
    }
    
    func getUserName() -> String? {
        let fullname = keychain.string(forKey: fname)! + keychain.string(forKey: lname)!
        return fullname
    }
    
    func getpass() -> String? {
        return keychain.string(forKey: passwordKey)
    }
    func getUserEmail() -> String? {
        return keychain.string(forKey: emailKey)!
    }
    
    func getUserPhone() -> String{
        return keychain.string(forKey: phone)!
    }
    
    func logout() {
        keychain.removeAllKeys()
    }
}
