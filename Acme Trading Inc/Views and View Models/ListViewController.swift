//
//  ViewController.swift
//  Acme Trading Inc
//
//  Created by Richard Stockdale on 10/11/2020.
//

import UIKit

class ListViewController: UIViewController {

    let vm = ListViewModel()
    private let refreshControl = UIRefreshControl()
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named: "titleBarLogo")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(loginOrLoad), for: .valueChanged)
    }
    
    @IBAction func clearTokenTapped(_ sender: Any) {
        print("Clearing token for testing purposes")
        AuthenticationManager().clearKeychain()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loginOrLoad()
    }
}

// MARK: - Login Or Load
extension ListViewController {
    @objc private func loginOrLoad() {
        if vm.validToken {
            vm.load { (success, errorMessage) in
                if success {
                    self.tableView.reloadData()
                }
                else {
                    self.displayMessage(message: errorMessage)
                }
                
                self.refreshControl.endRefreshing()
            }
        }
        else {
            showLogin()
        }
    }
    
    private func displayMessage(message: String?) {
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func showLogin() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vc.delegate = self
        present(vc, animated: false, completion: nil)
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.sortedProfiles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        
        if let model = vm.sortedProfiles?[indexPath.row] {
            cell.populate(row: model, isFirst: indexPath.row == 0)
        }
        
        return cell
    }
}

extension ListViewController: LoginViewControllerDelegate {
    func completed() {
        loginOrLoad()
    }
}

class ProfileCell: UITableViewCell {
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var profileNameLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private var stars: [UIImageView]!
    @IBOutlet private weak var numberOfRatings: UILabel!
    @IBOutlet private weak var topConstraint: NSLayoutConstraint!
    
    private let isTopBannerHeight: CGFloat = 46.0
    
    private var model: ProfileItem?
    private var imgCache: ImageCache.ImageItem?
    
    func populate(row: ListViewModel.ProfileRow, isFirst: Bool) {
        self.model = row.model
        self.imgCache = row.imgCache
        self.imgCache?.registerForUpdates {
            self.profileImageView.image = self.imgCache?.image?.roundImage()
        }
        
        profileNameLabel.text = model!.name
        distanceLabel.text = model!.distanceFromUser
        numberOfRatings.text = "(\(model!.numRatings))"
        setStars(model!.starLevel)
        profileImageView.image = imgCache?.image?.roundImage()
        
        topConstraint.constant = isFirst ? isTopBannerHeight : 0
    }
    
    private func setStars(_ num: Int) {
        for (index, star) in stars.enumerated() {
            var imageName = "star"
            if index <= num {
                imageName = "star.fill"
            }
            
            star.image = UIImage(systemName: imageName)
        }
    }
}


