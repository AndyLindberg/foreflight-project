//
//  ViewController.swift
//  ForeFlightProject
//
//  Created by Andy Lindberg on 5/12/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var textField: UITextField!
    
    var airportsArray:[String]? = []
    let userDefaults = UserDefaults.standard
    let detailsViewController = AirportDetailsViewController()
    
    var result: AirportModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        textField.backgroundColor = .black
        textField.attributedPlaceholder = NSAttributedString(
            string: "Add New Airport",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        //Check if user has added custom locations, if not we start with KPWM and KAUS
        if let airports = userDefaults.object(forKey: "myAirports") as? [String] {
            airportsArray = airports
        }else {
            airportsArray = ["KPWM", "KAUS"]
            userDefaults.set(airportsArray, forKey: "myAirports")
        }
        tableView.backgroundColor = .black
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return airportsArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AirportTableViewCell", for: indexPath) as? AirportTableViewCell else {
            return UITableViewCell()
        }
        cell.airportIdentifier.text = airportsArray?[indexPath.row]
        
        if (indexPath.row % 2 != 0) {
            cell.contentView.backgroundColor = #colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)
            cell.airportIdentifier.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }else {
            cell.contentView.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
            cell.airportIdentifier.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let airport = airportsArray?[indexPath.row] {
            getData(for: airport)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    //TODO: Ideally our VCs would not be calling our NetworkManager directly, should be handled on a service layer object that would handle that operation on their behalf.
    func getData(for airport: String) {
        NetworkManager.request(urlString: StringConstants.airportURL.replacingOccurrences(of: "{airportCode}", with: airport)) { [weak self]
            (result: Result<AirportModel, Error>) in
            
            guard let weakSelf = self else { return }
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    //If the airport is already in our array, we don't need to add it again.
                    if (!(weakSelf.airportsArray?.contains(airport) ?? true)) {
                        weakSelf.airportsArray?.append(airport.uppercased())
                        weakSelf.userDefaults.set(weakSelf.airportsArray, forKey: "myAirports")
                    }
                    
                    weakSelf.tableView.refreshControl?.endRefreshing()
                    weakSelf.tableView.reloadData()
                    weakSelf.textField.text?.removeAll()
                    weakSelf.detailsViewController.airport = response
                    weakSelf.navigationController?.pushViewController(weakSelf.detailsViewController, animated: true)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    let cancelAction = UIAlertAction(title: StringConstants.cancelAction,
                                                     style: .cancel) { (action) in
                        weakSelf.textField.becomeFirstResponder()
                    }
                    
                    let alert = UIAlertController(title: StringConstants.invalidAirportId,
                                                  message: StringConstants.invalidAirportIdMessage,
                                                  preferredStyle: .alert)
                    alert.addAction(cancelAction)
                    
                    weakSelf.present(alert, animated: true) {
                    }
                }
                Log.error("getData Error")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            airportsArray?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let airportCode = textField.text {
            if (airportsArray?.contains(airportCode) ?? false) {
                Log.warning("Airport already added")
                let cancelAction = UIAlertAction(title: StringConstants.cancelAction,
                                                 style: .cancel) { (action) in
                    textField.becomeFirstResponder()
                }
                
                let alert = UIAlertController(title: StringConstants.airportAlreadyAdded,
                                              message: StringConstants.checkIdMessage,
                                              preferredStyle: .alert)
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true) {
                }
                
            }else {
                getData(for: airportCode)
                if let cellToSelect = airportsArray?.firstIndex(where: { $0 == airportCode }) {
                    let indexPath = IndexPath(row: cellToSelect, section: 0)
                    tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
                    tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
                }
            }
            
        }
        return true
    }
}
