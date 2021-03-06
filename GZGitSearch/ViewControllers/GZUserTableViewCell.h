//
//  GZUserTableViewCell.h
//  GZGitSearch
//
//  Created by Guilherme Zanellato on 9/27/15.
//  Copyright © 2015 Guilherme Zanellato. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <JTMaterialSpinner/JTMaterialSpinner.h>

@interface GZUserTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet JTMaterialSpinner *loading;
@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;

@end
