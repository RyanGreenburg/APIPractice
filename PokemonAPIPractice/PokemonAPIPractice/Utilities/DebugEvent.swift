//
//  DebugEvent.swift
//  PokemonAPIPractice
//
//  Created by RYAN GREENBURG on 4/8/21.
//

import Foundation

struct DebugEvent {
    
    private struct Event {
        let type: String
        let message: String
        let file: String
        let function: String
        let additional: [String: Any]?
    }
    
    enum EventType {
        case error(Error)
        case httpResponse(HTTPURLResponse)
        case other(AnyObject)
        
        var description: String {
            switch self {
            case .error(let error):
                return error.localizedDescription
            case .httpResponse(let response):
                return "Code : \(response.statusCode) : \(response.url?.absoluteString ?? "none")"
            case .other(let obj):
                return obj.description
            }
        }
        
        var title: String {
            switch self {
            case .error:
                return "ERROR"
            case .httpResponse:
                return "NETWORK RESPONSE"
            default:
                return "DEBUG EVENT"
            }
        }
    }
    
    static func log(_ event: @autoclosure () -> EventType,
                            file: @autoclosure () -> String = #file,
                            function: @autoclosure () -> String = #function,
                            additional: @autoclosure () -> [String: Any]? = nil) {
        #if DEBUG
        let event = event()
        let file = file().components(separatedBy: "/").last!
        
        dump(Event(type: event.title,
                   message: event.description,
                   file: file,
                   function: function(),
                   additional: additional()))
        #endif
    }
}
