//
//  ViewController.swift
//  creative-kind
//
//  Created by Hanna Chen on 3/14/17.
//  Copyright © 2017 Rethink Canada. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SquareViewDelegate {
    // Outlets
    @IBOutlet var squareContainerView: UIView!
    @IBOutlet var selectedLabel: UILabel!
    
    // Properties
    let gridColumns: Int = 20
    var squareView: SquareView = SquareView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.squareView)
        
        self.squareView.layer.borderColor = UIColor.black.cgColor
        self.squareView.layer.borderWidth = 1
        
        self.squareView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
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
    
    override func viewWillLayoutSubviews() {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectShapes(shapes: [ColorShapeLayer]) {
        selectedLabel.text = "\(shapes.count) shapes selected"
    }

}

