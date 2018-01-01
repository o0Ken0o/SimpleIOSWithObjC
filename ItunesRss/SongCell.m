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
}

+(NSString*)identifier {
    return _identifier;
}

@end
