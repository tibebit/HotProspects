//
//  SwiftPackegesDependencies.swift
//  Techniques
//
//  Created by Fabio Tiberio on 18/03/22.
//

import SwiftUI
import SamplePackage

struct SwiftPackegesDependencies: View {
    var possibleNumbers = Array(1...60)
    var results: String {
        let selected = possibleNumbers.random(7).sorted()
        let strings = selected.map(String.init)
        return strings.joined(", ")
    }
    var body: some View {
        Text(results)
    }
}

struct SwiftPackegesDependencies_Previews: PreviewProvider {
    static var previews: some View {
        SwiftPackegesDependencies()
    }
}
