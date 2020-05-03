//
//  ContentView.swift
//  CovidSafeScanner
//
//  Created by Paul Wilkinson on 28/4/20.
//  Copyright © 2020 Paul Wilkinson. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var model: Model
    
    var body: some View {
        NavigationView {
            List { ForEach(model.ids) { item in
                NavigationLink(destination: PeripheralDetail(peripheral: item)) {
                    ListRow(peripheral:item)
                }
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Model())
    }
}
