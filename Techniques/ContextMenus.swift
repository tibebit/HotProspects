//
//  ContextMenus.swift
//  Techniques
//
//  Created by Fabio Tiberio on 18/03/22.
//

import SwiftUI

struct ContextMenus: View {
    @State private var backgroundColor = Color.red
    
    var body: some View {
        VStack {
            Text("Hello, World!")
                .padding()
                .background(backgroundColor)
            
            Text("Change Color")
                .padding()
                .contextMenu {
                    Button("Red") {
                        backgroundColor = .red
                    }
                    
                    Button("Green") {
                        backgroundColor = .green
                    }
                    
                    Button(role: .destructive) {
                        backgroundColor = .blue
                    } label: {
                        Label("Red", systemImage: "checkmark.circle.fill")
                                .foregroundColor(.red)
                    }
                }
        }
    }
}

struct ContextMenus_Previews: PreviewProvider {
    static var previews: some View {
        ContextMenus()
    }
}
