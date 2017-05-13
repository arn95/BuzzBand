//
//  ViewController.swift
//  BuzzBand
//
//  Created by Arnold Balliu on 4/10/17.
//  Copyright © 2017 Arnold Balliu. All rights reserved.
//

import UIKit
import RPCircularProgress
import Bean_iOS_OSX_SDK
import SwiftyTimer

class BBPairController: UIViewController, PTDBeanManagerDelegate, PTDBeanDelegate , UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var nearbyDevicesTable: UITableView!
    @IBOutlet weak var circularProgress: RPCircularProgress!
    
    var beanManager: PTDBeanManager?
    var devicesArray = [PTDBean]()
    var connectedBean: PTDBean?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.nearbyDevicesTable.delegate = self
        self.nearbyDevicesTable.dataSource = self
        
        self.beanManager = PTDBeanManager()
        self.beanManager!.delegate = self
        
        circularProgress.enableIndeterminate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // BEAN STUFF
    
    func beanManagerDidUpdateState(_ beanManager: PTDBeanManager!) {
    
        if beanManager!.state == BeanManagerState.poweredOn {
            startScanning()
        }
    }
    
    func startScanning(){
        var error: NSError?
        self.beanManager!.startScanning(forBeans_error: &error)
        if let e = error {
            print(e)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "pairControllerToBeanController"){
            let beanController = segue.destination as! BBBeanController
            beanController.bean = self.connectedBean
            beanController.beanManager = self.beanManager
        }
        
    }
    
    func beanManager(_ beanManager: PTDBeanManager!, didDiscover bean: PTDBean!, error: Error!) {
        
        if let e = error {
            print(e)
        }
        self.devicesArray.append(bean)
        self.nearbyDevicesTable.reloadData()
        circularProgress.isHidden = true;
    }
    
    func beanManager(_ beanManager: PTDBeanManager!, didDisconnectBean bean: PTDBean!, error: Error!) {
        let index = self.devicesArray.index(where: { (item) -> Bool in
            item.name == "BuzzBand" // test if this is the item you're looking for
        })
        if (index != nil) {
            self.devicesArray.remove(at: index!)
            self.nearbyDevicesTable.deleteRows(at: [IndexPath.init(row: index!, section: 0)], with: UITableViewRowAnimation.automatic)
        }
        if (self.devicesArray.count == 0){
        circularProgress.isHidden = false;
        }
    }
    
    func connectToBean(bean: PTDBean!) {
        var error : NSError?
        self.beanManager?.connect(to: bean, withOptions:nil, error: &error)
        self.connectedBean = bean
    }
    
    
    // TABLE VIEW STUFF
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.devicesArray.count)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.nearbyDevicesTable.dequeueReusableCell(withIdentifier: "deviceCell", for: indexPath)
        cell.textLabel?.text = self.devicesArray[indexPath.row].name
        cell.textLabel?.textColor = UIColor.init(hexString: BBColors.accent)
        cell.textLabel?.textAlignment = NSTextAlignment.center
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.connectToBean(bean: self.devicesArray[indexPath.row])
        performSegue(withIdentifier: "pairControllerToBeanController", sender: self)
    }
    
}

