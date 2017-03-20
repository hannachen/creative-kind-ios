//
//  ViewController.swift
//  creative-kind
//
//  Created by Hanna Chen on 3/14/17.
//  Copyright © 2017 Rethink Canada. All rights reserved.
//

import UIKit

private let maxOverscroll: CGFloat = -50

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, ColorPaletteViewCellDelegate, SquareViewDelegate {
    // Outlets
    @IBOutlet var squareContainerView: UIView!
    @IBOutlet var colorPaletteView: UICollectionView!
    @IBOutlet var selectedLabel: UILabel!
    @IBOutlet var saveButtonsView: UIView!
    @IBOutlet var saveButtons: [UIButton]!
    @IBOutlet var squareView: SquareView!
    
    // Properties
    var colors: [UIColor] = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green, UIColor.blue]
    var colorPaletteColumns: Int = 6 // Number of colors plus the last button
    var colorPaletteOffset: CGPoint = .zero
    var selectedColorSwatch: Int = 0 // Always select the first color swatch by default
    var paintMode: Bool = false
    
    // MARK: Overrides
    
    // Lock orientation
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.squareView.delegate = self
        self.squareView.layoutSquareView(container: self.squareContainerView)
        
        self.colorPaletteView.dataSource = self
        self.colorPaletteView.delegate = self
        
//        self.layoutSaveButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalColors: CGFloat = CGFloat(self.colorPaletteColumns)
        return CGSize(width: self.colorPaletteView.frame.width/totalColors, height: self.colorPaletteView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colorPaletteColumns
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Last cell: deselect all/apply color
        if indexPath.row + 1 == self.colorPaletteColumns {
            
            // Configure the cell
            let cell: ApplyColorViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "apply", for: indexPath) as! ApplyColorViewCell
            
            cell.delegate = self
            cell.painting = self.paintMode
            
            // Set cell button
            cell.setupCell()
            return cell
        }
        
        // Color swatch cell
        let cell: ColorSwatchViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "swatch", for: indexPath) as! ColorSwatchViewCell
        
        // Get a color
        guard let color = self.colors[indexPath.row] as UIColor? else {
            return cell
        }
        
        cell.delegate = self
        cell.painting = self.paintMode
        cell.selectedSwatch = self.selectedColorSwatch == indexPath.row
        
        // Set cell button
        cell.setupCellWith(color)
        
        return cell
    }
    
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.colorPaletteOffset = scrollView.contentOffset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Disable overscroll on the right side
        let offset: CGPoint = scrollView.contentOffset
        
        if (offset.x > self.colorPaletteOffset.x) {
            // scrolling to the right, reset offset
            scrollView.setContentOffset(.zero, animated: false)
            return
        }
        
        // Handle overscroll on the left side
        if offset.x < maxOverscroll {
            scrollView.backgroundColor = UIColor.darkGray
        } else {
            scrollView.backgroundColor = UIColor.lightGray
        }
    }
    
    
    // MARK: SquareViewDelegate
    
    func selectShapes(shapes: [ColorShapeLayer]) {
        selectedLabel.text = "\(shapes.count) shapes selected"
        if !self.paintMode {
            return
        }
        if let color = self.colors[self.selectedColorSwatch] as UIColor? {
            self.squareView.applyColor(color)
        }
        self.squareView.clearSelected()
    }
    
    
    // MARK: ColorPaletteViewCellDelegate
    
    func clickColorButton(_ cell: ColorSwatchViewCell) {
        guard let indexPath = self.colorPaletteView.indexPath(for: cell),
              let color = self.colors[indexPath.row] as UIColor? else {
            return
        }
        self.selectedColorSwatch = indexPath.row
        self.squareView.applyColor(color)
        self.colorPaletteView.reloadData()
    }
    
    func singleTapApplyColorButton() {
        self.clearSelectedShapes()
    }
    
    func tripleTapApplyColorButton() {
        if self.togglePaintMode() {
            print("Paint mode")
        } else {
            print("Select mode")
            
            self.selectedColorSwatch = 0
        }
        self.clearSelectedShapes()
        self.colorPaletteView.reloadData()
    }
    
    
    func clearSelectedShapes() {
        self.squareView.clearSelected()
        selectedLabel.text = "\(self.squareView.selectedShapes.count) shapes selected"
    }
    
    func togglePaintMode() -> Bool {
        self.paintMode = !self.paintMode
        return self.paintMode
    }
    
    func layoutSaveButtons() {
        for button in self.saveButtons {
            // update save button constaints
            // Is there a better way to size buttons to be 50% of their container? Do I use Stack View? How do I use Stack View?
            let widthContraints =  NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.saveButtonsView.frame.width / 2)
            let heightContraints = NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.saveButtonsView.frame.height)
            NSLayoutConstraint.activate([heightContraints,widthContraints])
            button.setTitleColor(UIColor.lightGray, for: .disabled)
            button.isEnabled = false
        }
    }
}

