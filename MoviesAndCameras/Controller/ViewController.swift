
import UIKit


struct Movie: Codable {
    let Title: String
    let Year: String
    let imdbID: String
    let Poster: String
}

struct MovieDatas: Codable {
    let Search: [Movie]
    let totalResults: String
    let Response: String
}

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchInputField: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var movieDatas: MovieDatas?
    var moviesList: [Movie] = []

    
    func getMovies() {
        guard let searchValue = searchInputField.text else {
            return
        }

        let urlString = "https://www.omdbapi.com/?s=\(searchValue)&apikey=c6c2a5e9"

        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let self = self else { return }

                if let moviesData = data {
                    do {
                        let moviesList = try JSONDecoder().decode(MovieDatas.self, from: moviesData)
                        self.movieDatas = moviesList

                        DispatchQueue.main.async {
                            self.moviesList =
                            self.movieDatas?.Search ?? []
//                            self.setUpTableView()
                            self.tableView.reloadData()

                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
