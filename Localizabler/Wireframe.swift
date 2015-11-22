//
//  Wireframe.swift
//  Localizabler
//
//  Created by Baluta Cristian on 14/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Cocoa

class Wireframe: NSObject {

	class func presentNoProjectsController (childController: NSViewController, overController parentController: NSViewController) {
		
		parentController.addChildViewController(childController)
		parentController.view.addSubview(childController.view)
		childController.view.removeAutoresizing()
		childController.view.constrainToSuperviewWidth()
		childController.view.constrainToSuperviewHeight()
	}
	
	class func removeNoProjectsController (controller: NSViewController?) {
		
		if let c = controller {
			c.view.removeFromSuperview()
			c.removeFromParentViewController()
		}
	}
}
