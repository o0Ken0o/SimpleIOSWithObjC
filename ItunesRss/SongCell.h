//
//  SongCell.h
//  ItunesRss
//
//  Created by Kam Hei Siu on 1/1/2018.
//  Copyright © 2018 Kam Hei Siu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *songImageView;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;
@property (class, nonatomic, readonly) NSString* identifier;

-(void)configureCellWith: (NSString*) albumName
                songName: (NSString*) songName
                albumUrl: (NSString*) albumUrl;

+(NSString*)identifier;

@end
