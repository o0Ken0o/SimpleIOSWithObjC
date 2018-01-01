//
//  SongsListViewController.m
//  ItunesRss
//
//  Created by Kam Hei Siu on 1/1/2018.
//  Copyright © 2018 Kam Hei Siu. All rights reserved.
//

#import "SongsListViewController.h"
#import "Song.h"

@interface SongsListViewController () {
    NSString* _Nonnull  urlStr;
    NSMutableArray<Song*>* _Nonnull songsList;
}

@end

@implementation SongsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariables];
    [self fetchSongsList];
}

- (void) initVariables {
    songsList = [[NSMutableArray alloc] init];
    urlStr = @"https://rss.itunes.apple.com/api/v1/hk/apple-music/hot-tracks/all/10/explicit.json";
}

- (void) fetchSongsList {
    NSURL *url = [[NSURL alloc] initWithString: urlStr];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *e = nil;
        NSMutableDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
        
        if (jsonDict) {
            NSArray *songsList = [[jsonDict valueForKey: @"feed"] valueForKey: @"results"];
            for (NSDictionary *songDict in songsList) {
                Song *song = [[Song alloc] init: [songDict valueForKey: @"collectionName"] songName:[songDict valueForKey: @"name"] albumImgUrl:[songDict valueForKey: @"artworkUrl100"]];
                [songsList arrayByAddingObject: song];
            }
            NSLog(@"%@", songsList);
        } else {
            NSLog(@"%@", e);
        }
    }] resume];
}

@end
