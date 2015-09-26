//
//  UserTableViewCell.m
//  GZGitSearch
//
//  Created by Guilherme Zanellato on 9/26/15.
//  Copyright © 2015 Guilherme Zanellato. All rights reserved.
//

#import "UserTableViewCell.h"

@implementation UserTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    /*
     * Transformando a imagem no formato redondo
     * Mudando a cor do spinning (loading)
     */
    
    self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width / 2;
    self.imgUser.contentMode = UIViewContentModeScaleAspectFill;
    self.imgUser.clipsToBounds = YES;
    
    self.loading.circleLayer.lineWidth = 2.0;
    self.loading.circleLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    [self.loading beginRefreshing];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
