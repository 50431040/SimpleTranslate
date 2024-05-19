//
//  NetworkManager.swift
//  SimpleTranslate
//
//  Created by Stahsf on 2024/5/19.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager() // 单例模式，供全局访问
    
    private init() {} // 私有初始化方法，确保单例模式
    
    func fetchData(from urlString: String, body: [String: Any]?, headers: [String: String]?, completion: @escaping (Result<Any, Error>) -> Void) {
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            if let body = body {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
                    request.httpBody = jsonData
                } catch {
                    completion(.failure(error))
                    return
                }
            }
            
            // 设置额外的 HTTP 头部信息
            if let headers = headers {
                for (key, value) in headers {
                    request.setValue(value, forHTTPHeaderField: key)
                }
            }
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    let error = NSError(domain: "Server Error", code: 0, userInfo: nil)
                    completion(.failure(error))
                    return
                }
                
                if !(200...299).contains(httpResponse.statusCode) {
                    // 如果状态码不在 2xx 范围内，返回状态码错误
                    let error = NSError(domain: "Server Error", code: httpResponse.statusCode, userInfo: nil)
                    completion(.failure(error))
                    return
                }
                
                if let data = data {
                    do {
                        print("success")
                        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                        completion(.success(jsonObject))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
            
            task.resume()
        } else {
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            completion(.failure(error))
        }
    }
}
