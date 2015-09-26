//
//  Utils.h
//  GZGitSearch
//
//  Created by Guilherme Zanellato on 9/25/15.
//  Copyright © 2015 Guilherme Zanellato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject

/*!
 * Metodo para apresentar alertView
 */
+ (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message;

/*!
 * Metodo para saber se o usuario possui conexao com a internet
 */
+ (BOOL)hasConnection;

/*!
 * Metodo faz uma animação para a view desejada
 */
+ (void)setAnimationToImageView:(UIImageView *)imgView;

/*!
 * Metodo retorna um NSNumber de qualquer objeto que vier de @param
 */
+ (NSNumber *)getNumberFrom:(id)obj;

/*!
 * Metodo retorna uma string de qualquer objeto que vier de @param
 */
+ (NSString *)getStringFrom:(id)obj;

@end
