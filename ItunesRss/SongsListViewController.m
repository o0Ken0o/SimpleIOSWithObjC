//
//  SongsListViewController.m
//  ItunesRss
//
//  Created by Kam Hei Siu on 1/1/2018.
//  Copyright © 2018 Kam Hei Siu. All rights reserved.
//

#import "SongsListViewController.h"
#import "SongDetailsViewController.h"
#import "SongCell.h"
#import "Song.h"
#import "AFNetworking.h"

@interface SongsListViewController () {
    NSString* _Nonnull  urlStr;
    NSMutableArray<Song*>* _Nonnull songsList;
    Song* _Nullable selectedSong;
}

@end

@implementation SongsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.songsTableView setDelegate:self];
    [self.songsTableView setDataSource:self];
    
    [self initVariables];
//    [self fetchSongsList];
    [self fetchSongsListWithLibraries];
}

- (void) initVariables {
    songsList = [NSMutableArray new];
    urlStr = @"https://rss.itunes.apple.com/api/v1/hk/apple-music/hot-tracks/all/10/explicit.json";
}

- (void) fetchSongsList {
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
            NSArray *songsList = [[jsonDict valueForKey: @"feed"] valueForKey: @"results"];
            
            __weak SongsListViewController *weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong SongsListViewController *strongSelf = weakSelf;
                for (NSDictionary *songDict in songsList) {

                    Song *song = [[Song alloc] init:[songDict valueForKey: @"collectionName"]
                                    songName:[songDict valueForKey: @"name"]
                                    albumImgUrl:[songDict valueForKey: @"artworkUrl100"]
                                    artistName:[songDict valueForKey: @"artistName"]
                                    intellectualRight:[songDict valueForKey: @"copyright"]
                                ];
                    [strongSelf->songsList addObject: song];
                }
                [strongSelf.songsTableView reloadData];
            });
            
        } else {
            NSLog(@"%@", e);
        }
    }] resume];
}

-(void)fetchSongsListWithLibraries {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    
    NSURL *url = [[NSURL alloc] initWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            long statusCode = [httpResponse statusCode];
            if (statusCode / 100 == 2) {
                // statusCode is 2xx
                if ([responseObject isKindOfClass: [NSDictionary class]]) {
                    NSDictionary *jsonDict = responseObject;
                    NSArray *songsList = [[jsonDict valueForKey: @"feed"] valueForKey: @"results"];
                    
                    __weak SongsListViewController *weakSelf = self;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        __strong SongsListViewController *strongSelf = weakSelf;
                        for (NSDictionary *songDict in songsList) {
                            
                            Song *song = [[Song alloc] init:[songDict valueForKey: @"collectionName"]
                                                   songName:[songDict valueForKey: @"name"]
                                                albumImgUrl:[songDict valueForKey: @"artworkUrl100"]
                                                 artistName:[songDict valueForKey: @"artistName"]
                                          intellectualRight:[songDict valueForKey: @"copyright"]
                                          ];
                            [strongSelf->songsList addObject: song];
                        }
                        [strongSelf.songsTableView reloadData];
                    });
                } else {
                    
                }
            } else {
                // handle errors like 401
            }
        }
    }];
    
    [dataTask resume];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString: @"SongDetailsViewController"]) {
        SongDetailsViewController *destination = segue.destinationViewController;
        [destination setSong: selectedSong];
    }
}

# pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [songsList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Song* song = [songsList objectAtIndex: indexPath.row];
    SongCell* cell = [tableView dequeueReusableCellWithIdentifier: SongCell.identifier];
    
    if (cell) {
        [cell configureCellWith: song.albumName songName: song.songName albumUrl: song.albumImgUrl];
        return cell;
    }
    
    return [[SongCell alloc] init];
}

# pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated:false];
    selectedSong = [songsList objectAtIndex: indexPath.row];
    [self performSegueWithIdentifier:@"SongDetailsViewController" sender: self];
}

@end
