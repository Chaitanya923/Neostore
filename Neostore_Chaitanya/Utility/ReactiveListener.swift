//
//  ReactiveListener.swift
//  Neostore_Chaitanya
//
//  Created by neosoft on 15/03/22.
//


import Foundation

class ReactiveListener<T>{
    typealias Listener = (T) -> ()
    var listener: Listener?
    
    func bind(_ listener: Listener?){
        self.listener = listener
    }
    
    func bindAndFire(_ listener: Listener?){
        self.listener = listener
        listener?(value)
    }
    
    var value: T{
        didSet{
            listener?(value)
        }
    }
    
    init(_ v: T){
        value = v
    }
}
