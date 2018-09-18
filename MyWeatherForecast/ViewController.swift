//
//  ViewController.swift
//  MyWeatherForecast
//
//  Created by vasadulin on 14.09.2018.
//  Copyright © 2018 Asadulinz Software. All rights reserved.
//

import UIKit
import SwiftChart

class ViewController: UIViewController {
    @IBOutlet private weak var weatherCollectionView: UICollectionView!
    @IBOutlet private weak var limitTextField: UITextField!
    @IBOutlet private weak var dayDescriptionLabel: UILabel!
    @IBOutlet private weak var temperatureChart: Chart!

    
    let limitPicker = UIPickerView()
    let weatherController = WeatherController()
    var chartWrapper: ChartWrapper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //keyboard - UIPickerView
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        
        limitPicker.dataSource = self
        limitPicker.delegate = self
        limitTextField.inputView = limitPicker
        limitTextField.inputAccessoryView = toolBar
        
        //CollectionView set dadasource and delegate
        weatherCollectionView.dataSource = weatherController.forecastDataSource
        weatherCollectionView.delegate = self
        
        //- Chart -
        chartWrapper = ChartWrapper(chart: self.temperatureChart!,
                                    dataSource: weatherController.forecastDataSource,
                                    delegate: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showForecast()
    }
    
    func showForecast() {
        weatherCollectionView.reloadData()
        chartWrapper.reloadData()
    }
    
    func showDetailForecast(index: Int) {
        dayDescriptionLabel.text = weatherController.textDescriptionWeatherItem(index: index)
    }
    
    //Hide keyboard in pickerView
    @objc func doneClick() {
        limitTextField.resignFirstResponder()
    }
    
    //MARK: - Actions
    @IBAction func updateForecastAction(_ sender: Any) {
        let limit = UInt(limitTextField.text ?? "5") ?? 5
        weatherController.sendRequestForecast(limit: limit) { [weak self] in
            self?.showForecast()
        }
    }
    
    
}

// MARK: UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showDetailForecast(index: indexPath.row)
    }
}


// MARK: UIPickerView Delegation
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 38 //max cnt. 
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row+1)"
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        limitTextField.text = "\(row+1)"
    }
}

// MARK: - ChartWrapperDelegate
extension ViewController: ChartWrapperDelegate {
    
    func chartTapAction(_ chart: ChartWrapper, indexOfPoint: Int) {
        showDetailForecast(index: indexOfPoint)
        
        //scroll collectionView
        let indexPath = IndexPath(item: indexOfPoint, section: 0)
        weatherCollectionView.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: true)
    }
}

