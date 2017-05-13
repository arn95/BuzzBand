//
//  BBTransmission.swift
//  BuzzBand
//
//  Created by Arnold Balliu on 5/2/17.
//  Copyright © 2017 Arnold Balliu. All rights reserved.
//

import Foundation
import Bean_iOS_OSX_SDK

class BBTransmission {
    
    var action: PTD_UINT8
    var params: [String]?
    var payload_size: Int
    var asciiPayload: String
    var payload: String
    
    init(action: PTD_UINT8, params: [String]?) {
        self.action = action
        self.params = params
        self.payload = ""
        self.asciiPayload = ""
        self.payload_size = 0
        
        prepare_payload()
    }
    
    func prepare_payload(){
        var payload: String = "\(action)"
        
        if (self.params != nil){
            var x = 0
            for param in params! {
                
                if (x != 0) {
                    payload.append(",\(param)")
                } else {
                    payload.append(":\(param)")
                }
                
                x += 1
            }
        }
        
        self.payload_size = MemoryLayout.size(ofValue: payload)
        self.payload = payload
        
        for item in payload.asciiArray {
            self.asciiPayload.append("\(item)")
        }
    }
    
    static func toByteArray<T>(_ value: T) -> [UInt8] {
        var value = value
        return withUnsafeBytes(of: &value) { Array($0) }
    }
    
    func fromByteArray<T>(_ value: [UInt8], _: T.Type) -> T {
        return value.withUnsafeBytes {
            $0.baseAddress!.load(as: T.self)
        }
    }
    
    
    
}
