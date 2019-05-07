//
//  ViewController.swift
//  Clock
//
//  Created by Nguyen Dao Huong Tra on 07/05/2019.
//  Copyright © 2019 jasmine. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    let clock = Clock()
    let formatter = DateFormatter()
    
    var timer: Timer?
    
    deinit  {
        NotificationCenter.default.removeObserver(self)
        
        if let timer = self.timer {
            timer.invalidate()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateTimeLabel()
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: Selector(("updateTimeLabel")), userInfo: nil, repeats: true)
        
        NotificationCenter.default.addObserver(self,
                                               selector: Selector(("updateTimeLabel")),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateTimeLabel()
    }

    @objc func updateTimeLabel() {
        formatter.timeStyle = .medium
        timeLabel.text = formatter.string(from: clock.currentTime)
    }
}

