//
//  EditProfileViewController.swift
//  GameRush
//
//  Created by Nafla Diva Syafia (ID) on 21/11/24.
//

import Common
import UIKit

class EditProfileViewController: UIViewController {
    
    let titleLabel = UILabel()
    let nameTextField = UITextField()
    let emailTextField = UITextField()
    let saveButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ProfileEntity.synchronize()
        nameTextField.text = ProfileEntity.name
        emailTextField.text = ProfileEntity.email
    }
    
    func setupUI() {
        titleLabel.text = "Edit Profile"
        titleLabel.textColor = .textColor
        titleLabel.font = .systemFont(ofSize: 18.0, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32.0),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16.0),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16.0)
        ])
        
        let textFieldFrame = CGRect(origin: CGPoint(x: 100, y: 300), size: CGSize(width: 200, height: 50))
        nameTextField.frame = textFieldFrame
        nameTextField.backgroundColor = .foregroundColor
        nameTextField.layer.cornerRadius = 8.0
        nameTextField.textColor = .textColor
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameTextField)
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32.0),
            nameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16.0),
            nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16.0),
            nameTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        emailTextField.frame = textFieldFrame
        emailTextField.backgroundColor = .foregroundColor
        emailTextField.layer.cornerRadius = 8.0
        emailTextField.textColor = .textColor
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailTextField)
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16.0),
            emailTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16.0),
            emailTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16.0),
            emailTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        saveButton.backgroundColor = .primaryColor
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.backgroundColor, for: .normal)
        saveButton.layer.cornerRadius = 8.0
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveButton)
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 32.0),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 100),
            saveButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
    }

    @objc func save(_ sender: Any) {
        if let name = nameTextField.text, let email = emailTextField.text {
            if name.isEmpty {
                alertTextEmpty("Name")
            } else if email.isEmpty {
                alertTextEmpty("Email")
            } else {
                saveProfile(name, email)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func saveProfile(_ name: String, _ email: String) {
        ProfileEntity.name = name
        ProfileEntity.email = email
    }
    
    func alertTextEmpty(_ field: String) {
        let alert = UIAlertController(
            title: "Alert",
            message: "\(field) is empty",
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
