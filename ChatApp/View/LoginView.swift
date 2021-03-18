//
//  LoginView.swift
//  ChatApp
//
//  Created by Luthfi Abdul Azis on 14/03/21.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject var viewModel: AuthViewModel
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        VStack {
            Text("Login")
                .font(.title)
                .fontWeight(.bold)
            
            TextField("Email", text: $email)
                .font(.callout)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .disableAutocorrection(true)
            
            SecureField("Password", text: $password)
                .font(.callout)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button(action: {
                viewModel.signIn(email: email, password: password)
            }, label: {
                Text("Login")
                    .fontWeight(.semibold)
                    .frame(width: UIScreen.main.bounds.width / 2, height: 40)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .padding()
            })
            
            Button(action: {
                viewModel.isLogin.toggle()
            }, label: {
                Text("Register")
                    .padding(.horizontal)
            })
        }
        .blur(radius: viewModel.loading ? 8.0 : 0.0)
        .overlay(
            viewModel.loading ? ProgressView() : nil
        )
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
