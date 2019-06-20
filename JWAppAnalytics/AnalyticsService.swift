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
    
    private var userJourneyEnabled = false
    
    private var apiUrl: String?
    
    private var userJourney: UserJourney?
    
    private var sessionProperties = [String: Any]()
    
    public func setup(withUrl url: String, userJourneyEnabled: Bool = false) {
        apiUrl = "\(url)/app-analytics-api"
        if UserDefaults.standard.string(forKey: "uuid") == nil {
            UserDefaults.standard.set(UIDevice.current.identifierForVendor!.uuidString, forKey: "uuid")
        }
        self.userJourneyEnabled = userJourneyEnabled
        if userJourneyEnabled {
            if let uuid = UserDefaults.standard.string(forKey: "uuid") {
                userJourney = UserJourney(uuid: uuid, events: [[String: Any]]())
            }
        }
    }
    
    /// Triggers an event for the metric of the given String.
    public func trigger(event: String) {
        guard let apiUrl = apiUrl, let url = URL(string: "\(apiUrl)/events") else { return }
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
        
        addToUserJourney(event: event)
    }
    
    public func willEnterForeground() {
        userJourney?.events = [[String: Any]]()
        sessionProperties = [String: Any]()
        trigger(event: "open_app")
    }
    
    public func didEnterBackground() {
        guard let userJourney = userJourney else { return }
        addToUserJourney(event: "close_app")
        send(userJourney: userJourney)
    }
    
    /// Adds the given properties to the session.
    public func addSessionProperties(properties: [String: Any]) {
        sessionProperties = sessionProperties.merging(properties) { (i1, i2) -> Any in
            return i2
        }
    }
    
    /// Clears the session properties.
    public func clearSessionProperties() {
        sessionProperties = [String: Any]()
    }
    
    private func addToUserJourney(event: String) {
        guard userJourneyEnabled, let userJourney = userJourney else { return }
        let formatter = DateFormatter()
        formatter.dateFormat = "Y-MM-dd HH:mm:ss"
        let now = formatter.string(from: Date())
        userJourney.events.append([
            "event": event,
            "date": now
        ])
    }
    
    private func send(userJourney: UserJourney) {
        guard let apiUrl = apiUrl, let url = URL(string: "\(apiUrl)/app-session") else { return }
        var request = URLRequest(url: url)

        let json: [String: Any] = [
            "device_id": userJourney.uuid,
            "events": userJourney.events,
            "properties": sessionProperties
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
            if let _ = response as? HTTPURLResponse {
                // Handle either deleting the json or saving it to disk based on statuscode.
            }
        }.resume()
    }
    
}
