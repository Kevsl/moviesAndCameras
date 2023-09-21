import UIKit
import PhotosUI


class ImagesViewController: UIViewController {

    var picker = UIImagePickerController()
    var libraryPicker: PHPickerViewController?
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfig()
        checkCamera()
    }
    
    func checkCamera(){
        
        let hasCamera = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        if(hasCamera){
            setupPicker()
        }
    }
    
    
    @IBAction func openLibrary(_ sender: UIButton) {
        self.present(libraryPicker!, animated: true)

    }
    
    @IBAction func openCamera(_ sender: UIButton) {
        self.present(picker, animated: true)

    }
    
    @IBAction func alertAction(_ sender: UIButton) {
        let alertController = UIAlertController(title:" Demande d'autorisation", message: "Nous revendons vos données très cher." , preferredStyle: .alert)
        let action = UIAlertAction(title: "Allez y" , style:.default){
            act in  alertController.dismiss(animated: true , completion: nil)
        }
        let cancel = UIAlertAction(title: "Retour", style: .cancel)
        
        
        alertController.addAction(action)
        alertController.addAction(cancel)
        
        present(alertController, animated:true)

        
        
        
        
        
        
        
    }
}


extension ImagesViewController: PHPickerViewControllerDelegate {
  
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion:  nil)
        
        if let r = results.first {
            let item = r.itemProvider
            if item.canLoadObject(ofClass: UIImage.self){
                item.loadObject(ofClass: UIImage.self){
                    image, error in
                    DispatchQueue.main.async {
                        if let newImage = image as? UIImage{
                            self.imageView.image = newImage
                        }
                        print(error?.localizedDescription)
                    }
                }
            }
            
        }
        
    }
    
        func setupConfig(){
            var config = PHPickerConfiguration()
            config.filter = .images
            config.selectionLimit = 1
            config.preferredAssetRepresentationMode = .automatic
            libraryPicker = PHPickerViewController(configuration: config)
            libraryPicker!.delegate = self
    }
}

extension ImagesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func setupPicker(){
        picker.sourceType = .camera
        picker.delegate = self
        picker.allowsEditing = false
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.imageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
        
    }
}


