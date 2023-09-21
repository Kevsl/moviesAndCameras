
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
        searchInputField.delegate = self
        
        
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
                          self.setupTableView()
                            self.tableView.reloadData()

                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    @IBAction func searchAction(_ sender: UITextField) {
        
        getMovies()
        
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension ViewController: UITableViewDelegate,UITableViewDataSource{
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let object = moviesList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MovieTableViewCell
        
        cell.setup(object)
        return cell
        
    }
    
    
}
