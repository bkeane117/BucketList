//
//  ContentView.swift
//  BucketList
//
//  Created by Brendan Keane on 2021-05-13.
//

import SwiftUI
import LocalAuthentication

struct ContentView: View {

    @State private var isUnlocked = false
    @State private var unlockError = false
    
    var body: some View {
        ZStack {
            if isUnlocked {
                MapContentView()
            } else {
                Button("Unlock Places") {
                    self.authenticate()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
        }
        
        .alert(isPresented: $unlockError) {
            Alert(title: Text("Error, Bad Login Credentials"), message: Text("Please try again"), dismissButton: .cancel())
        }
 
    }
    func authenticate() {
        let context = LAContext()
        //context.localizedFallbackTitle = "Use Passcode"
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            //this string is used for touch ID, where the one in infoPlist is used for face ID
            let reason = "please authenticate yourself to unlock your places"
            
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authentication in
            
            DispatchQueue.main.async {
                if success {
                    self.isUnlocked = true
                } else {
                    //self.unlockError = true
                    print(error?.localizedDescription ?? "Failed to authenticate")
                }
            }
        }
        } else {
            print(error?.localizedDescription ?? "No Biometrics")
            // no biometrics
        }
    }
}

/*
import LocalAuthentication

enum LoadingState {
    case loading, success, failed
}

struct LoadingView: View {
    var body: some View {
        Text("Loading...")
    }
}

struct SuccessView: View {
    var body: some View {
        Text("Success!")
    }
}

struct FailedView: View {
    var body: some View {
        Text("Failed")
    }
}

struct ContentView: View {
    @State private var isUnlocked = false
    var body: some View {
        VStack {
            if self.isUnlocked {
                Text("Unlocked")
            } else {
                Text("Locked")
            }
        }
        .onAppear(perform: authenticate)
    }
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "We need to unlock your data."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        // authenticated successfully
                        self.isUnlocked = true
                    } else {
                        // there was a problem
                    }
                }
            }
        } else {
            // no biometrics
        }
    }
}

*/
/*
struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
            .onTapGesture {
                let str = "Test Message"
                let url = self.getDocumentsDirectory().appendingPathComponent("message.txt")
                
                do {
                    try str.write(to: url, atomically: true, encoding: .utf8)
                    let input = try String(contentsOf: url)
                    print(input)
                } catch {
                    print(error.localizedDescription)
                }
            }
    }
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // just send back the first one, which ought to be the only one
        return paths[0]
    }
}
*/
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
