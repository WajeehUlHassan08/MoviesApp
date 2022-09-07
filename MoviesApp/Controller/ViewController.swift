//
//  ViewController.swift
//  MoviesApp
//
//  Created by Wajeeh Ul Hassan on 07/09/2022.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var movieTable: UITableView = {
        let table = UITableView(frame: .zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.prefetchDataSource = self
        table.rowHeight = UITableView.automaticDimension
        table.backgroundColor = .systemCyan
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.reuseId)
        return table
    }()
    
    let network: NetworkManager = NetworkManager()
    var movies: [Movie] = []
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        
        title = "Movies"
        
        self.setUpUI()
        self.requestPage()
    }
    
    private func setUpUI() {
        self.view.addSubview(self.movieTable)
        
        movieTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        movieTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        movieTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        movieTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func requestPage() {
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=705f7bed4894d3adc718c699a8ca9a4f&language=en-US&page=\(self.currentPage + 1)")
        
        self.network.fetchPage(urlStr: url) { result in
            
            switch result {
            case .success(let page):
                self.currentPage += 1
                self.movies.append(contentsOf: page.results)
                DispatchQueue.main.async {
                    self.movieTable.reloadData()
                }
            case .failure(let error):
                print(error)
                
            }
            
        }
    }
    
    
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseId, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(movie: self.movies[indexPath.row], network: self.network)
        return cell
    }
    
}

extension ViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let lastIndexPath = IndexPath(row: self.movies.count - 1, section: 0)
        guard indexPaths.contains(lastIndexPath) else { return }
        self.requestPage()
    }
    
}




