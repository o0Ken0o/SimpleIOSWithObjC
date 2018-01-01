//
//  SongCell.m
//  ItunesRss
//
//  Created by Kam Hei Siu on 1/1/2018.
//  Copyright © 2018 Kam Hei Siu. All rights reserved.
//

#import "SongCell.h"

@implementation SongCell

static NSString *_identifier = @"SongCell";

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureCellWith: (NSString*) albumName
                songName: (NSString*) songName
                albumUrl: (NSString*) albumUrl {
    self.albumLabel.text = albumName;
    self.songNameLabel.text = songName;
    [self.songImageView setHidden: true];
    [self fetchThumbnail: albumUrl];
}

+(NSString*)identifier {
    return _identifier;
}

-(void)fetchThumbnail: (NSString*) urlStr {
    NSURL *url = [[NSURL alloc] initWithString: urlStr];
    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(q, ^{
        NSData *imageData = [[NSData alloc] initWithContentsOfURL: url];
        if (imageData) {
            __weak SongCell *weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong SongCell *strongSelf = weakSelf;
                strongSelf.songImageView.image = [UIImage imageWithData: imageData];
                [strongSelf.songImageView setHidden: false];
            });
        }
    });
}

@end
