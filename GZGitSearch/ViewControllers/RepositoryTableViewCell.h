//
//  RepositoryTableViewCell.h
//  GZGitSearch
//
//  Created by Guilherme Zanellato on 9/26/15.
//  Copyright © 2015 Guilherme Zanellato. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <JTMaterialSpinner/JTMaterialSpinner.h>

@interface RepositoryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgUserOwner;
@property (weak, nonatomic) IBOutlet UILabel *lblRepositoryName;
@property (weak, nonatomic) IBOutlet UILabel *lblRepositoryDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblViewsCount;
@property (weak, nonatomic) IBOutlet UILabel *lblLanguage;
@property (weak, nonatomic) IBOutlet JTMaterialSpinner *loading;

@end
