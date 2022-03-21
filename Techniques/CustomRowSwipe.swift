//
//  CustomRowSwipe.swift
//  Techniques
//
//  Created by Fabio Tiberio on 18/03/22.
//

import SwiftUI

struct CustomRowSwipe: View {
    var body: some View {
        List {
            Text("Taylor Swift")
                .swipeActions {
                    Button(role: .destructive) {
                        print("Hi")
                    } label: {
                        Label("Delete", systemImage: "minus.circle")
                    }
                }
                .swipeActions(edge: .leading) {
                    Button {
                        print("Hi")
                    } label: {
                        Label("Pin", systemImage: "pin")
                    }
                    .tint(.orange)
                }
        }
    }
}

struct CustomRowSwipe_Previews: PreviewProvider {
    static var previews: some View {
        CustomRowSwipe()
    }
}
