//
//  SettingsTableViewController.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 28/02/2019.
//  Copyright © 2019 Appbryggeriet. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var metricImperialSegmentedControl: UISegmentedControl!
    @IBOutlet weak var measurementUnitsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title                  = Constants.SETTINGS_TITLE
        measurementUnitsLabel.text  = Constants.SETTINGS_IMP_OR_METRIC_LABEL
        metricImperialSegmentedControl.addTarget(self, action: #selector(changeMeasurementUnit), for: .valueChanged)
        metricImperialSegmentedControl.setTitle(Constants.SETTINGS_METRIC_LABEL, forSegmentAt: 0)
        metricImperialSegmentedControl.setTitle(Constants.SETTINGS_IMPERIAL_LABEL, forSegmentAt: 1)
        if Constants.defaults.bool(forKey: Constants.defaults_metric_key) {
            metricImperialSegmentedControl.selectedSegmentIndex = 0
        }else{
            metricImperialSegmentedControl.selectedSegmentIndex = 1
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.popToRootViewController(animated: false)
    }

    @objc func changeMeasurementUnit(){
        switch metricImperialSegmentedControl.selectedSegmentIndex {
        case 0:
            Constants.defaults.set(true, forKey: Constants.defaults_metric_key)
        case 1:
            Constants.defaults.set(false, forKey: Constants.defaults_metric_key)
        default:
            print("Default metric or imperial switch")
        }
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return Constants.SETTINGS_DEFAULT_HEADER
        case 1:
            return Constants.SETTINGS_IAP_HEADER
        case 2:
            return Constants.SETTINGS_THEME_HEADER
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        //Only one section should have a footer, the last one
        if section == 2 {
            guard let dictionary = Bundle.main.infoDictionary else {
                return "© 2019 Appbryggeriet - 🇳🇴"
            }
            let version = dictionary[Constants.Appversion] as! String
            return "🇳🇴 - v\(version) - © 2019 Appbryggeriet - 🇳🇴"
        }
        return ""
    }
}
