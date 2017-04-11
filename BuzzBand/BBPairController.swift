//
//  ViewController.swift
//  BuzzBand
//
//  Created by Arnold Balliu on 4/10/17.
//  Copyright © 2017 Arnold Balliu. All rights reserved.
//

import UIKit

class BBPairController: UIViewController, PTDBeanManagerDelegate, PTDBeanDelegate , UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var nearbyDevicesTable: UITableView!
    
    var beanManager: PTDBeanManager?
    var myBean: PTDBean?
    var devicesArray = [PTDBean]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.nearbyDevicesTable.delegate = self
        
        self.beanManager = PTDBeanManager()
        self.beanManager!.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
    
    func beanManager(_ beanManager: PTDBeanManager!, didDiscover bean: PTDBean!, error: Error!) {
        
        if let e = error {
            print(e)
        }
        
        self.devicesArray.append(bean)
        self.nearbyDevicesTable.reloadData()
    }
    
    func connectToBean(bean: PTDBean!) {
        var error : NSError?
        self.beanManager?.connect(to: bean, withOptions:nil, error: &error)
        bean.delegate = self
    }
    
    
    // TABLE VIEW STUFF
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.devicesArray.count)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("hi")
        let cell = self.nearbyDevicesTable.dequeueReusableCell(withIdentifier: "deviceCell", for: indexPath)
        cell.textLabel?.text = self.devicesArray[indexPath.row].name
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.textAlignment = NSTextAlignment.center
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }

}

