//
//  SetupPricesTableViewController.swift
//  ComprasUSA
//
//  Created by Ronaldo Garcia on 15/12/18.
//  Copyright © 2018 Carol Renan Ronaldo. All rights reserved.
//

import UIKit

class SetupPricesTableViewController: UITableViewController {

    @IBOutlet weak var tfDollar: UITextField!
    @IBOutlet weak var tfIOF: UITextField!
    
    var statesManager = StatesManager.share
    let config = ComprasUSASetup.shared
    
    @IBAction func addState(_ sender: UIBarButtonItem) {
        showAlert(with: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Setup"), object: nil, queue: nil) { (notificatioin) in
            self.formatDollarInfo()
        }
        loadStates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        formatDollarInfo()
    }
    
    func formatDollarInfo() {
        tfDollar.text = String(format: "%.2f", config.quotationDollar)
        tfIOF.text = String(format: "%.2f", config.iof)
    }
    
    func loadStates() {
        statesManager.loadStates(with: context)
        tableView.reloadData()
    }

    func showAlert(with state: State?) {
        
        let title = state == nil ? "Adicionar" : "Editar"
        let alert = UIAlertController(title: title + " estado", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Nome do estado"
            if let name = state?.name {
                textField.text = name
            }
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Imposto"
            if let tax = state?.tax {
                textField.text = tax
            }
        }
        
        alert.addAction(UIAlertAction(title: title, style: .default, handler: { (action) in
            
            let state = state ?? State(context: self.context)
            state.name = alert.textFields?.first?.text
            state.tax = alert.textFields?.last?.text
            
            do {
                try self.context.save()
                self.loadStates()
            } catch {
                print(error.localizedDescription)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statesManager.states.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let state = statesManager.states[indexPath.row]
        showAlert(with: state)
        tableView.deselectRow(at: indexPath, animated: false)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StateTableViewCell

        let state = statesManager.states[indexPath.row]
        cell.prepare(with: state)
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            statesManager.deleteState(index: indexPath.row, context: context)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    @IBAction func updateDollar(_ sender: UITextField) {
        if let dollar = Double(tfDollar.text!) {
            config.quotationDollar = dollar
        }
    }
    
    @IBAction func updateIOF(_ sender: UITextField) {
        if let iof = Double(tfIOF.text!) {
            config.iof = iof
        }
    }
}
