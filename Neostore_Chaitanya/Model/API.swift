//
//  Service.swift
//  NeoSTORE
//
//  Created by Neosoft on 21/12/21.
//

import Foundation

protocol APIServiceProvider{
    func orderNow(accessToken : String?, address: String, completionHandler: @escaping(Result<String, APIError>) -> Void)

    func getOrderList(accessToken: String?, completionHandler: @escaping((Result<Response<OrderModel>, APIError>) -> Void))
    
    func setRating(for productId: Int, rating: Int, completionHandler: @escaping(Result<String, APIError>) -> Void )
    
    func updateProductFromCart(of productId: Int, qty: Int, accessToken: String?, completionHandler: @escaping(Result<String, APIError>) -> Void )
    
    func deleteProductFromCart(of productId: Int, accessToken: String?, completionHandler: @escaping(Result<String, APIError>) -> Void )
    
    func getMyCartDetails(accessToken: String?, completionHandler: @escaping(Result<CartResponse, APIError>) -> Void )
    
    func addToCart(accessToken: String?, productId: Int, qty: Int, completionHandler: @escaping(Result<String, APIError>) -> Void )
    
    func updatePassword(accessToken: String?, oldPassword: String, newPassword: String, confirmPassword: String, completionHandler: @escaping(Result<String, APIError>) -> Void )
    
    func getUserDetails(accessToken: String?, completionHandler: @escaping(Result<UserResponse, APIError>) -> Void )
    
    func forgetPassword(email: String, completionHandler: @escaping(Result<String, APIError>) -> Void )
    
    func login(email: String, password: String, completionHandler: @escaping(Result<RegisterResponse, APIError>) -> Void )
    
    func register(userModel: UserModel, completionHandler: @escaping(Result<RegisterResponse, APIError>) -> Void )
    
    func updateUserDetails(accessToken: String?, firstName: String, lastName: String, dob: String, phoneNo: String, email: String, profilePhoto: String, completionHandler: @escaping(Result<String, APIError>) -> Void )
    
    func orderDetails(accessToken : String?, orderID: Int, completionHandler: @escaping(Result<ResponseSingleData<OrderMainModel>, APIError>) -> Void)
    
    func getProductDetails(of productID: Int , completionHandler : @escaping (Result<ResponseSingleData<ProductDetails>, APIError>) -> ())
    
    func getProductList(of productCategoryID: Int , completionHandler : @escaping (Result<Response<ProductModel>, APIError>) -> ())
}

class APIServiceDude: APIServiceProvider{
    
    
    private let baseUrl = "http://staging.php-dev.in:8844/trainingapp/api"
    
    private enum Endpoints: String{
        case order = "/order"
        case orderList = "/orderList"
        case setRatings = "/products/setRating"
        case editCart = "/editCart"
        case deleteCart = "/deleteCart"
        case cart = "/cart"
        case addToCart = "/addToCart"
        case changePassword = "/users/change"
        case getUserDetails = "/users/getUserData"
        case forgetPassword = "/users/forgot"
        case login = "/users/login"
        case register = "/users/register"
        case updateUser = "/users/update"
        case orderDetails = "/orderDetail"
        case productDetails = "/products/getDetail"
        case productList = "/products/getList"
    }
    
    private enum Methods: String{
        case GET
        case POST
    }
    
    static let shared: APIServiceDude = {
        return APIServiceDude()
    }()
    
    func getProductList(of productCategoryID: Int , completionHandler : @escaping (Result<Response<ProductModel>, APIError>) -> ()){
        let queryItems = [
            URLQueryItem(name: "product_category_id", value: "\(productCategoryID)")
        ]
        queryRequest(accessToken: nil, queryItems: queryItems, endpoint: .productList, method: .GET, completionHandler: completionHandler)
    }
    
    func getProductDetails(of productID: Int , completionHandler : @escaping (Result<ResponseSingleData<ProductDetails>, APIError>) -> ()){
        let queryItems = [
            URLQueryItem(name: "product_id", value: "\(productID)")
        ]
        queryRequest(accessToken: nil, queryItems: queryItems, endpoint: .productDetails, method: .GET, completionHandler: completionHandler)
    }
    
