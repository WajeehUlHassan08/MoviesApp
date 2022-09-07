//
//  MovieTableViewCell.swift
//  MoviesApp
//
//  Created by Wajeeh Ul Hassan on 07/09/2022.
//

import UIKit

protocol MovieCellErrorDelegate: AnyObject {
    func initiateErrorMsg(err: NetworkError)
}

class MovieTableViewCell: UITableViewCell {
    
    static let reuseId = "\(MovieTableViewCell.self)"
    
    // FIXME: Fix constraint for imageView and to show all overview text
    lazy var movieImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 5.0
        imageView.image = UIImage(named: "posterimagee")
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy var overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 5
        return label
    }()
    
    var delegate: MovieCellErrorDelegate?
    var movie: Movie?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUpUI() {
        
        contentView.addSubview(movieImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(overviewLabel)
        
        movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        movieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        movieImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        movieImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        
        titleLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 5).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        
        
        overviewLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 5).isActive = true
        overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        
        
    }
    
    func configure(movie: Movie, network: NetworkManager) {
        
        self.movie = movie
        
        self.titleLabel.text = movie.title
        self.overviewLabel.text = movie.overview
        
        
        if let imageData = ImageCache.shared.getImageData(key: movie.posterPath) {
            self.movieImageView.image = UIImage(data: imageData)
            return
        }
        
        DispatchQueue.main.async {
            
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)")
            network.fetchImageData(urlStr: url) { result in
                switch result {
                case .success(let imageData):
                    DispatchQueue.main.async {
                        ImageCache.shared.setImageData(data: imageData, key: movie.posterPath)
                        
                        if movie.id == (self.movie?.id ?? -1) {
                            self.movieImageView.image = UIImage(data: imageData)
                        }
                    }
                case .failure(let error):
                    print(error)
                    self.delegate?.initiateErrorMsg(err: error)
                }
            }
        }
        
    }
    
    
    override func prepareForReuse() {
        self.titleLabel.text = "Movie Title"
        self.overviewLabel.text = "Movie Description"
        self.movieImageView.image = UIImage(named: "posterimagee")
        self.movie = nil
    }
    
}
