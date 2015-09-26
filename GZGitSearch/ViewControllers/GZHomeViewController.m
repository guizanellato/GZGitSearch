//
//  GZHomeViewController.m
//  GZGitSearch
//
//  Created by Guilherme Zanellato on 9/25/15.
//  Copyright © 2015 Guilherme Zanellato. All rights reserved.
//

#import "GZHomeViewController.h"

@interface GZHomeViewController ()

@end

@implementation GZHomeViewController

#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate && DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
     * Retorna altura de 75 para cada linha da TableView
     */
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSString *lblTitle;
    
    /*
     * Primeira linha da tableView sera para pesquisar por repositorios
     * A segunda linha da tableView sera para pesquisar por usuarios
     */
    
    if (indexPath.row == 0) {
        lblTitle = @"Realizar pesquisa por repositórios";
    } else {
        lblTitle = @"Realizar pesquisa por usuários";
    }
    
    cell.textLabel.text = lblTitle;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"openRepoSearch" sender:nil];
    } else {
        [self performSegueWithIdentifier:@"openUserSearch" sender:nil];
    }

}

@end
