//
//  Model.swift
//  CovidSafeScanner
//
//  Created by Paul Wilkinson on 28/4/20.
//  Copyright © 2020 Paul Wilkinson. All rights reserved.
//

import Foundation
import Combine

class Model: NSObject, ObservableObject {
    
    @Published var ids = [PeripheralData]()
    
    override init() {
        super.init()
        let _ = Timer.scheduledTimer(withTimeInterval: 40.0, repeats: true) { (timer) in
            self.agePeripherals()
            print("Age")
        }
    }
    
    func add(payload: Payload) {
        let peripheral = PeripheralData(payload: payload, age: 30, firstSeen: Date(), lastSeen: Date())
        if let currentPeripheralIndex = ids.firstIndex(where: {$0.id == payload.msg}) {
            ids[currentPeripheralIndex] = peripheral
        } else {
            ids.append(peripheral)
        }
    }
    
    private func agePeripherals() {
        var agedPeripherals = [PeripheralData]()
        for var peripheral in ids {
            peripheral.age -= 1
            if peripheral.age > 0 {
                peripheral.lastSeen = Date()
                agedPeripherals.append(peripheral)
            }
        }
        ids = agedPeripherals
    }
    
}

struct PeripheralData: Identifiable {
    
    static var dateFormatter: DateFormatter = {
        
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        
        return df
    }()
    
    var id: String {
        return self.payload.msg
    }
    var payload: Payload
    var age: Int
    var firstSeen: Date
    var lastSeen: Date
    
    var formattedFirstSeen: String {
        return PeripheralData.dateFormatter.string(from: self.firstSeen)
    }
    
    var formattedLastSeen: String {
        return PeripheralData.dateFormatter.string(from: self.lastSeen)
    }
}

struct Payload: Decodable {
    var modelP: String
    var org: String
    var msg: String
    var v: Int
}
