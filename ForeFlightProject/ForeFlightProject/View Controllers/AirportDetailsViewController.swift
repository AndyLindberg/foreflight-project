//
//  AirportDetailsViewController.swift
//  ForeFlightProject
//
//  Created by Andy Lindberg on 5/13/22.
//

import Foundation
import UIKit

class AirportDetailsViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var optionsSegmentControl: UISegmentedControl!
    
    internal var airport: AirportModel?
    internal var detailsCategoryArray:[String]?
    internal var refreshTimer: Timer?
    
    private var viewModel: DetailViewModel?
    private var forecastViewModel: ForecastViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        
        
        optionsSegmentControl.addTarget(self, action: #selector(self.segmentedValueChanged(_:)), for: .valueChanged)
        optionsSegmentControl.selectedSegmentIndex = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateDetails(for: airport)
        updateForecast(for: airport)
        
        //Refresh timer is set to 5 minutes to ensure user has the latest data
        attachRefreshTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        detachRefreshTimer()
    }
    
    func updateDetails(for airport: AirportModel?) {
        guard let airportData = airport else {
            return
        }
        let viewModel: DetailViewModel = .init(model: (airportData.report?.conditions)!)
        self.viewModel = viewModel
        self.tableView.reloadData()
    }
    
    func updateForecast(for airport: AirportModel?) {
        guard let airportData = airport else {
            return
        }
        let forecastViewModel: ForecastViewModel = .init(model: (airportData.report?.forecast)!)
        self.forecastViewModel = forecastViewModel
        self.tableView.reloadData()
    }
    
    internal func attachRefreshTimer() {
        refreshTimer = Timer.scheduledTimer(timeInterval: 300.0, target: self, selector: #selector(refreshContent), userInfo: nil, repeats: true)
    }
    
    internal func detachRefreshTimer () {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
    
    @objc func refreshContent () {
        if let airportToRefresh = airport?.report?.conditions?.ident {
            NetworkManager.request(urlString: StringConstants.airportURL.replacingOccurrences(of: "{airportCode}", with: airportToRefresh)) { [weak self]
                (result: Result<AirportModel, Error>) in
                
                guard let weakSelf = self else { return }
                
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        weakSelf.airport = response
                        weakSelf.updateDetails(for: response)
                        weakSelf.updateForecast(for: response)
                        
                    }
                    // The user may not know that things are being updated on a timer, I don't believe we would want to present an error via UIAlert if the API call fails for some reason.
                case .failure(let error):
                    Log.error("Timer refresh failure")
                }
            }
        }
    }
    
    @objc func segmentedValueChanged(_ sender:UISegmentedControl!)
    {
        DispatchQueue.main.async {
            if (sender.selectedSegmentIndex == 0) {
                self.updateDetails(for: self.airport)
            }else {
                self.updateForecast(for: self.airport)
            }
        }
    }
}

extension AirportDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if optionsSegmentControl.selectedSegmentIndex == 0 {
            guard let viewModel: DetailViewModel = self.viewModel else {
                return 0
            }
            let sectionModel: DetailViewModel.SectionModel = viewModel.sections[section]
            return sectionModel.cells.count
        }else {
            guard let viewModel: ForecastViewModel = self.forecastViewModel else {
                return 0
            }
            let sectionModel: ForecastViewModel.ForecastSectionModel = viewModel.sections[section]
            return sectionModel.cells.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if optionsSegmentControl.selectedSegmentIndex == 0 {
            guard let viewModel: DetailViewModel = self.viewModel else {
                return UITableViewCell()
            }
            let sectionModel: DetailViewModel.SectionModel = viewModel.sections[indexPath.section]
            let cellModel: DetailViewModel.CellModel = sectionModel.cells[indexPath.row]
            
            switch cellModel {
            case .text(let title, let value):
                // Instantiate your custom UITableViewCell
                let cell: UITableViewCell = UITableViewCell(style: .subtitle, reuseIdentifier: "detailsCell")
                cell.textLabel?.text = title
                cell.detailTextLabel?.text = value
                return cell
            case .map(let latitude, let longitude):
                // Given more time I would like to create a UITableViewCell with a map centered on the coordinates
                return UITableViewCell()
            }
        }else {
            guard let forecastViewModel: ForecastViewModel = self.forecastViewModel else {
                return UITableViewCell()
            }
            let sectionModel: ForecastViewModel.ForecastSectionModel = forecastViewModel.sections[indexPath.section]
            let cellModel: ForecastViewModel.CellModel = sectionModel.cells[indexPath.row]
            
            switch cellModel {
            case .text(let title, let value):
                // Instantiate your custom UITableViewCell
                let cell: UITableViewCell = UITableViewCell(style: .subtitle, reuseIdentifier: "detailsCell")
                cell.textLabel?.text = title
                cell.detailTextLabel?.text = value
                return cell
            case .map(let latitude, let longitude):
                // Given more time I would like to create a UITableViewCell with a map centered on the coordinates
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if optionsSegmentControl.selectedSegmentIndex == 0 {
            guard let viewModel: DetailViewModel = self.viewModel else {
                return nil
            }
            let sectionModel: DetailViewModel.SectionModel = viewModel.sections[section]
            return sectionModel.title
        }else {
            guard let forecastViewModel: ForecastViewModel = self.forecastViewModel else {
                return nil
            }
            let sectionModel: ForecastViewModel.ForecastSectionModel = forecastViewModel.sections[section]
            return sectionModel.title
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if optionsSegmentControl.selectedSegmentIndex == 0 {
            guard let viewModel: DetailViewModel = self.viewModel else {
                return 0
            }
            return viewModel.sections.count
        }else {
            guard let forecastViewModel: ForecastViewModel = self.forecastViewModel else {
                return 0
            }
            return forecastViewModel.sections.count
        }
    }
    
}
