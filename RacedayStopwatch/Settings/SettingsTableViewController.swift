//
//  SettingsTableViewController.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 28/02/2019.
//  Copyright © 2019 Appbryggeriet. All rights reserved.
//

import UIKit
import StoreKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var measurementCell: UITableViewCell!
    @IBOutlet weak var metricImperialSegmentedControl: UISegmentedControl!
    @IBOutlet weak var measurementUnitsLabel: UILabel!
    @IBOutlet weak var disableSleepCell: UITableViewCell!
    @IBOutlet weak var disableSleepLabel: UILabel!
    @IBOutlet weak var disableSleepSwitch: UISwitch!
    
    @IBOutlet weak var reviewCell: UITableViewCell!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var schizohybridArtCell: UITableViewCell!
    @IBOutlet weak var schizohybridArtButton: UIButton!
    @IBOutlet weak var icons8Cell: UITableViewCell!
    @IBOutlet weak var icons8Button: UIButton!
    
    @IBOutlet weak var darkModeCell: UITableViewCell!
    @IBOutlet weak var darkModeLabel: UILabel!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    
    @IBOutlet weak var restorePurchasesCell: ProductCell!
    @IBOutlet weak var removeAllCell: ProductCell!
    @IBOutlet weak var removeAdsCell: ProductCell!
    @IBOutlet weak var removeLimitsCell: ProductCell!
    
    var iapProducts: [SKProduct] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewButton.setTitle(Constants.SETTINGS_REVIEW_BUTTON_TITLE, for: .normal)
        restorePurchasesCell.isHidden   = true
        removeAllCell.isHidden          = true
        removeAdsCell.isHidden          = true
        removeLimitsCell.isHidden       = true
        
        self.title                  = Constants.SETTINGS_TITLE
        measurementUnitsLabel.text  = Constants.SETTINGS_IMP_OR_METRIC_LABEL
        disableSleepLabel.text     = Constants.SETTINGS_DISABLE_SLEEP_LABEL
        darkModeLabel.text          = Constants.SETTINGS_DARK_MODE_LABEL
        metricImperialSegmentedControl.addTarget(self, action: #selector(changeMeasurementUnit), for: .valueChanged)
        metricImperialSegmentedControl.setTitle(Constants.SETTINGS_METRIC_LABEL, forSegmentAt: 0)
        metricImperialSegmentedControl.setTitle(Constants.SETTINGS_IMPERIAL_LABEL, forSegmentAt: 1)
        if Constants.defaults.bool(forKey: Constants.defaults_metric_key) {
            metricImperialSegmentedControl.selectedSegmentIndex = 0
        }else{
            metricImperialSegmentedControl.selectedSegmentIndex = 1
        }
        tableView.register(ProductCell.self, forCellReuseIdentifier: "Cell")
        NotificationCenter.default.addObserver(self, selector: #selector(SettingsTableViewController.handlePurchaseNotification(_:)),
                                               name: .IAPHelperPurchaseNotification,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getIAPData()
        darkModeSwitch.setOn(Constants.defaults.bool(forKey: Constants.defaults_dark_mode), animated: false)
        disableSleepSwitch.setOn(Constants.defaults.bool(forKey: Constants.defaults_disable_sleep), animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.popToRootViewController(animated: false)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupTheme()
    }
    func setupTheme(){
        tableView.backgroundColor   = Theme.activeTheme.backgroundColor
        tableView.separatorColor    = Theme.activeTheme.tintColor
        
        measurementCell.backgroundColor             = Theme.activeTheme.foregroundColor
        measurementUnitsLabel.textColor             = Theme.activeTheme.mainFontColor
        metricImperialSegmentedControl.tintColor    = Theme.activeTheme.tintColor
        disableSleepCell.backgroundColor            = Theme.activeTheme.foregroundColor
        disableSleepLabel.textColor                 = Theme.activeTheme.mainFontColor
        
        reviewCell.backgroundColor              = Theme.activeTheme.foregroundColor
        schizohybridArtCell.backgroundColor     = Theme.activeTheme.foregroundColor
        icons8Cell.backgroundColor              = Theme.activeTheme.foregroundColor
        reviewButton.setTitleColor(Theme.activeTheme.mainFontColor, for: .normal)
        schizohybridArtButton.setTitleColor(Theme.activeTheme.mainFontColor, for: .normal)
        icons8Button.setTitleColor(Theme.activeTheme.mainFontColor, for: .normal)
        darkModeCell.backgroundColor        = Theme.activeTheme.foregroundColor
        darkModeLabel.textColor             = Theme.activeTheme.mainFontColor
        darkModeSwitch.tintColor            = Theme.activeTheme.tintColor
        darkModeSwitch.onTintColor          = Theme.activeTheme.confirmColor
        darkModeSwitch.thumbTintColor       = Theme.activeTheme.mainFontColor
        disableSleepSwitch.tintColor        = Theme.activeTheme.tintColor
        disableSleepSwitch.onTintColor      = Theme.activeTheme.confirmColor
        disableSleepSwitch.thumbTintColor   = Theme.activeTheme.mainFontColor
        
        navigationController?.navigationBar.barTintColor                = Theme.activeTheme.barColor
        navigationController?.navigationBar.tintColor                   = Theme.activeTheme.tintColor
        navigationController?.navigationBar.titleTextAttributes         = [NSAttributedString.Key.foregroundColor:Theme.activeTheme.tintColor]
        navigationController?.navigationBar.largeTitleTextAttributes    = [NSAttributedString.Key.foregroundColor:Theme.activeTheme.tintColor]
        tabBarController?.tabBar.barTintColor                           = Theme.activeTheme.barColor
        tabBarController?.tabBar.tintColor                              = Theme.activeTheme.tintColor
    }
    
    @IBAction func createReview(_ sender: UIButton) {
        SKStoreReviewController.requestReview()
    }
    
    @IBAction func buttonLinkToWeb(_ sender: UIButton) {
        if sender == schizohybridArtButton{
            if let url = URL(string: "http://www.schizohybrid.com"){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }else{
            if let url = URL(string: "https://icons8.com"){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    func getIAPData() {
        iapProducts = []
        tableView.reloadData()
        Constants.store.requestProducts{ [weak self] success, products in
            guard let self = self else { return }
            if success {
                self.iapProducts = products!
                self.setupStoreCells()
                self.tableView.reloadData()
            }
        }
    }
    
    func setupStoreCells(){
        restorePurchasesCell.isHidden   = false
        removeAllCell.isHidden          = false
        removeAdsCell.isHidden          = false
        removeLimitsCell.isHidden       = false
        removeAllCell.product           = iapProducts[1]
        removeAllCell.buyButtonHandler  = { product in
            Constants.store.buyProduct(product)
        }
        removeAdsCell.product           = iapProducts[0]
        removeAdsCell.buyButtonHandler  = { product in
            Constants.store.buyProduct(product)
        }
        removeLimitsCell.product            = iapProducts[2]
        removeLimitsCell.buyButtonHandler   = { product in
            Constants.store.buyProduct(product)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0{
                Constants.store.restorePurchases()
            }
        }
    }
    
    @objc func handlePurchaseNotification(_ notification: Notification) {
        guard
            let productID = notification.object as? String,
            let _ = iapProducts.firstIndex(where: { product -> Bool in
                product.productIdentifier == productID
            })
            else { return }
        getIAPData()
    }
    
    @IBAction func setDarkMode(_ sender: UISwitch) {
        Theme.activeTheme = sender.isOn ? DarkTheme() : LightTheme()
        Constants.defaults.set(sender.isOn, forKey: Constants.defaults_dark_mode)
        tableView.reloadData()
        setupTheme()
    }
    
    @IBAction func disableSleep(_ sender: UISwitch) {
        Constants.defaults.set(sender.isOn, forKey: Constants.defaults_disable_sleep)
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
        return 4
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return Constants.SETTINGS_DEFAULT_HEADER
        case 1:
            return Constants.SETTINGS_IAP_HEADER
        case 2:
            return Constants.SETTINGS_THEME_HEADER
        case 3:
            return Constants.SETTINGS_ABOUT_HEADER
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.backgroundView?.backgroundColor? = Theme.activeTheme.backgroundColor
        header.textLabel?.textColor             = Theme.activeTheme.highlightFontColor
    }
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footer = view as! UITableViewHeaderFooterView
        footer.backgroundView?.backgroundColor? = Theme.activeTheme.backgroundColor
        footer.textLabel?.textColor             = Theme.activeTheme.highlightFontColor
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        //Only one section should have a footer, the last one
        if section == 3 {
            guard let dictionary = Bundle.main.infoDictionary else {
                return "© 2019 Appbryggeriet - 🇳🇴"
            }
            let version = dictionary[Constants.Appversion] as! String
            return "🇳🇴 - v\(version) - © 2019 Appbryggeriet - 🇳🇴"
        }
        return ""
    }
}
