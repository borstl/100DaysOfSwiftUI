//
//  ThickDivider.swift
//  Moonshot
//
//  Created by Sebastian Becker on 03.01.24.
//

import SwiftUI

struct ThickDivider: View {
  var body: some View {
    Rectangle()
      .frame(height: 2)
      .foregroundStyle(.lightBackground)
      .padding(.vertical)
  }
}

#Preview {
  ThickDivider()
}
