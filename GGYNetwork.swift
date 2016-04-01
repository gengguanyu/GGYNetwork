//
//  GGYNetwork.swift
//  AlamofireDemo
//
//  Created by gengguanyu on 16/3/31.
//  Copyright © 2016年 gengguanyu. All rights reserved.
//

import Foundation
import Alamofire

class GGYNetwork: NSObject {
    typealias CallBack = (result: Result<String, NSError>) -> Void
    typealias Parameter = [String: AnyObject]?
    
    /*
    class func xxxx(xxx: CallBack) {
        GGYNetwork.GET(url: String, parameters: Parameter, jsonParameter: Parameter, callback: xxx)
    }
    */

    // MARK: ==========================
    // MARK: GET请求
    /** Get 请求 */
    private class func GET(url: String, parameters: Parameter, jsonParameter: Parameter, callback: CallBack) {
        Alamofire.request(.GET, url+GGYNetwork().query(parameters), parameters: jsonParameter, encoding: .JSON).responseString { (response) -> Void in
            callback(result: response.result)
        }
    }
    
    // MARK: POST请求
    /** POST 请求 */
    private class func POST(url: String, parameters: Parameter, jsonParameter: Parameter, callback: CallBack) {
        Alamofire.request(.POST, url+GGYNetwork().query(parameters), parameters: jsonParameter, encoding: .JSON).responseString { (response) -> Void in
            callback(result: response.result)
        }
    }
    
    // MARK: PUT请求
    /** PUT 请求 */
    private class func PUT(url: String, parameters: Parameter, jsonParameter: Parameter, callback: CallBack) {
        Alamofire.request(.PUT, url+GGYNetwork().query(parameters), parameters: jsonParameter, encoding: .JSON).responseString { (response) -> Void in
            callback(result: response.result)
        }
    }
    
    // MARK: DELETE请求
    /** DELETE 请求 */
    private class func DELETE(url: String, parameters: Parameter, jsonParameter: Parameter, callback: CallBack) {
        Alamofire.request(.DELETE, url+GGYNetwork().query(parameters), parameters: jsonParameter, encoding: .JSON).responseString { (response) -> Void in
            callback(result: response.result)
        }
    }
    
    
    
    // MARK: ==========================
    // MARK: 把参数拼接字符串
    /** 把参数拼接字符串 */
    private func query(parameters: [String: AnyObject]?) -> String {
        var components: [(String, String)] = []
        if parameters == nil {
            return ""
        }
        for key in parameters!.keys.sort(<) {
            let value = parameters![key]!
            components += queryComponents(key, value)
        }
        return "?" + (components.map { "\($0)=\($1)" } as [String]).joinWithSeparator("&")
    }
    private func queryComponents(key: String, _ value: AnyObject) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: AnyObject] {
            for (nestedKey, value) in dictionary {
                components += queryComponents("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [AnyObject] {
            for value in array {
                components += queryComponents("\(key)[]", value)
            }
        } else {
            components.append((escape(key), escape("\(value)")))
        }
        return components
    }
    private func escape(string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        let allowedCharacterSet = NSCharacterSet.URLQueryAllowedCharacterSet().mutableCopy() as! NSMutableCharacterSet
        allowedCharacterSet.removeCharactersInString(generalDelimitersToEncode + subDelimitersToEncode)

        let escaped = string.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet) ?? string
        return escaped
    }
    // MARK: -----------------------------------
}
