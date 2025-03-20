import SwiftUI
import UIKit

struct CoremlView: View {
    @StateObject private var viewModel = CoremlViewModel()
    @State private var isImagePickerPresented = false
    @State private var imageSource: UIImagePickerController.SourceType = .photoLibrary

    // List of variables (objects/locations/food items)
    let Gardens_By_The_Bay = "Gardens by the Bay"
    let Sentosa = "Sentosa"
    let Sultan_Mosque = "Sultan Mosque"
    let Bhudda_Tooth_Relic_Temple = "Buddha Tooth Relic Temple"
    let Char_Kway_Teow = "Char Kway Teow"
    let ChickenRice = "Chicken Rice"
    let Chili_Crab = "Chili Crab"
    let Dragon_Playground = "Dragon Playground"
    let East_Coast_Park = "East Coast Park"
    let Esplanade = "Esplanade"
    let Former_Supreme_Court = "Former Supreme Court"
    let HDB_Flats = "HDB Flats"
    let Hokkien_Mee = "Hokkien Mee"
    let Kaya_Toast = "Kaya Toast"
    let Kopitiam = "Kopitiam"
    let LRT = "LRT"
    let Laksa = "Laksa"
    let MBS_Hotel = "MBS Hotel"
    let MRT = "MRT"
    let Merlion = "Merlion"
    let Nasi_Lemak = "Nasi Lemak"
    let Rojak = "Rojak"
    let SG_Flag = "SG Flag"
    let Satay = "Satay"
    let Singapore_Public_Bus = "Singapore Public Bus"
    let Sri_Mariamman_Temple = "Sri Mariamman Temple"
    let St_Andrews_Cathedral = "St Andrews Cathedral"
    let Vanda_Miss_Joaquim = "Vanda Miss Joaquim"

    var body: some View {
        VStack {
            Spacer()

            // Display selected image
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .padding()
            } else {
                Text("No image selected")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
            }

            // Prediction Result Text Bar
            Text(viewModel.prediction)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .padding([.leading, .trailing], 20)
                .frame(maxWidth: .infinity)
                .border(Color.red, width: 2)
                .shadow(radius: 5)

            // Display additional info based on prediction
            if let prediction = viewModel.prediction {
                Text(getInformation(for: prediction))
                    .font(.body)
                    .foregroundColor(.black)
                    .padding()
            }

            Spacer()

            // Button to choose image source
            Button(action: {
                showImageSourceOptions()
            }) {
                Text("Take a Photo or Upload an Image")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(15)
                    .shadow(radius: 5)
            }
            .padding([.leading, .trailing], 20)

            // Button to trigger prediction
            Button(action: {
                print("Predict Image button tapped")
                viewModel.predictImage()  // Trigger the prediction
            }) {
                Text("Predict Image")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(viewModel.image != nil ? Color.green : Color.gray)
                    .cornerRadius(15)
                    .shadow(radius: 5)
            }
            .disabled(viewModel.image == nil) // Disable if no image
            .padding([.leading, .trailing], 20)

            Spacer()
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePickerView(image: $viewModel.image, sourceType: imageSource)
        }
    }

    // Action Sheet for image source selection
    func showImageSourceOptions() {
        let actionSheet = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: "Take a Photo", style: .default, handler: { _ in
            imageSource = .camera
            isImagePickerPresented.toggle()
        }))

        actionSheet.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { _ in
            imageSource = .photoLibrary
            isImagePickerPresented.toggle()
        }))

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        // Present action sheet
        UIApplication.shared.windows.first?.rootViewController?.present(actionSheet, animated: true)
    }

    // Function to return the corresponding information based on prediction
    func getInformation(for prediction: String) -> String {
        switch prediction {
        case Gardens_By_The_Bay:
            return "Gardens by the Bay is a famous park in Singapore with beautiful nature and modern architecture."
        case Sentosa:
            return "Sentosa is a popular resort island in Singapore known for its beaches, attractions, and hotels."
        case Sultan_Mosque:
            return "Sultan Mosque is a grand mosque in Singapore, one of the oldest and most beautiful in the city."
        case Bhudda_Tooth_Relic_Temple:
            return "The Buddha Tooth Relic Temple is a Buddhist temple and museum in Chinatown, Singapore."
        case Char_Kway_Teow:
            return "Char Kway Teow is a traditional Singaporean stir-fried noodle dish with egg, prawns, and Chinese sausage."
        case ChickenRice:
            return "Chicken Rice is a popular dish in Singapore, consisting of poached chicken, rice cooked in chicken fat, and dipping sauces."
        case Chili_Crab:
            return "Chili Crab is a famous Singaporean dish known for its spicy and savory crab cooked in a flavorful sauce."
        case Dragon_Playground:
            return "Dragon Playground is a nostalgic playground located in Singapore, known for its dragon-shaped slides."
        case East_Coast_Park:
            return "East Coast Park is a popular park in Singapore with recreational activities, beaches, and scenic views."
        case Esplanade:
            return "The Esplanade is a performing arts center in Singapore, known for its unique architecture and world-class performances."
        case Former_Supreme_Court:
            return "The Former Supreme Court is a historic building in Singapore, which now houses the National Gallery."
        case HDB_Flats:
            return "HDB Flats are public housing flats in Singapore, known for their high-rise design and affordability."
        case Hokkien_Mee:
            return "Hokkien Mee is a popular noodle dish in Singapore, served with prawns, squid, and a savory broth."
        case Kaya_Toast:
            return "Kaya Toast is a traditional breakfast snack in Singapore, consisting of toasted bread with kaya jam and butter."
        case Kopitiam:
            return "Kopitiam refers to a traditional coffee shop in Singapore where you can enjoy local beverages and snacks."
        case LRT:
            return "LRT stands for Light Rail Transit, a type of public transportation in Singapore."
        case Laksa:
            return "Laksa is a spicy noodle soup in Singapore, made with coconut milk and served with prawns, chicken, or fish."
        case MBS_Hotel:
            return "Marina Bay Sands is an iconic hotel in Singapore, famous for its rooftop infinity pool and stunning skyline views."
        case MRT:
            return "MRT stands for Mass Rapid Transit, a fast and efficient rail system that connects key areas of Singapore."
        case Merlion:
            return "The Merlion is a mythical creature and a famous landmark in Singapore, symbolizing the city’s heritage."
        case Nasi_Lemak:
            return "Nasi Lemak is a traditional Malay dish consisting of rice cooked in coconut milk, served with fried anchovies, peanuts, and egg."
        case Rojak:
            return "Rojak is a popular Singaporean salad dish made with a mix of fruits and vegetables, topped with a tangy dressing."
        case SG_Flag:
            return "The SG Flag is the national flag of Singapore, consisting of red and white with a crescent moon and five stars."
        case Satay:
            return "Satay is a popular street food in Singapore, consisting of skewered grilled meat served with peanut sauce."
        case Singapore_Public_Bus:
            return "Singapore Public Buses are an essential part of the city’s public transport system, providing an extensive network."
        case Sri_Mariamman_Temple:
            return "Sri Mariamman Temple is the oldest Hindu temple in Singapore, located in Chinatown."
        case St_Andrews_Cathedral:
            return "St Andrew's Cathedral is a historic Anglican cathedral in Singapore, known for its stunning architecture."
        case Vanda_Miss_Joaquim:
            return "Vanda Miss Joaquim is Singapore’s national flower, a hybrid orchid known for its beauty."
        default:
            return "No information available for this prediction."
        }
    }
}
