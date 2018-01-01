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
    [self fetchSongsList];
}

- (void) initVariables {
    songsList = [NSMutableArray new];
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
