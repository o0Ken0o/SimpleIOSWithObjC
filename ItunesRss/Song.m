//
//  Song.m
//  ItunesRss
//
//  Created by Kam Hei Siu on 1/1/2018.
//  Copyright © 2018 Kam Hei Siu. All rights reserved.
//

#import "Song.h"

@implementation Song

-(instancetype) init:(NSString *)albumName songName:(NSString *)songName albumImgUrl:(NSString *)albumImgUrl {
    self = [super init];
    
    if (self) {
        _albumName = albumName;
        _songName = songName;
        _albumImgUrl = albumImgUrl;
    }
    
    return self;
}

@end
