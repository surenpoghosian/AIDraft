//
//  User.swift
//  AI Draft
//
//  Created by Suren Poghosyan on 07.07.23.
//

import Foundation
import AuthenticationServices

struct User  {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    
    init(credentials: ASAuthorizationAppleIDCredential ) {
        self.id = credentials.user
        self.firstName = credentials.fullName?.givenName ?? ""
        self.lastName = credentials.fullName?.familyName ?? ""
        self.email = credentials.email ?? ""
    }
    

}
