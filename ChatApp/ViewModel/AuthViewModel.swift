//
//  AuthViewModel.swift
//  ChatApp
//
//  Created by Luthfi Abdul Azis on 14/03/21.
//

import Foundation
import SwiftUI
import Combine
import Firebase
import FirebaseFirestoreSwiftTarget
import FirebaseFirestoreSwift
import FirebaseFirestoreTarget

class AuthViewModel: ObservableObject {
    @Published var loading: Bool = false
    @Published var errorMsg: String = ""
    @Published var error: Bool = false
    @Published var isLogin: Bool = false
    
    @AppStorage("isLoggedIn") var loggedIn = true
}

extension AuthViewModel {
    
    func signIn(email: String, password: String) {
        
        if !validateLoginForm(email: email, password: password) {
            errorMsg = "please complete the field"
            error.toggle()
            return
        }
        
        loading.toggle()
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            self.loading.toggle()
            
            if error != nil {
                print(error?.localizedDescription ?? "")
                self.errorMsg = (error?.localizedDescription ?? "")
                self.error.toggle()
                return
            }
            
            self.loggedIn = true
            
        }
    }
    
    private func validateLoginForm(email: String, password: String) -> Bool {
        return !email.isEmpty && !password.isEmpty
    }
    
    func signUp(name: String, email: String, password: String) {
        
        if !validateRegisterForm(name: name, email: email, password: password) {
            errorMsg = "please complete the field"
            error.toggle()
            return
        }
        
        loading.toggle()
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, err) in
            self.loading.toggle()
            
            if err != nil {
                print(err?.localizedDescription ?? "")
                self.errorMsg = (err?.localizedDescription ?? "")
                self.error.toggle()
                return
            }
            
            let userData = authResult?.user
            let user = User(id: userData!.uid, name: name, email: email, photo: "", timestamp: Timestamp(date: Date()))
            
            do {
                try Firestore.firestore()
                    .collection(StoragePath.USER.rawValue)
                    .addDocument(from: user)
                
                self.loggedIn = true
            }catch {
                print(error.localizedDescription)
                self.errorMsg = (error.localizedDescription)
                self.error.toggle()
            }
        }
    }
    
    private func validateRegisterForm(name: String, email: String, password: String) -> Bool {
        return !name.isEmpty && !email.isEmpty && !password.isEmpty
    }
}
