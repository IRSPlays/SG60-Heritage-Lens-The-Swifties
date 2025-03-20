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

            // Prediction Result Text Bar (Remove the "Prediction: " text from the prediction)
            Text(cleanPrediction(viewModel.prediction))  // Display only the clean prediction name
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
            Text(getInformation(for: cleanPrediction(viewModel.prediction)))
                .font(.body)
                .foregroundColor(.black)
                .padding()

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

    // Function to clean the prediction by removing unnecessary parts and only keeping the name
    func cleanPrediction(_ prediction: String) -> String {
        // Remove everything except the name of the prediction
        let cleanedPrediction = prediction
            .replacingOccurrences(of: "Prediction: ", with: "")  // Remove "Prediction: "
            .replacingOccurrences(of: " with \\d+% confidence", with: "", options: .regularExpression) // Remove confidence part
        return cleanedPrediction
    }

    // Function to return relevant information based on the prediction
    func getInformation(for prediction: String) -> String {
        switch prediction {
        case Gardens_By_The_Bay:
            return "Gardens by the Bay is a futuristic park located in the heart of Singapore, featuring iconic supertrees, cloud forests, and breathtaking landscapes."
        case Sentosa:
            return "Sentosa is a popular resort island in Singapore, known for its beaches, luxury resorts, theme parks, and attractions like Universal Studios Singapore."
        case Sultan_Mosque:
            return "The Sultan Mosque is a historic mosque located in Kampong Glam, Singapore. It is a stunning example of Islamic architecture."
        case Bhudda_Tooth_Relic_Temple:
            return "The Buddha Tooth Relic Temple is a Buddhist temple in Chinatown, Singapore, housing a relic believed to be a tooth of the Buddha."
        case Char_Kway_Teow:
            return "Char Kway Teow is a popular Singaporean stir-fried noodle dish made with flat rice noodles, eggs, prawns, and a variety of savory ingredients."
        case ChickenRice:
            return "Chicken Rice is a famous Singaporean dish consisting of poached or roasted chicken served with rice cooked in chicken fat, accompanied by chili sauce."
        case Chili_Crab:
            return "Chili Crab is a famous Singaporean seafood dish made with crab cooked in a sweet, spicy, and tangy chili sauce."
        case Dragon_Playground:
            return "Dragon Playground is a colorful and unique playground in Singapore shaped like a dragon, a nostalgic feature from Singapore's past."
        case East_Coast_Park:
            return "East Coast Park is a beautiful coastal park in Singapore, offering cycling paths, beaches, and a wide range of recreational activities."
        case Esplanade:
            return "The Esplanade – Theatres on the Bay is an iconic performing arts center in Singapore, known for its distinctive architecture and vibrant performances."
        case Former_Supreme_Court:
            return "The Former Supreme Court is a historical building in Singapore, now housing the National Gallery Singapore, a museum dedicated to Southeast Asian art."
        case HDB_Flats:
            return "HDB Flats are public housing developments in Singapore, providing affordable housing for the majority of Singaporeans."
        case Hokkien_Mee:
            return "Hokkien Mee is a Singaporean noodle dish made with stir-fried noodles, prawns, squid, and a savory broth, typically served with chili sauce."
        case Kaya_Toast:
            return "Kaya Toast is a traditional Singaporean breakfast snack consisting of toasted bread spread with kaya (coconut jam) and butter, often served with eggs."
        case Kopitiam:
            return "Kopitiam is a traditional coffee shop in Singapore, offering a variety of local dishes like kaya toast, laksa, and kopi (coffee)."
        case LRT:
            return "The LRT (Light Rail Transit) is a rapid transit system in Singapore, providing convenient transport to residential areas and the outskirts."
        case Laksa:
            return "Laksa is a spicy noodle soup, often served with prawns or chicken, in a rich, aromatic coconut milk broth."
        case MBS_Hotel:
            return "Marina Bay Sands is an iconic luxury hotel in Singapore, famous for its unique design, rooftop infinity pool, and panoramic views of the city."
        case MRT:
            return "The MRT (Mass Rapid Transit) is Singapore's extensive and efficient subway system, connecting all major areas of the city."
        case Merlion:
            return "The Merlion is a famous Singaporean landmark, symbolizing the city's heritage as a fishing port, with a lion's head and fish body."
        case Nasi_Lemak:
            return "Nasi Lemak is a Malaysian and Singaporean dish of coconut rice, usually served with fried chicken, eggs, and sambal."
        case Rojak:
            return "Rojak is a popular fruit and vegetable salad dish in Singapore, often served with a sweet and spicy dressing."
        case SG_Flag:
            return "The Singapore Flag represents the nation's history, featuring a crescent moon and five stars representing the country's ideals of democracy and peace."
        case Satay:
            return "Satay is a popular dish in Singapore consisting of skewered, grilled meat served with a peanut sauce."
        case Singapore_Public_Bus:
            return "Singapore's public buses are an affordable and efficient mode of transport, serving all parts of the island."
        case Sri_Mariamman_Temple:
            return "Sri Mariamman Temple is the oldest Hindu temple in Singapore, dedicated to the goddess Mariamman, known for its vibrant architecture."
        case St_Andrews_Cathedral:
            return "St. Andrews Cathedral is the largest cathedral in Singapore, a symbol of the Anglican faith, known for its neo-gothic architecture."
        case Vanda_Miss_Joaquim:
            return "Vanda Miss Joaquim is Singapore's national flower, a hybrid orchid named after the botanist who cultivated it."
        default:
            return "No additional information available."
        }
    }
}
