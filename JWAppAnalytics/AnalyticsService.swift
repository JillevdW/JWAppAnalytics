//
//  AnalyticsService.swift
//  JWAppAnalytics
//
//  Created by Jille van der Weerd on 08/05/2019.
//  Copyright © 2019 Jille van der Weerd. All rights reserved.
//

import Foundation

public class AnalyticsService {
    
    public static let shared = AnalyticsService()
    
    private var apiUrl: String?
    
    public func setup(withUrl url: String) {
        apiUrl = url
        if UserDefaults.standard.string(forKey: "uuid") == nil {
            UserDefaults.standard.set(UIDevice.current.identifierForVendor!.uuidString, forKey: "uuid")
        }
    }
    
    public func trigger(event: String) {
        guard let apiUrl = apiUrl, let url = URL(string: "\(apiUrl)/app-analytics-api/events") else { return }
        var request = URLRequest(url: url)
        let uuid = UserDefaults.standard.string(forKey: "uuid")!
        let json = [
            "device_id": uuid,
            "metric_name": event
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            guard error == nil else {
                print("Error sending analytics.")
                return
            }
        }.resume()
    }
    
}
