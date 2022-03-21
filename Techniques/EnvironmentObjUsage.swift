//
//  EnvironmentObjUsage.swift
//  Techniques
//
//  Created by Fabio Tiberio on 18/03/22.
//

import SwiftUI

@MainActor class User: ObservableObject {
    @Published var name = "Taylor Swift"
}

struct EnvironmentObjUsage: View {
    @StateObject var user = User()
    
    var body: some View {
        VStack {
            EditView().environmentObject(user)
            DisplayView().environmentObject(user)
        }
    }
}

struct EditView: View {
    @EnvironmentObject var user: User

    var body: some View {
        TextField("Name", text: $user.name)
    }
}

struct DisplayView: View {
    @EnvironmentObject var user: User

    var body: some View {
        Text(user.name)
    }
}

struct EnvironmentObjUsage_Previews: PreviewProvider {
    static var previews: some View {
        EnvironmentObjUsage()
    }
}
