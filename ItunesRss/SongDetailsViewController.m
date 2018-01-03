//
//  SongDetailsViewController.m
//  ItunesRss
//
//  Created by Kam Hei Siu on 1/1/2018.
//  Copyright © 2018 Kam Hei Siu. All rights reserved.
//

#import "SongDetailsViewController.h"
#import "AFNetworking.h"

@interface SongDetailsViewController () {
    Song* currentSong;
}

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;

@end

@implementation SongDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle: currentSong.albumName];
    
    [self.albumImageView setHidden: true];
//    [self fetchThumbnail: currentSong.albumImgUrl];
    [self fetchThumbnailWithLibraries:currentSong.albumImgUrl];
    [self setupSummary];
}

-(void)setSong: (Song*) song {
    currentSong = song;
}

-(void)setupSummary {
    NSString* songNameKey = @"Song Name:";
    NSString* songNameValue = currentSong.songName;
    NSString* artistNameKey = @"Artist Name:";
    NSString* artistNameValue = currentSong.artistName;
    NSString* intellectualKey = @"CopyRight:";
    NSString* intellectualValue = currentSong.intellectualRight;
    NSString* finalRawString = @"%@ %@\n\n%@ %@\n\n%@ %@";
    NSString* finalString = [NSString stringWithFormat: finalRawString, songNameKey, songNameValue, artistNameKey, artistNameValue, intellectualKey, intellectualValue];
    NSMutableAttributedString* attrStr = [[NSMutableAttributedString alloc] initWithString: finalString];
    
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:15] range:[finalString rangeOfString: songNameKey]];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:15] range:[finalString rangeOfString: artistNameKey]];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:15] range:[finalString rangeOfString: intellectualKey]];
    
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17] range:[finalString rangeOfString: songNameValue]];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17] range:[finalString rangeOfString: artistNameValue]];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17] range:[finalString rangeOfString: intellectualValue]];
    
    [self.summaryLabel setAttributedText: attrStr];
}

-(void)fetchThumbnail: (NSString*) urlStr {
    NSURL *url = [[NSURL alloc] initWithString: urlStr];
    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(q, ^{
        NSData *imageData = [[NSData alloc] initWithContentsOfURL: url];
        if (imageData) {
            __weak SongDetailsViewController *weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong SongDetailsViewController *strongSelf = weakSelf;
                strongSelf.albumImageView.image = [UIImage imageWithData: imageData];
                [strongSelf.albumImageView setHidden: false];
            });
        }
    });
}

-(void)fetchThumbnailWithLibraries:(NSString*)urlStr {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [[NSURL alloc] initWithString: urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        NSData *imageData = [[NSData alloc] initWithContentsOfURL: filePath];
        if (imageData) {
            __weak SongDetailsViewController *weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong SongDetailsViewController *strongSelf = weakSelf;
                strongSelf.albumImageView.image = [UIImage imageWithData: imageData];
                [strongSelf.albumImageView setHidden: false];
            });
        }
    }];
    [downloadTask resume];
}

- (IBAction)backTapped:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
