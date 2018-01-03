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
#import "ApiManager.h"
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
    [self fetchSongsList];
}

- (void) initVariables {
    songsList = [NSMutableArray new];
    urlStr = @"https://rss.itunes.apple.com/api/v1/hk/apple-music/hot-tracks/all/10/explicit.json";
}

-(void)fetchSongsList {
    __weak SongsListViewController *weakSelf = self;
    [[ApiManager shared] fetchSongsList:urlStr completionHandler:^(BOOL isSuccessful, NSArray<Song *> *songsListReturned, NSError *error) {
        __strong SongsListViewController *strongSelf = weakSelf;
        if (isSuccessful) {
            [songsList addObjectsFromArray:songsListReturned];
            [strongSelf.songsTableView reloadData];
        }
    }];
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
