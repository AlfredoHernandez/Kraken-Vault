//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import SwiftUI

struct CreatePasswordView: View {
    @Binding var displayingForm: Bool
    @State var showPassword = false
    @State var passwordName = ""
    @State var username = ""
    @State var password = ""
    @State var siteName = ""

    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading) {
                            Text("Name").bold()
                            TextField("Kraken Vault", text: $passwordName)
                                .textContentType(.organizationName)
                                .keyboardType(.asciiCapable)
                        }

                        VStack(alignment: .leading) {
                            Text("Username or e-mail").bold()
                            TextField("Username/e-mail", text: $username, prompt: Text("mail@krakenvault.com"))
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .disableAutocorrection(true)
                        }

                        VStack(alignment: .leading) {
                            Text("Password").bold()
                            HStack {
                                if !showPassword {
                                    SecureField("Your password", text: $password)
                                        .textContentType(.password)
                                        .keyboardType(.asciiCapable)
                                } else {
                                    TextField("Password", text: $password, prompt: Text("Your password"))
                                        .textContentType(.password)
                                        .keyboardType(.asciiCapable)
                                        .disableAutocorrection(true)
                                }
                            }.overlay(alignment: .trailing) {
                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                    .onTapGesture {
                                        showPassword.toggle()
                                    }
                            }
                        }

                        VStack(alignment: .leading) {
                            Text("Site URL").bold()
                            TextField("Site", text: $siteName, prompt: Text("https://your-site.com"))
                                .textContentType(.URL)
                                .keyboardType(.URL)
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                        }
                    }
                }
            }
            .navigationTitle(Text("New Password"))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { displayingForm = false }, label: {
                        Text("Cancel")
                    })
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}, label: {
                        Text("Save")
                    })
                }
            }
        }
    }
}

struct CreatePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePasswordView(displayingForm: .constant(true))
    }
}
