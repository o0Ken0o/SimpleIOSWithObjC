//
//  ApiManager.m
//  ItunesRss
//
//  Created by Kam Hei Siu on 3/1/2018.
//  Copyright © 2018 Kam Hei Siu. All rights reserved.
//

#import "ApiManager.h"
#import "AFNetworking.h"
#import "Song.h"

@interface ApiManager() {
    NSURLSessionConfiguration* _Nonnull config;
}

@end

@implementation ApiManager

static ApiManager* _shared;

+(ApiManager*) shared {
    if (!_shared) {
        _shared = [ApiManager new];
        [_shared initVariables];
    }
    return _shared;
}

-(void)initVariables {
    config = [NSURLSessionConfiguration defaultSessionConfiguration];
}

- (void) fetchSongsList:(NSString*)urlStr completionHandler:(void (^)(BOOL, NSArray<Song*>*, NSError*))completionHandler {
    [self fetchSongsListWithObjcApi:urlStr completionHandler:completionHandler];
}

-(void)fetchSongsListWithLibraries:(NSString*)urlStr completionHandler:(void (^)(BOOL, NSArray<Song*>*, NSError*))completionHandler {
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    
    NSURL *url = [[NSURL alloc] initWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(true, nil, error);
            });
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            long statusCode = [httpResponse statusCode];
            if (statusCode / 100 == 2) {
                // statusCode is 2xx
                if ([responseObject isKindOfClass: [NSDictionary class]]) {
                    NSDictionary *jsonDict = responseObject;
                    NSArray *songsListRaw = [[jsonDict valueForKey: @"feed"] valueForKey: @"results"];
                    NSMutableArray<Song*>* songsList = [NSMutableArray new];
                    
                    for (NSDictionary *songDict in songsListRaw) {
                        Song *song = [[Song alloc] init:[songDict valueForKey: @"collectionName"]
                                               songName:[songDict valueForKey: @"name"]
                                            albumImgUrl:[songDict valueForKey: @"artworkUrl100"]
                                             artistName:[songDict valueForKey: @"artistName"]
                                      intellectualRight:[songDict valueForKey: @"copyright"]
                                      ];
                        [songsList addObject: song];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionHandler(true, songsList, nil);
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionHandler(false, nil, nil);
                    });
                }
            } else {
                // handle errors like 401
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(true, nil, nil);
                });
            }
        }
    }];
    
    [dataTask resume];
}

- (void) fetchSongsListWithObjcApi:(NSString*)urlStr completionHandler:(void (^)(BOOL, NSArray<Song*>*, NSError*))completionHandler {
    NSURL *url = [[NSURL alloc] initWithString: urlStr];
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
    
    // explicitly set http method to GET
    [request setHTTPMethod:@"GET"];
    
    // explicitly set timeout interval to 5 seconds
    [request setTimeoutInterval:5];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *e = nil;
        NSMutableDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
        
        if (jsonDict) {
            NSArray *songsListRaw = [[jsonDict valueForKey: @"feed"] valueForKey: @"results"];
            NSMutableArray<Song*> *songsList = [NSMutableArray new];
            
            for (NSDictionary *songDict in songsListRaw) {
                
                Song *song = [[Song alloc] init:[songDict valueForKey: @"collectionName"]
                                       songName:[songDict valueForKey: @"name"]
                                    albumImgUrl:[songDict valueForKey: @"artworkUrl100"]
                                     artistName:[songDict valueForKey: @"artistName"]
                              intellectualRight:[songDict valueForKey: @"copyright"]
                              ];
                [songsList addObject: song];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(true, songsList, nil);
            });
            
        } else {
            NSLog(@"%@", e);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(false, nil, e);
            });
        }
    }] resume];
}

-(void)testingFetchData {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    
    NSString *URLString = @"http://example.com";
    NSDictionary *parameters = @{@"foo": @"bar", @"baz": @[@1, @2, @3]};
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:parameters error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
        }
    }];
    
    [dataTask resume];
}

@end
