//
//  MainTableViewController.swift
//  Stocks
//
//  Created by Yulia Moskaleva on 09/05/2018.
//  Copyright © 2018 Yulia Moskaleva. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    var currencies = [Currency]()
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let updateInterval = 15
    var timer = Timer()
    var isTimerRunning = false
    @IBOutlet weak var updateImage: UIBarButtonItem!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Cleaning empty cells for case short data
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
        isTimerRunning = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrencies()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currencies.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MainTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MainTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let currency = currencies[indexPath.row]
        print(currency)
        // Configure the cell...
        cell.nameLabel.text = currency.name
        cell.valueLabel.text = "\(currency.volume)"
        cell.amountLabel.text = String(format: "%.2f", currency.price.amount)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50.0
    }
    // MARK: action update Currency
    @IBAction func updateButtonTapped(_ sender: UIBarButtonItem) {
        getCurrencies()
    }
    

}

    // MARK: - get Currency Info
extension MainTableViewController{
    @objc func getCurrencies(){
        // Start spinner
        spinner.color = .black
        let barButton = UIBarButtonItem(customView: self.spinner)
        self.navigationItem.setLeftBarButton(barButton, animated: true)
        
        spinner.startAnimating()
        
        CurrencyService.sharedInstance.getCurrencyInfo() { success, error in
            // Stop spinner
            self.spinner.stopAnimating()
            
            if let success = success {
                self.currencies = success
                self.tableView.reloadData()
            }
            if let error = error {
                let validationAlert = UIAlertController(title: error, message: "", preferredStyle: .alert)
                validationAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(validationAlert, animated: true, completion: nil)
            }
            if !self.isTimerRunning {
                self.runTimer()
            }
        }
    }
}

    // MARK: - Timer logic
extension MainTableViewController{
    func runTimer() {
        isTimerRunning = true
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(updateInterval), target: self,   selector: (#selector(getCurrencies)), userInfo: nil, repeats: true)
    }
}
