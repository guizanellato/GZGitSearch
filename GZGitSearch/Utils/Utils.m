//
//  Utils.m
//  GZGitSearch
//
//  Created by Guilherme Zanellato on 9/25/15.
//  Copyright © 2015 Guilherme Zanellato. All rights reserved.
//

#import "Utils.h"

#import "Constants.h"
#import "Reachability.h"

@implementation Utils

#pragma mark - Methods Util

+ (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles: nil];
    [alert show];
}

+ (BOOL)hasConnection {
    Reachability *r = [Reachability reachabilityWithHostName:URL_TEST_WIFI];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)) {
        return false;
    }
    return true;
}

+ (void)setAnimationToImageView:(UIImageView *)imgView {
    
    /*
     * Cria transicao do tipo "Fade" para uma imageView
     * Metodo para melhorar a exibicao de uma imagem
     */
    CATransition* transition = [CATransition animation];
    
    transition.duration = 0.40;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    
    [imgView.layer addAnimation:transition forKey:kCATransition];
}

#pragma mark - Response Formatter

+ (NSNumber *)getNumberFrom:(id)obj {
    /*
     * Metodo transforma qualquer @param em um NSNumber
     * Usado para prevenir de o fonte esperar um numero e vir uma string
     */
    
    if ([obj isKindOfClass:[NSNull class]]) {
        return @0;
    }
    
    NSNumber *nr;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    
    if ([obj isKindOfClass:[NSString class]])
        nr = [formatter numberFromString:obj];
    else
        nr = (NSNumber *)obj;
    
    return nr;
}

+ (NSString *)getStringFrom:(id)obj {
    /*
     * Metodo transforma qualquer @param em uma String
     * Usado para prevenir de o fonte esperar uma string e vir um numero
     */
    
    if ([obj isKindOfClass:[NSNull class]]) {
        return [[NSString alloc] init];
    }
    
    NSString *str;
    
    if ([obj isKindOfClass:[NSNumber class]])
        str = (NSString *)[obj stringValue];
    else
        str = (NSString *)obj;
    
    return str;
}

@end