    func orderDetails(accessToken : String?, orderID: Int, completionHandler: @escaping(Result<ResponseSingleData<OrderMainModel>, APIError>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "order_id", value: "\(orderID)")
        ]
        queryRequest(accessToken: accessToken, queryItems: queryItems, endpoint: .orderDetails, method: .GET, completionHandler: completionHandler)
    }
    
    func updateUserDetails(accessToken: String?, firstName: String, lastName: String, dob: String, phoneNo: String, email: String, profilePhoto: String, completionHandler: @escaping(Result<String, APIError>) -> Void ){
        let jSonString = "first_name=\(firstName)&last_name=\(lastName)&email=\(email)&phone_no=\(phoneNo)&profile_pic=\(profilePhoto)&dob=\(dob)"
                let httpBody = jSonString.data(using: .utf8)
        request(accessToken: accessToken, httpBody: httpBody, endpoint: .updateUser, method: .POST, completionHandler: completionHandler)
    }
    
    func register(userModel: UserModel, completionHandler: @escaping(Result<RegisterResponse, APIError>) -> Void ) {
        
        let jSonString = "first_name=\(userModel.firstName)&last_name=\(userModel.lastName)&email=\(userModel.email)&password=\(userModel.password)&confirm_password=\(userModel.confirmPassword)&gender=\(userModel.gender)&phone_no=\(userModel.phoneNo)"
        let httpBody = jSonString.data(using: .utf8)
        request(accessToken: nil, httpBody: httpBody, endpoint: .register, method: .POST, completionHandler: completionHandler)
    }
    
    func login(email: String, password: String, completionHandler: @escaping(Result<RegisterResponse, APIError>) -> Void ){
        let jSonString = "email=\(email)&password=\(password)"
        let httpBody = jSonString.data(using: .utf8)
        request(accessToken: nil, httpBody: httpBody, endpoint: .login, method: .POST, completionHandler: completionHandler)
    }
    
    func forgetPassword(email: String, completionHandler: @escaping(Result<String, APIError>) -> Void ){
        let jSonString = "email=\(email)"
        let httpBody = jSonString.data(using: .utf8)
        request(accessToken: nil, httpBody: httpBody, endpoint: .forgetPassword, method: .POST, completionHandler: completionHandler)
    }
    
    
    func getUserDetails(accessToken: String?, completionHandler: @escaping(Result<UserResponse, APIError>) -> Void ){
        request(accessToken: accessToken, httpBody: nil, endpoint: .getUserDetails, method: .GET, completionHandler: completionHandler)
    }
    
    func updatePassword(accessToken: String?, oldPassword: String, newPassword: String, confirmPassword: String, completionHandler: @escaping (Result<String, APIError>) -> Void) {
        
        let jSonString = "old_password=\(oldPassword)&password=\(newPassword)&confirm_password=\(confirmPassword)"
        let httpBody = jSonString.data(using: .utf8)
        request(accessToken: accessToken, httpBody: httpBody, endpoint: .changePassword, method: .POST, completionHandler: completionHandler)
    }
    
    func addToCart(accessToken: String?, productId: Int, qty: Int, completionHandler: @escaping (Result<String, APIError>) -> Void) {
        let jSonString = "product_id=\(productId)&quantity=\(qty)"
        let httpBody = jSonString.data(using: .utf8)
        request(accessToken: accessToken, httpBody: httpBody, endpoint: .addToCart, method: .POST, completionHandler: completionHandler)
    }
    
    func getMyCartDetails(accessToken: String?, completionHandler: @escaping(Result<CartResponse, APIError>) -> Void ){
        request(accessToken: accessToken, httpBody: nil, endpoint: .cart, method: .GET, completionHandler: completionHandler)
    }
    
    func deleteProductFromCart(of productId: Int, accessToken: String?, completionHandler: @escaping (Result<String, APIError>) -> Void) {
        
        let jSonString = "product_id=\(productId)"
        let httpBody = jSonString.data(using: .utf8)
        
        request(accessToken: accessToken, httpBody: httpBody, endpoint: .deleteCart, method: .POST, completionHandler: completionHandler)
    }
    
    func updateProductFromCart(of productId: Int, qty: Int, accessToken: String?, completionHandler: @escaping (Result<String, APIError>) -> Void) {
        let jSonString = "product_id=\(productId)&quantity=\(qty)"
        let httpBody = jSonString.data(using: .utf8)
        
        request(accessToken: accessToken, httpBody: httpBody, endpoint: .editCart, method: .POST, completionHandler: completionHandler)
    }
    
    func setRating(for productId: Int, rating: Int, completionHandler: @escaping(Result<String, APIError>) -> Void ){
        let jSonString = "product_id=\(productId)&rating=\(rating)"
        let httpBody = jSonString.data(using: .utf8)
        
        request(accessToken: nil, httpBody: httpBody, endpoint: .setRatings, method: .POST, completionHandler: completionHandler)
    }
    
    func getOrderList(accessToken: String?, completionHandler: @escaping((Result<Response<OrderModel>, APIError>) -> Void)) {
        request(accessToken: accessToken, httpBody: nil, endpoint: .orderList, method: .GET, completionHandler: completionHandler)
    }
    
    func orderNow(accessToken : String?, address: String, completionHandler: @escaping(Result<String, APIError>) -> Void){
        let jSonString = "address=\(address)"
        let httpBody = jSonString.data(using: .utf8)
        
        request(accessToken: accessToken, httpBody: httpBody, endpoint: .order, method: .POST, completionHandler: completionHandler)
    }
    
    private func queryRequest<T: Codable>(accessToken: String?, queryItems: [URLQueryItem]?, endpoint: Endpoints, method: Methods, completionHandler: @escaping((Result<T, APIError>) -> Void)){
        let path = "\(baseUrl)\(endpoint.rawValue)"
        
        guard var components = URLComponents(string: path) else{
            completionHandler(.failure(.badURL(message: "Internal Error Occurred")))
            return
        }
        
        components.queryItems = queryItems
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        guard let url = components.url else{
            completionHandler(.failure(.badURL(message: "Internal Error Occurred")))
            return
        }
        var request = URLRequest(url: url)
        request.setValue(accessToken, forHTTPHeaderField: "access_token")
        
        call(with: request, completionHandler: completionHandler)
    }
    
    private func request<T: Codable>(accessToken: String?, httpBody: Data?, endpoint: Endpoints, method: Methods, completionHandler: @escaping((Result<T, APIError>) -> Void)) {
        let path = "\(baseUrl)\(endpoint.rawValue)"
        
        guard let url = URL(string: path) else{
            completionHandler(.failure(.badURL(message: "Internal Error Occurred")))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "\(method)"
        request.httpBody = httpBody
        request.setValue(accessToken, forHTTPHeaderField: "access_token")
        
        call(with: request, completionHandler: completionHandler)
    }
    
    private func call<T: Codable>(with request: URLRequest, completionHandler: @escaping((Result<T, APIError>) -> Void) ){
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completionHandler(.failure(.unsuccess(message: "\(error!.localizedDescription)")))
                return
            }
            guard let data = data else{
                completionHandler(.failure(.unsuccess(message: "Error in getting data")))
                return
            }
            
            print("Response Data: \(String(data: data, encoding: .utf8))")
            print("T : ",T.self)
            do {
                let object = try JSONDecoder().decode(T.self, from: data)
                print(object)
                completionHandler(.success(object))
            } catch {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    //if json!["status"]! as! Int == 200 {
                    //    completionHandler(.success("" as! T))
                    //    return
                    //}
                    //else
                    if json!["user_msg"] != nil{
                        completionHandler(.failure(.unsuccess(message: "\(json!["user_msg"]!)")))
                        return
                    }
                    completionHandler(.failure(.unsuccess(message: "Something went wrong please login again")))
                    
                } catch  let err {
                    completionHandler(.failure(.unsuccess(message: "Error: \(err.localizedDescription)")))
                }
            }
            
        }
        dataTask.resume()
        
    }
    
}
