//
//  ContentView.swift
//  ChatApp
//
//  Created by Luthfi Abdul Azis on 14/03/21.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @StateObject var viewModel = AuthViewModel()
    
    var body: some View {
        ZStack {
            if isLoggedIn {
                HomeView()
            }else {
                if viewModel.isLogin {
                    LoginView(viewModel: viewModel)
                }else {
                    RegisterView(viewModel: viewModel)
                }
            }
        }
        .alert(isPresented: $viewModel.error, content: {
            Alert(title: Text("Error"), message: Text(viewModel.errorMsg))
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
