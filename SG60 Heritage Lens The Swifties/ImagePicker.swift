import SwiftUI
import UIKit

struct ImagePicker: View {
    @Binding var image: UIImage?
    var sourceType: UIImagePickerController.SourceType
    
    @Environment(\.dismiss) var dismiss
    
    @State private var isImagePickerPresented = true
    
    var body: some View {
        VStack {
            Text("Select or Take a Photo")
                .font(.headline)
                .padding()
            
            ImagePickerView(image: $image, sourceType: sourceType)
                .onChange(of: image) { newImage in
                    if newImage != nil {
                        dismiss()
                    }
                }
            
            Spacer()
        }
        .onAppear {
            isImagePickerPresented = true
        }
    }
}

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var sourceType: UIImagePickerController.SourceType
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        @Binding var image: UIImage?
        
        init(image: Binding<UIImage?>) {
            _image = image
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let pickedImage = info[.originalImage] as? UIImage {
                image = pickedImage
            }
            picker.dismiss(animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(image: $image)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
