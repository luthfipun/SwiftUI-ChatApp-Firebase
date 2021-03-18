//
//  SettingView.swift
//  ChatApp
//
//  Created by Luthfi Abdul Azis on 17/03/21.
//

import SwiftUI
import Firebase

struct SettingView: View {
    
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = true
    
    var body: some View {
        Button(action: {
            
            do {
                try Auth.auth().signOut()
                isLoggedIn = false
            }catch {
                print(error)
            }
            
        }, label: {
            Text("Logout")
        })
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
