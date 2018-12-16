//
//  AddEditProductViewController.swift
//  ComprasUSA
//
//  Created by Ronaldo Garcia on 15/12/18.
//  Copyright © 2018 Carol Renan Ronaldo. All rights reserved.
//

import UIKit

class AddEditProductViewController: UIViewController {

    @IBOutlet weak var tfProduct: UITextField!
    @IBOutlet weak var ivCover: UIImageView!
    @IBOutlet weak var tfState: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var swCreditcard: UISwitch!
    @IBOutlet weak var btCover: UIButton!
    @IBOutlet weak var btSaveProduct: UIButton!
    
    var product: Product!
    var statesManager = StatesManager.share
    let config = ComprasUSASetup.shared
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .white
        return pickerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfPrice.keyboardType = UIKeyboardType.numbersAndPunctuation
        
        if product != nil {
            tfProduct.text = product.name
            tfPrice.text = product.price
            swCreditcard.isOn = product.creditcard
            
            if let state = product.state, let index = statesManager.states.index(of: state) {
                tfState.text = state.name
                pickerView.selectRow(index, inComponent: 0, animated: false)
            }
            ivCover.image = product.cover as? UIImage
        }
        prepareStateFiedls()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "settingSegue" {
            segue.destination as! SetupPricesTableViewController
        }
    }
    
    func checkRequiredFields() -> Bool {
        var result: Bool = true
        let productName = tfProduct.text
        let state = tfState.text
        let price = tfPrice.text
        
        if ((productName?.isEmpty)! || (state?.isEmpty)! || (price?.isEmpty)!){
            let alert = UIAlertController(title: "Atenção", message: "Por favor, é necessário preencher o nome do produto, estado e o preço aonde foi realizado a compra.", preferredStyle: .alert)
            let btOK = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(btOK)
            present(alert, animated: true, completion: nil)
            result = false
        }
        return result
    }
    
    func prepareStateFiedls() {
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let btFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [btCancel, btFlexibleSpace, btDone]
        tfState.inputView = pickerView
        tfState.inputAccessoryView = toolbar
    }
    
    @objc func cancel() {
        tfState.resignFirstResponder()
    }
    
    @objc func done() {
        
        tfState.text = statesManager.states[pickerView.selectedRow(inComponent: 0)].name
        cancel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statesManager.loadStates(with: context)
    }
    
    @IBAction func saveProduct(_ sender: UIButton) {
        
        if checkRequiredFields() {
            if product == nil {
                product = Product(context: context)
            }
            
            product.name = tfProduct.text
            let priceUS: Double = 0
            var priceRS: Double = 0
            let dollar = config.quotationDollar
            let iof = config.iof
            
            if !tfState.text!.isEmpty {
                let state = statesManager.states[pickerView.selectedRow(inComponent: 0)]
                product.state = state
                if let tax = Double(state.tax!), let price = Double(tfPrice.text!) {
                    let priceUSRS = price + (tax * price)
                    if swCreditcard.isOn {
                        priceRS = priceUSRS * dollar
                        priceRS = priceRS * iof + priceRS
                    } else {
                        priceRS = priceUS * dollar
                    }
                }
            }
            product.price = tfPrice.text
            product.priceUS = tfPrice.text
            product.priceRS = String(priceRS)
            product.cover = ivCover.image
            saveProduct()
            navigationController?.popViewController(animated: true)
        }
        
        
        
    }
    
    func saveProduct() {
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func addCover(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Selecione o produto", message: "De onde você deseja buscar a foto?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default, handler: { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            })
            alert.addAction(cameraAction)
        }
        let libraryAction = UIAlertAction(title: "Bibliote de fotos", style: .default, handler: { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        })
        alert.addAction(libraryAction)
        let photosAction = UIAlertAction(title: "Álbum de fotos", style: .default, handler: { (action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        })
        alert.addAction(photosAction)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func selectPicture(sourceType: UIImagePickerControllerSourceType) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func setCreditCard(_ sender: UISwitch) {
        if sender.isOn == true {
            product.creditcard = true
        } else {
            product.creditcard = false
        }
        saveProduct()
    }
    
}

extension AddEditProductViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return statesManager.states.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let state = statesManager.states[row]
        return state.name
    }
}

extension AddEditProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        ivCover.image = image
        btCover.setTitle(nil, for: .normal)
        dismiss(animated: true, completion: nil)
    }
    
}
