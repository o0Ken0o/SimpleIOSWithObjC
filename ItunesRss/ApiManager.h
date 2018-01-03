//
//  ApiManager.h
//  ItunesRss
//
//  Created by Kam Hei Siu on 3/1/2018.
//  Copyright © 2018 Kam Hei Siu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Song.h"

@interface ApiManager : NSObject

+(ApiManager*) shared;

- (void) fetchSongsList:(NSString*)urlStr completionHandler:(void (^)(BOOL, NSArray<Song*>*, NSError*))completionHandler;

@end
