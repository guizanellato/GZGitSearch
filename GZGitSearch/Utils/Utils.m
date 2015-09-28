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
#import "DateTools.h"

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

+ (BOOL)isValidEmail:(NSString *)email {
    /*
     * Metodo valida se o email é valido
     */
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

#pragma mark - Date Formatter

+ (NSString *)convertDateWithString:(NSString *)dateString
{
    /*
     * Retirar as letras Z e T para nao atrapalharem na formatacao
     */
    dateString = [dateString stringByReplacingOccurrencesOfString:@"Z" withString:@" "];
    dateString = [dateString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    NSDate *receivedDate = [formatter dateFromString:dateString];
    NSDate *actualDate = [NSDate date];
    
    NSInteger daysApart = [actualDate daysFrom:receivedDate];
    NSInteger secondsApart = [actualDate secondsFrom:receivedDate];
    NSInteger minutesApart = [actualDate minutesFrom:receivedDate];
    NSInteger hoursApart = [actualDate hoursFrom:receivedDate];
    
    if (receivedDate.day == actualDate.day) {
        if (secondsApart < 60) {
            return [NSString stringWithFormat:@"%ld segundos atrás", (long)secondsApart];
        }
        else if (minutesApart < 60) {
            return [NSString stringWithFormat:@"%ld minutos atrás", (long)minutesApart];
        }
        else if (hoursApart < 23) {
            return [NSString stringWithFormat:@"%ld horas atrás", (long)hoursApart];
        }
    }
    else {
        if (daysApart <= 1) {
            return @"Ontem";
        }
        else if (daysApart >= 2) {
            
            [formatter setDateFormat:@"dd  MMMM'.'yyyy"];
            
            NSString *finalDate = [formatter stringFromDate:receivedDate];
            
            return finalDate;
        }
    }
    
    [formatter setDateFormat:@"dd  MMMM'.'yyyy"];
    
    NSString *finalDate = [formatter stringFromDate:receivedDate];
    
    return finalDate;
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
