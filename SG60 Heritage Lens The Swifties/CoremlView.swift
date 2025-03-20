import SwiftUI
import UIKit

struct CoremlView: View {
    @StateObject private var viewModel = CoremlViewModel()
    @State private var isImagePickerPresented = false
    @State private var imageSource: UIImagePickerController.SourceType = .photoLibrary

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
                viewModel.predictImage()
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
}
