//
//  ViewController.swift
//  creative-kind
//
//  Created by Hanna Chen on 3/14/17.
//  Copyright © 2017 Rethink Canada. All rights reserved.
//

import UIKit

private let reuseIdentifier = "swatch"
private let maxOverscroll: CGFloat = -50

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, ColorPaletteViewCellDelegate, SquareViewDelegate {
    // Outlets
    @IBOutlet var squareContainerView: UIView!
    @IBOutlet var colorPaletteView: ColorPaletteCollectionView!
    @IBOutlet var selectedLabel: UILabel!
    @IBOutlet var saveButtonsView: UIView!
    @IBOutlet var saveButtons: [UIButton]!
    
    // Properties
    var squareView: SquareView = SquareView()
    var colors: [UIColor] = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green, UIColor.blue]
    var colorPaletteColumns: Int = 6 // Number of colors plus the last button
    var colorPaletteOffset: CGPoint = CGPoint.zero
    var selectedColor: UIColor?
    
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
        
        self.view.addSubview(self.squareView)
        
        self.squareView.layer.backgroundColor = UIColor.lightGray.cgColor
        self.squareView.layer.borderColor = UIColor.lightGray.cgColor
        self.squareView.layer.borderWidth = 1
        
        self.squareView.delegate = self
        self.initSquareView()
        
        self.colorPaletteView.dataSource = self
        self.colorPaletteView.delegate = self
        
//        self.layoutSaveButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillLayoutSubviews() {
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
            scrollView.setContentOffset(CGPoint.zero, animated: false)
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
        if self.colorPaletteView.paintMode {
            for shape in self.squareView.selectedShapes {
                if let color = self.colorPaletteView.paintModeColor {
                    shape.applyColor(color)
                }
                shape.deselect()
            }
            self.squareView.selectedShapes.removeAll()
            return
        }
        
        selectedLabel.text = "\(shapes.count) shapes selected"
    }
    
    
    // MARK: ColorPaletteViewCellDelegate
    
    func clickColorButton(_ color: UIColor) {
        self.selectedColor = color
        if self.colorPaletteView.paintMode {
            self.colorPaletteView.paintColor(color)
            return
        }
        for shape in self.squareView.selectedShapes {
            shape.applyColor(color)
        }
    }
    
    func singleTapApplyColorButton() {
        self.clearSelected()
    }
    
    func tripleTapApplyColorButton() {
        if self.colorPaletteView.togglePaintMode(),
           let color = self.selectedColor {
            self.colorPaletteView.paintColor(color)
        }
        self.selectedColor = nil
        self.clearSelected()
        print("Toggle paint mode")
    }
    
    
    
    func initSquareView() {
        // HELP: Where to put the code below so that it only runs once?
        if !self.squareView.initialized {
            
            self.squareView.frame = self.squareContainerView.frame
            self.squareView.bounds = self.squareContainerView.bounds
            
            self.squareView.generateSquareFromSvg()
            self.squareView.fitGrid(frame: self.squareContainerView.frame)
            self.squareView.setupTapHandler()
            self.squareView.initialized = true
        }
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
    
    func clearSelected() {
        for shape in self.squareView.selectedShapes {
            shape.deselect()
        }
        self.squareView.selectedShapes.removeAll()
        selectedLabel.text = "\(self.squareView.selectedShapes.count) shapes selected"
    }
}

