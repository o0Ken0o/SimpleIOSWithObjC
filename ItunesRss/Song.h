//
//  Song.h
//  ItunesRss
//
//  Created by Kam Hei Siu on 1/1/2018.
//  Copyright © 2018 Kam Hei Siu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Song : NSObject

@property (strong, atomic) NSString *albumName;
@property (strong, atomic) NSString *songName;
@property (strong, atomic) NSString *albumImgUrl;

-(instancetype) init: (NSString *) albumName
            songName: (NSString *)  songName
         albumImgUrl: (NSString *) albumImgUrl;

@end
