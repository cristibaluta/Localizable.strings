//
//  Wireframe.swift
//  Localizabler
//
//  Created by Baluta Cristian on 14/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Cocoa

class AppWireframe: NSObject {

	func presentNoProjectsController (_ childController: NSViewController, overController parentController: NSViewController) {
		
		parentController.addChildViewController(childController)
		parentController.view.addSubview(childController.view)
		childController.view.constrainToSuperview()
	}
	
	func removeNoProjectsController (_ controller: NSViewController?) {
		
		if let c = controller {
			c.view.removeFromSuperview()
			c.removeFromParentViewController()
		}
	}
}
