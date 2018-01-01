//
//  SongsListViewController.h
//  ItunesRss
//
//  Created by Kam Hei Siu on 1/1/2018.
//  Copyright © 2018 Kam Hei Siu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongsListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *songsTableView;

@end
