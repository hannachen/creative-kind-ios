//
//  ViewController.swift
//  creative-kind
//
//  Created by Hanna Chen on 3/14/17.
//  Copyright © 2017 Rethink Canada. All rights reserved.
//

import UIKit

private let maxOverscroll: CGFloat = -50

// TODO: "Save Draft" button to save color data to core data
// TODO: "Submit Design" button to send color data to API endpoint with network call
// TODO: Color set selection
class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, ColorPaletteViewCellDelegate, SquareViewDelegate {
    // Outlets
    @IBOutlet var squareContainerView: UIView!
    @IBOutlet var squareView: SquareView!
    @IBOutlet var colorPaletteView: UICollectionView!
    @IBOutlet var saveButtonsView: UIView!
    @IBOutlet var saveButtons: [UIButton]!
    @IBOutlet var selectedLabel: UILabel!
    
    // Properties
    var square: Square?
    var colors: [UIColor] = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green, UIColor.blue]
    var colorPaletteOffset: CGPoint = .zero
    var selectedColorSwatch: Int = 0 // Always select the first color swatch by default
    
    /* Toggles the current colouring mode to "painting" mode. Default is off. */
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
        
        self.squareContainerView.frame = self.view.bounds
        
        self.squareView.delegate = self
        self.squareView.layoutSquareView(container: self.squareContainerView.frame)
        
        self.colorPaletteView.dataSource = self
        self.colorPaletteView.delegate = self
        
        if let square = self.square {
            square.delegate = self
            square.palette = self.colors
            square.loadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // IBActions
    
    @IBAction func clickSaveButton(_ sender: Any) {
        guard let square = self.square else {
            return
        }
        square.save()
    }
    
    @IBAction func clickSubmitButton(_ sender: Any) {
    }
    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // Configure the footer
        let cell: ApplyColorViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "apply", for: indexPath) as! ApplyColorViewCell
        
        cell.delegate = self
        cell.painting = self.paintMode
        
        // TODO: Find out why the code below doesn't work inside the cell
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(singleTapApplyColorButton))
        let tripleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tripleTapApplyColorButton))
        
        singleTap.numberOfTapsRequired = 1
        tripleTap.numberOfTapsRequired = 3
        
        cell.applyColorButton.addGestureRecognizer(singleTap)
        cell.applyColorButton.addGestureRecognizer(tripleTap)
        
        // Set cell button
        cell.setupCell()
        
        // Reset selection
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
        
        return cell
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
        return self.colorPaletteCols()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,referenceSizeForFooterInSection section: Int) -> CGSize {
        return self.colorPaletteCols()
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset: CGPoint = scrollView.contentOffset
        
        // Clear square on overscroll
        if offset.x < maxOverscroll {
            self.square?.reset()
            return
        }
    }
    
    
    // MARK: SquareViewDelegate
    
    func squareDidLoad(shapes: [ColorShapeLayer]) {
        self.square = Square(shapes: shapes)
    }
    
    func squareWillSave(saveData: [String : Int]) {
    }
    
    // Square saved
    func squareDidSave(success: Bool, filePath: String) {
        if success {
            print("Square successfully saved to \(filePath).")
        } else {
            print("Failed to save square...")
        }
    }
    
    func selectShape(shape: ColorShapeLayer) {
        guard let square = self.square else {
            return // Don't do anything if square isn't initialized
        }
    
        // Select/Deselect shapes
        if shape.toggle() {
            square.select(shape)
        } else {
            square.deselect(shape)
        }
        
        // Print mode
        if self.paintMode {
            if let color = self.colors[self.selectedColorSwatch] as UIColor? {
                square.applyColor(color)
            }
            square.clearSelected()
        }
    }
    
    // Shape selection changed
    func selectDidChange() {
        guard let square = self.square,
              let selectedShapes = square.selectedShapes() else {
            return
        }
        selectedLabel.text = "\(selectedShapes.count) shapes selected"
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
    

    // Deselect all shapes
    private func clearSquare() {
        guard let square = self.square else {
            return
        }
        square.clearSelected()
    }

    private func togglePaintMode() -> Bool {
        self.paintMode = !self.paintMode
        return self.paintMode
    }
    
    private func colorPaletteCols() -> CGSize {
        let totalColors: CGFloat = CGFloat(self.colors.count + 1) // Number of colors plus the last button
        return CGSize(width: self.colorPaletteView.frame.width/totalColors, height: self.colorPaletteView.frame.height)
    }
}

