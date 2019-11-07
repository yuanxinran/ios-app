//
//  ToRootViewControllerWrapper.swift
//  intripid-dev
//
//  Created by Zoe Teoh  on 11/7/19.
//  Copyright © 2019 zona. All rights reserved.
//

import SwiftUI
import UIKit

struct ToRootViewControllerWrapper: UIViewControllerRepresentable {
  typealias UIViewControllerType = ToRootViewController

    func makeUIViewController(context: UIViewControllerRepresentableContext<ToRootViewControllerWrapper>) -> ToRootViewControllerWrapper.UIViewControllerType {
        return ToRootViewController()
    }

    func updateUIViewController(_ uiViewController: ToRootViewControllerWrapper.UIViewControllerType, context: UIViewControllerRepresentableContext<ToRootViewControllerWrapper>) {
    }
}

