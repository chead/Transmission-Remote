//
//  File.swift
//  
//
//  Created by 👽 on 8/7/20.
//

import Foundation

public enum Sessions {
    public static func getSession() -> Request<None, Session> {
        let sessionGet = None()
        
        let request = Request<None, Session>(method: "session-get", arguments: sessionGet)

        return request
    }

    public struct SetAltSpeedDownRequest: Encodable {
        let altSpeedDown: Int

        enum CodingKeys: String, CodingKey {
            case altSpeedDown = "alt-speed-down"
        }
    }

    public static func setAltSpeedDown(_ speed: Int) -> Request<SetAltSpeedDownRequest, None> {
        let altSpeedDown = SetAltSpeedDownRequest(altSpeedDown: speed)

        let request = Request<SetAltSpeedDownRequest, None>(method: "session-set", arguments: altSpeedDown)

        return request
    }

//    public struct AltSpeedEnabled: Encodable {
//        let altSpeedEnabled: Bool
//
//        enum CodingKeys: String, CodingKey {
//            case altSpeedEnabled = "alt-speed-enabled"
//        }
//    }
//
//    public static func setAltSpeedEnabled(_ enabled: Bool) -> Request<AltSpeedEnabled, None> {
//        let altSpeedEnabled = AltSpeedEnabled(altSpeedEnabled: enabled)
//
//        let request = Request<AltSpeedEnabled, None>(method: "session-set", arguments: altSpeedEnabled)
//
//        return request
//    }
//
//    public struct AltSpeedTimeBegin: Encodable {
//        let altSpeedTimeBegin: Int
//
//        enum CodingKeys: String, CodingKey {
//            case altSpeedTimeBegin = "alt-speed-time-begin"
//        }
//    }
//
//    public static func setAltSpeedTimeBegin(_ time: Int) -> Request<AltSpeedTimeBegin, None> {
//        let altSpeedTimeBegin = AltSpeedTimeBegin(altSpeedTimeBegin: time)
//
//        let request = Request<AltSpeedTimeBegin, None>(method: "session-set", arguments: altSpeedTimeBegin)
//
//        return request
//    }
//
//    public struct AltSpeedTimeEnabled: Encodable {
//        let altSpeedTimeEnabled: Bool
//
//        enum CodingKeys: String, CodingKey {
//            case altSpeedTimeEnabled = "alt-speed-time-enabled"
//        }
//    }
//
//    public static func setAltSpeedTimeEnabled(_ enabled: Bool) -> Request<AltSpeedTimeEnabled, None> {
//        let altSpeedTimeEnabled = AltSpeedTimeEnabled(altSpeedTimeEnabled: enabled)
//
//        let request = Request<AltSpeedTimeEnabled, None>(method: "session-set", arguments: altSpeedTimeEnabled)
//
//        return request
//    }
//
//    public struct AltSpeedTimeEnd: Encodable {
//        let altSpeedTimeEnd: Int
//
//        enum CodingKeys: String, CodingKey {
//            case altSpeedTimeEnd = "alt-speed-time-end"
//        }
//    }
//
//    public static func setAltSpeedTimeEnd(_ time: Int) -> Request<AltSpeedTimeEnd, None> {
//        let altSpeedTimeEnd = AltSpeedTimeEnd(altSpeedTimeEnd: time)
//
//        let request = Request<AltSpeedTimeEnd, None>(method: "session-set", arguments: altSpeedTimeEnd)
//
//        return request
//    }
}
