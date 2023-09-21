import UIKit



class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieTitle : UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    
    var object: Movie!

    func setup(_ newObject: Movie) {
        object = newObject
        movieTitle.text = object.Title
        
        if let posterURL = URL(string: object.Poster) {
            URLSession.shared.dataTask(with: posterURL) { [weak self] (data, _, error) in
                guard let self = self, let data = data, error == nil else {
                    return
                }
                
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        self.movieImage.image = image
                    }
                }
            }.resume()
        }
    }
}

    
    
    
    

 


