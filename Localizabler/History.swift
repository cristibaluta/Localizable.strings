//
//  LastProject.swift
//  Localizabler
//
//  Created by Baluta Cristian on 31/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Foundation

class History {
	
	let bookmarkKey = "bookmarkKey"
	
	func getLastProjectDir() -> URL? {
        
        if let bookmark = UserDefaults.standard.object(forKey: bookmarkKey) as? NSData as? Data {
            var stale = false
            if let url = try? URL(resolvingBookmarkData: bookmark, options: URL.BookmarkResolutionOptions.withSecurityScope,
                                  relativeTo: nil,
                                  bookmarkDataIsStale: &stale) {
                return url
            }
        }
		return nil
	}
	
	func setLastProjectDir (_ url: URL?) {
        
        guard let bookmark = try? url?.bookmarkData(options: URL.BookmarkCreationOptions.withSecurityScope,
                                                    includingResourceValuesForKeys: nil,
                                                    relativeTo: nil) else {
            return
        }
        UserDefaults.standard.set(bookmark, forKey: bookmarkKey)
        UserDefaults.standard.synchronize()
	}
}
