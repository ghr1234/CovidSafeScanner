//
//  ListRow.swift
//  CovidSafeScanner
//
//  Created by Paul Wilkinson on 28/4/20.
//  Copyright © 2020 Paul Wilkinson. All rights reserved.
//

import SwiftUI

struct ListRow: View {
    
    var peripheral: PeripheralData
    
    var body: some View {
        VStack {
            HStack {
                Text(peripheral.payload.modelP)
                Spacer()
            }
            HStack {
                Text("First seen \(peripheral.formattedFirstSeen)")
                Text("Last seen \(peripheral.formattedLastSeen)")
            }.font(.caption)
        }
    }
}

struct ListRow_Previews: PreviewProvider {
    static var previews: some View {
        ListRow(peripheral: PeripheralData(payload: Payload(modelP: "Test", org: "Test", msg: "Test", v: 1), age: 30, firstSeen: Date(), lastSeen: Date()))
    }
}
