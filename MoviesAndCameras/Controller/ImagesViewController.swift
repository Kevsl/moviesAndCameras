import UIKit
import PhotosUI


class ImagesViewController: UIViewController {

    var picker = UIImagePickerController()
    var libraryPicker: PHPickerViewController?
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfig()
        
    }
    
    func checkCamera(){
        
        let hasCamera = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        
        
    }
    
    
    @IBAction func openLibrary(_ sender: UIButton) {
        self.present(picker, animated: true)

    }
    
    @IBAction func openCamera(_ sender: UIButton) {
    }
    
    @IBAction func alertAction(_ sender: UIButton) {
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
