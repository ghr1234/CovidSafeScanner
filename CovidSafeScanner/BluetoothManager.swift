//
//  BluetoothManager.swift
//  CovidSafeScanner
//
//  Created by Paul Wilkinson on 28/4/20.
//  Copyright © 2020 Paul Wilkinson. All rights reserved.
//

import Foundation
import CoreBluetooth

class BluetoothManager:NSObject {
    
    private var knownPeripherals = Set<CBPeripheral>()
    private var connectedPeripherals = Set<CBPeripheral>()
    
    private var characteristics = [CBPeripheral:CBCharacteristic]()
    
    private var central: CBCentralManager!
    
    private var peripheralScannerTimer: Timer?
    
    private var model: Model
    
    init(model: Model) {
        self.central = CBCentralManager()
        self.model = model
        super.init()
        self.central.delegate = self
    }
    
    func startScan() {
        print("Starting scan")
        central.scanForPeripherals(withServices: [Constants.COVIDSAFESERVICE], options: nil)
        self.peripheralScannerTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true, block: { (timer) in
            self.scanPeripherals()
        })
    }
    
    func scanPeripherals() {
        for (peripheral,characteristic) in self.characteristics {
            peripheral.readValue(for: characteristic)
        }
    }
    
}

extension BluetoothManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            self.startScan()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Found \(peripheral)")
        self.knownPeripherals.insert(peripheral)
        if !self.connectedPeripherals.contains(peripheral) {
            central.connect(peripheral, options: nil)
        }
       
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        self.connectedPeripherals.insert(peripheral)
        print("Connected \(peripheral)")
        peripheral.delegate = self
        peripheral.discoverServices([Constants.COVIDSAFESERVICE])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
          print("Disconnected \(peripheral)")
        self.connectedPeripherals.remove(peripheral)
        self.characteristics[peripheral] = nil
    }
}

extension BluetoothManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error == nil else {
            print(error!)
            return
        }
        print("Found service")
        for service in peripheral.services ?? [] {
            if service.uuid == Constants.COVIDSAFESERVICE {
                peripheral.discoverCharacteristics([Constants.COVIDSAFEID], for: service)
            }
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
         guard error == nil else {
                   print(error!)
                   return
               }
        for characteristic in service.characteristics ?? [] {
            if characteristic.uuid == Constants.COVIDSAFEID {
                self.characteristics[peripheral] = characteristic
                print("Found characteristic")
                peripheral.readValue(for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let data = characteristic.value {
            do {
                let payload = try JSONDecoder().decode(Payload.self, from: data)
                self.model.add(payload: payload)
                print(payload)
            }
            catch {
                print("Decode error: \(error)")
            }
        }
    }
}
