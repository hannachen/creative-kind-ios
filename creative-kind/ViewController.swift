//
//  ViewController.swift
//  creative-kind
//
//  Created by Hanna Chen on 3/14/17.
//  Copyright © 2017 Rethink Canada. All rights reserved.
//

import UIKit

private let maxOverscroll: CGFloat = -50

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, ColorPaletteViewCellDelegate, SquareViewDelegate {
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
    
    
    // MARK: Overrides
    
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
            
            // Reset selection
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
            
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
        
        cell.painting = self.paintMode
        cell.isSelected = self.selectedColorSwatch == indexPath.row
        
        // Set cell button
        cell.setupCellWith(color)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        // Last cell: ignore
        if indexPath.row + 1 == self.colorPaletteColumns {
            return false
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedColorSwatch = indexPath.row
        
        let cell: ColorSwatchViewCell = collectionView.cellForItem(at: indexPath) as! ColorSwatchViewCell
        guard let color = cell.color else {
            return
        }
        collectionView.reloadData()
        self.squareView.applyColor(color)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalColors: CGFloat = CGFloat(self.colorPaletteColumns)
        return CGSize(width: self.colorPaletteView.frame.width/totalColors, height: self.colorPaletteView.frame.height)
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
        if !self.paintMode {
            return
        }
        if let color = self.colors[self.selectedColorSwatch] as UIColor? {
            self.squareView.applyColor(color)
        }
        self.squareView.clearSelected()
    }
    
    func selectDidChange() {
        selectedLabel.text = "\(self.squareView.selectedShapes.count) shapes selected"
    }
    
    
    // MARK: ColorPaletteViewCellDelegate
    
    func singleTapApplyColorButton() {
        self.squareView.clearSelected()
    }
    
    func tripleTapApplyColorButton() {
        if !self.togglePaintMode() {
            self.selectedColorSwatch = 0
        }
        self.squareView.clearSelected()
        self.colorPaletteView.reloadData()
    }
    
    
    private func togglePaintMode() -> Bool {
        self.paintMode = !self.paintMode
        return self.paintMode
    }
    
    private func layoutSaveButtons() {
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

