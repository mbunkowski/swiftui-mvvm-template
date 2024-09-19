//
//  RegistrationView.swift
//  Template
//
//  Created by Mateusz Bunkowski on 6/29/24.
//

import SwiftUI

struct RegistrationView: View {
    
    enum Field {
        case email
        case password
        case confirmPassword
    }
    
    @Environment(\.dismiss) private var dismiss
    
    @FocusState private var focusedField: Field?
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Email", text: $email)
                    .frame(height: 32)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .focused($focusedField, equals: .email)
                    .submitLabel(.next)
                Divider()
                    .padding(.bottom, 4)
                SecureField("Password", text: $password)
                    .frame(height: 32)
                    .textContentType(.newPassword)
                    .focused($focusedField, equals: .password)
                    .submitLabel(.next)
                Divider()
                    .padding(.bottom, 4)
                SecureField("Confirm Password", text: $confirmPassword)
                    .frame(height: 32)
                    .textContentType(.newPassword)
                    .focused($focusedField, equals: .confirmPassword)
                    .submitLabel(.go)
                Divider()
                    .padding(.bottom, 30)
                Button(action: {
                    
                }, label: {
                    Text("Register")
                        .frame(maxWidth: .infinity, maxHeight: 32)
                }).buttonStyle(BorderedProminentButtonStyle())
                    .disabled(isValidInput)
                Spacer()
                
            }
            .padding(.top, 32)
            .padding(.horizontal, 32)
            .onSubmit {
                switch focusedField {
                case .email:
                    focusedField = .password
                case .password:
                    focusedField = .confirmPassword
                default:
                    register()
                }
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Button(action: {
                            goToPreviousField()
                        }, label: {
                            Image(systemName: "chevron.left")
                        })
                        .disabled(focusedField == .email)
                        Button(action: {
                            goToNextField()
                        }, label: {
                            Image(systemName: "chevron.right")
                        })
                        .disabled(focusedField == .confirmPassword)
                        Spacer()
                        Button("Done") {
                            focusedField = nil
                        }
                    }
                }
            }
            .navigationTitle("Create Account")
        }
    }
}

extension RegistrationView {
    
    private func goToPreviousField() {
        switch focusedField {
        case .password:
            focusedField = .email
        case .confirmPassword:
            focusedField = .password
        default:
            break
        }
    }
    
    private func goToNextField() {
        switch focusedField {
        case .email:
            focusedField = .password
        case .password:
            focusedField = .confirmPassword
        default:
            break
        }
    }
    
    private var isValidInput: Bool {
        return email.count > 6 && password.count >= 8 && confirmPassword == password
    }
    
    private func register() {
        
    }
}
