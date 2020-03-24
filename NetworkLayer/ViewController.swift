//
//  ViewController.swift
//  NetworkLayer
//
//  Created by Valeriy Kutuzov on 24.03.2020.
//  Copyright © 2020 Valeriy Kutuzov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad()
	{
		super.viewDidLoad()
		createGetButton()
		createGetButton2()
		// Do any additional setup after loading the view.
	}
	
	private func createGetButton()
	{
		let button = UIButton(type: .system)
		button.tag = 1
		button.setTitle("getDictionaries(instruments)", for: .normal)
		button.addTarget(self, action: #selector(getDict), for: .touchUpInside)
		button.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(button)
		
		NSLayoutConstraint.activate([
			button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -16)
		])
	}
	
	private func createGetButton2()
	{
		let button = UIButton(type: .system)
		button.setTitle("getDictionaries(companies)", for: .normal)
		button.tag = 2
		button.addTarget(self, action: #selector(getDict(_:)), for: .touchUpInside)
		button.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(button)
		
		NSLayoutConstraint.activate([
			button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 16)
		])
	}
	
	@objc private func getDict(_ sender: UIButton)
	{
		var types: [String]
		switch sender.tag {
		case 2:
			types = ["companies"]
		default:
			types = ["instruments"]
		}
		let manager = NetworkManager()
		manager.getDictionaries(types: types) { [weak self] (result) in
			switch result {
            case .success(_, let data):
                guard let responseData = data,
					let json = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) else {
					self?.showAlert(message: RouterError.unsupportedResponse.localizedDescription)
                    return
                }
				self?.showAlert(message:json)
            case .failure(let error):
				self?.showAlert(message: error.localizedDescription)
            }
		}
	}

	private func showAlert(message: Any)
	{
		let alert = UIAlertController(title: "Alert", message: "\(message)", preferredStyle: .alert)
		let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
			self.dismiss(animated: true, completion: nil)
		}
		alert.addAction(okAction)
		DispatchQueue.main.async {
			self.show(alert, sender: self)
		}
	}
}

