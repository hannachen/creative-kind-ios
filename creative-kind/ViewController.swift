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
    var square: Square?
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // IBActions
    
    @IBAction func clickSaveButton(_ sender: Any) {
        guard let square = self.square else {
            return
        }
        let data = square.getData()
        print("SAVED DATA: \(data)")
        
        // Convert data to a json object?
    }
    
    @IBAction func clickSubmitButton(_ sender: Any) {
    }
    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colorPaletteColumns
    }
    
    // TODO: Use footer for the "apply colors"/"paint" button
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
        guard let color = cell.color,
              let square = self.square else {
            return
        }
        collectionView.reloadData()
        square.applyColor(color)
    }
    
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalColors: CGFloat = CGFloat(self.colorPaletteColumns)
        return CGSize(width: self.colorPaletteView.frame.width/totalColors, height: self.colorPaletteView.frame.height)
    }
    
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.colorPaletteOffset = scrollView.contentOffset
    }
    
    // TODO: Connect this action to something (change color palette set?)
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Disable overscroll on the right side
        let offset: CGPoint = scrollView.contentOffset
        if (offset.x > self.colorPaletteOffset.x) {
            // scrolling to the right, reset offset
            scrollView.setContentOffset(.zero, animated: false)
            return
        }
        
        // Handle overscroll on the left side
        scrollView.backgroundColor = offset.x < maxOverscroll ? UIColor.darkGray : UIColor.lightGray
    }
    
    
    // MARK: SquareViewDelegate
    
    func squareDidLoad(shapes: [ColorShapeLayer]) {
        self.square = Square(shapes: shapes)
    }
    
    func selectShape(shape: ColorShapeLayer) {
        guard let square = self.square else {
            return // Don't do anything if square isn't initialized
        }
        
        // Select/Deselect shapes
        if shape.selectToggle() {
            square.addShape(shape)
        } else {
            square.removeShape(shape)
        }
        
        // Print mode
        if self.paintMode {
            if let color = self.colors[self.selectedColorSwatch] as UIColor? {
                square.applyColor(color)
            }
            square.clearSelected()
        }
    }
    
    func selectDidChange() {
        guard let square = self.square else {
            return
        }
        selectedLabel.text = "\(square.selectedShapes.count) shapes selected"
    }
    
    
    // MARK: ColorPaletteViewCellDelegate
    
    func singleTapApplyColorButton() {
        self.clearSquare()
    }
    
    func tripleTapApplyColorButton() {
        if !self.togglePaintMode() {
            self.selectedColorSwatch = 0
        }
        self.clearSquare()
        self.colorPaletteView.reloadData()
    }
    

    private func clearSquare() {
        guard let square = self.square else {
            return
        }
        square.clearSelected()
        self.selectDidChange() // TODO: find a place to put this?
    }

    private func togglePaintMode() -> Bool {
        self.paintMode = !self.paintMode
        return self.paintMode
    }
}

