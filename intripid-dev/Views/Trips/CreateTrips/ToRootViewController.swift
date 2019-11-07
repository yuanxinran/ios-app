//
//  ToRootViewController.swift
//  intripid-dev
//
//  Created by Zoe Teoh  on 11/7/19.
//  Copyright © 2019 zona. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

class ToRootViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let button = UIButton(frame: CGRect(x: 80, y: 375, width: 200, height: 50))
    button.backgroundColor = UIColor(red: 52/255, green: 121/255, blue: 137/255, alpha: 1.0)
    button.setTitle("Back to Trips Page", for: .normal)
    button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    self.view.addSubview(button)
    
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 50))
    label.center = CGPoint(x: 180, y: 325)
    label.textAlignment = NSTextAlignment.center
    label.text = "Your trip has been successfully created! 🌻"
    self.view.addSubview(label)
  }

  @objc func buttonAction(sender: UIButton!) {
    let nextVC = UIHostingController(rootView: TripView())
    navigationController?.pushViewController(nextVC, animated: true)
    print("Button tapped")
  }
}
