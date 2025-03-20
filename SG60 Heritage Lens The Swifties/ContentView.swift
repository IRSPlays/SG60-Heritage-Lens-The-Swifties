import SwiftUI

struct ContentView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isAuthenticated: Bool = false
    @State private var errorMessage: String?
    
    let validEmail = "user@example.com"
    let validPassword = "password123"
    
    var body: some View {
        NavigationView {
            VStack {
                Text("SG60 Heritage Lens")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                    .padding(.bottom, 5)
                
                Text("Discover Singapore's rich heritage")
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
                
                HStack(spacing: 30) {
                    VStack {
                        Image(systemName: "camera.fill")
                            .foregroundColor(.red)
                        Text("Discover")
                            .font(.caption)
                    }
                    VStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.yellow)
                        Text("Explore")
                            .font(.caption)
                    }
                    VStack {
                        Image(systemName: "rosette")
                            .foregroundColor(.green)
                        Text("Earn Badges")
                            .font(.caption)
                    }
                }
                .padding(.bottom, 30)
                
                VStack(alignment: .leading) {
                    Text("Login to your account")
                        .font(.headline)
                        .padding(.bottom, 5)
                    
                    Text("Enter your username to start exploring Singapore")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.bottom, 10)
                }
                
                TextField("Your display name", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()
                
                SecureField("Your password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Button(action: login) {
                    Text("Start Exploring")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
                NavigationLink(destination: NavigationTab(), isActive: $isAuthenticated) {
                    EmptyView()
                }
            }
            .padding()
        }
    }
    
    func login() {
        if email == validEmail && password == validPassword {
            isAuthenticated = true
        } else {
            errorMessage = "Invalid credentials. Please try again."
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
