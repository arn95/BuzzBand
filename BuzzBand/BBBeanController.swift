//
//  BBBeanController.swift
//  BuzzBand
//
//  Created by Arnold Balliu on 4/29/17.
//  Copyright © 2017 Arnold Balliu. All rights reserved.
//

import Bean_iOS_OSX_SDK
import Material
import SwiftyTimer

class BBBeanController: UIViewController,PTDBeanManagerDelegate, PTDBeanDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let ACTION_SLEEP: PTD_UINT8 = 0
    let ACTION_RING: PTD_UINT8 =  1
    let ACTION_STOP_RING: PTD_UINT8 = 2
    
    var bean: PTDBean?
    var beanManager: PTDBeanManager?
    var shouldRing: Bool = false
    var pickerLabels = ["Now","5 Seconds", "10 Seconds", "15 Seconds", "30 Seconds"]
    var pickerValues : [Double] = [0,5,10,15,30]
    var alarmSet = false
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var setAlarmBtn: UIButton!
    @IBOutlet weak var stopAlarmBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if bean != nil {
            
            print("BEAN NOT NULL")
            self.beanManager!.delegate = self
            picker.dataSource = self
            picker.delegate = self
            stopAlarmBtn.isHidden = true
            
        } else {
            print("BEAN NULL")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerLabels.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerLabels[row]
    }
    
    func beanManager(_ beanManager: PTDBeanManager!, didDisconnectBean bean: PTDBean!, error: Error!) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    //Button functions
    
    @IBAction func onDisconnect(_ sender: UIBarButtonItem) {
        self.bean_sleep()
        beanManager?.disconnectBean(bean, error: nil)
        //_ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onAlarmSet(_ sender: UIButton) {
        
        let selected_thing_index = picker.selectedRow(inComponent: 0)
        let value : Double = pickerValues[selected_thing_index]
        
        if value == 0  {
            self.bean_ring()
            self.setAlarmBtn.isHidden = false
        }
        
        Timer.after(value.seconds){
            self.bean_ring()
            self.setAlarmBtn.isHidden = false
        }
        
        self.stopAlarmBtn.isHidden = false
        self.setAlarmBtn.isHidden = true
    }
    
    
    @IBAction func onAlarmStop(_ sender: UIButton) {
        self.setAlarmBtn.isHidden = false
        self.stopAlarmBtn.isHidden = true
        bean_stop_ring()
    }
    
    //Bean Functions
    
    func bean_sleep(){
        let transmission = BBTransmission.init(action: ACTION_SLEEP, params: nil)
        print(transmission.payload_size)
        print(transmission.payload)
        bean_send_data(transmission: transmission)
    }
    
    func bean_ring(){
        let transmission = BBTransmission.init(action: ACTION_RING, params: nil)
        print(transmission.payload_size)
        print(transmission.payload)
        bean_send_data(transmission: transmission)
    }
    
    func bean_stop_ring(){
        let transmission = BBTransmission.init(action: ACTION_STOP_RING, params: nil)
        print(transmission.payload_size)
        print(transmission.payload)
        bean_send_data(transmission: transmission)
    }
    
    func bean_send_data(transmission: BBTransmission) {
        print("Sending Payload: \(transmission.payload)")
        print("ASCII Payload: \(transmission.asciiPayload)")
        self.bean?.sendSerialString(transmission.payload)
    }
    
    
}
