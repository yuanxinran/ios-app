//
//  TripViewModePicker.swift
//  intripid-dev
//
//  Created by Zoe Teoh  on 10/28/19.
//  Copyright © 2019 zona. All rights reserved.
//

import SwiftUI

struct TripViewModePicker: View {
  @Binding var viewMode: [String]
  @Binding var selectedViewMode: Int
  
  var body: some View {
      VStack {
        Picker("Numbers", selection: $selectedViewMode) {
            ForEach(0 ..< viewMode.count) { index in
                Text(self.viewMode[index]).tag(index)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
      }
  }
}

struct TripViewModePicker_Previews: PreviewProvider {
  @State static var viewMode = ["List", "Map"]
  @State static var selectedViewMode = 0
  
    static var previews: some View {
      TripViewModePicker(viewMode: $viewMode, selectedViewMode: $selectedViewMode)
    }
}
