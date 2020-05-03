//
//  PeripheralDetail.swift
//  CovidSafeScanner
//
//  Created by Paul Wilkinson on 28/4/20.
//  Copyright © 2020 Paul Wilkinson. All rights reserved.
//

import SwiftUI

struct PeripheralDetail: View {
    
    var peripheral: PeripheralData
    var body: some View {
        VStack {
            Text("Model: \(peripheral.payload.modelP)")
            Text("Org: \(peripheral.payload.org)")
            Text("Msg: \(peripheral.payload.msg)").multilineTextAlignment(.leading)
            Text("Version: \(peripheral.payload.v)")
            HStack {
                Text("First seen \(peripheral.formattedFirstSeen)")
                Text("Last seen \(peripheral.formattedLastSeen)")
            }.font(.caption)
        }
    }
}

struct PeripheralDetail_Previews: PreviewProvider {
    static var previews: some View {
        PeripheralDetail(peripheral: PeripheralData(payload: Payload(modelP: "Test", org: "Test", msg: "Test", v: 1), age: 30, firstSeen: Date(), lastSeen: Date()))
    }
}
