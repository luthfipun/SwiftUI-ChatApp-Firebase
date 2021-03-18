//
//  AuthView.swift
//  ChatApp
//
//  Created by Luthfi Abdul Azis on 14/03/21.
//

import SwiftUI

struct RegisterView: View {
    
    @ObservedObject var viewModel: AuthViewModel
    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        VStack {
            Text("Register")
                .font(.title)
                .fontWeight(.bold)
            
            TextField("Name", text: $name)
                .font(.callout)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .disableAutocorrection(true)
            
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
                viewModel.signUp(name: name, email: email, password: password)
            }, label: {
                Text("Register")
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
                Text("Login")
                    .padding(.horizontal)
            })
        }
        .blur(radius: viewModel.loading ? 8.0 : 0.0)
        .overlay(
            viewModel.loading ? ProgressView() : nil
        )
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
