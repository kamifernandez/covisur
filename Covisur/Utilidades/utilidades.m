//
//  utilidades.m
//  emi
//
//  Created by KUBO on 4/17/15.
//  Copyright (c) 2015 KUBO. All rights reserved.
//

#import "utilidades.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@implementation utilidades

+(BOOL)consultarGpsActivo{
    BOOL locationAllowed = NO;
    locationAllowed = [self locationAuthorized];
    
    if (locationAllowed==NO) {
        locationAllowed = NO;
    } else {
        locationAllowed = YES;
    }
    return locationAllowed;
}

+(BOOL)locationAuthorized {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f) {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        return (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse);
    }
    return ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways);
}

+ (BOOL)validateEmailWithString:(NSString*)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

+(BOOL)verifyEmpty:(UIView *)viewSend{
    for (UIView *i in viewSend.subviews){
        if([i isKindOfClass:[UIView class]]){
            UIView *viewSearch = (UIView *)i;
            for (UIView *e in viewSearch.subviews){
                if([e isKindOfClass:[UITextField class]]){
                    UITextField *viewTxt = (UITextField *)e;
                    if ([viewTxt.text isEqualToString:@""]) {
                        return YES;
                    }
                }
            }
        }
    }
    return NO;
}

+(NSString *)decimalNumberFormat:(int)decimalNumber{
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    [numberFormatter setMinimumFractionDigits:0];
    [numberFormatter setMinimumFractionDigits:0];
    NSString *numberString = [numberFormatter stringFromNumber: [NSNumber numberWithInteger:decimalNumber]];
    numberString = [numberString stringByReplacingOccurrencesOfString:@"," withString:@"."];
    
    return numberString;
}

+ (UIImage *) scaleAndRotateImage: (UIImage *)image
{
    int kMaxResolution = 3000; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef),      CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft)
    {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

+ (NSAttributedString*)attributedHTMLString:(NSString *)string useFont:(UIFont*)font1 useHexColor:(NSString*)color
{
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSString *stringFormat = [string stringByAppendingString:[NSString stringWithFormat:
                                                              @"<style>body{font-family: '%@'; font-size:%fpx; color: %@;}</style>",
                                                              font1.fontName,
                                                              font1.pointSize,
                                                              color]];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithData:[stringFormat dataUsingEncoding:NSUnicodeStringEncoding]
                                                                                        options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                                  NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                                             documentAttributes:nil
                                                                                          error:nil];
    
    [attributedText addAttribute:NSParagraphStyleAttributeName
                           value:paragraphStyle
                           range:NSMakeRange(0, attributedText.length)];
    
    return attributedText;
}

+(NSString*)processString :(NSString*)yourString
{
    if(yourString == nil){
        return @"";
    }
    int stringLength = (int)[yourString length];
    // the string you want to process
    int len = 4;  // the length
    NSMutableString *str = [NSMutableString string];
    int i = 0;
    for (; i < stringLength; i+=len) {
        NSRange range = NSMakeRange(i, len);
        if (i == 12 || i == 13 || i == 14 || i == 15) {
            [str appendString:[yourString substringWithRange:range]];
        }else{
            [str appendString:@"XXXX"];
        }
        if(i!=stringLength -4){
            [str appendString:@"-"]; //If required stringshould be in format XXXX-XXXX-XXXX-XXX then just replace [str appendString:@"-"]
        }
    }
    if (i < [str length]-1) {  // add remain part
        [str appendString:[yourString substringFromIndex:i]];
    }
    // str now is what your want
    
    return str;
}

+(NSString *)convertDayName:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE dd"];
    NSLog(@"%@",[dateFormatter stringFromDate:date]);
    NSString * dia = [dateFormatter stringFromDate:date];
    [dateFormatter setDateFormat:@"MMMM"];
    NSString * mes = [dateFormatter stringFromDate:date];
    return [NSString stringWithFormat:@"%@ de %@",dia,mes];
}

+(NSMutableArray *)getDatesFromNumber:(int)numberDate numberOfDays:(int)numberOfDays{
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = numberDate;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *offset = [[NSDateComponents alloc] init];
    NSMutableArray* dates = [NSMutableArray arrayWithObject:nextDate];
    
    for (int i = 1; i < numberOfDays; i++) {
        [offset setDay:i];
        NSDate *nextDay = [calendar dateByAddingComponents:offset toDate:nextDate options:0];
        bool diaNoLaboral = NO;
            NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
            NSLog(@"%@",[_defaults objectForKey:@"no_work_days"]);
            NSArray *split = [[_defaults objectForKey:@"no_work_days"] componentsSeparatedByString:@","];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            for (int j = 0; j<[split count]; j++) {
                [dateFormatter setDateFormat:@"dd-MM-yyyy"];
                NSString * dateString = [dateFormatter stringFromDate:nextDay];
                NSString * dateCompare = [split objectAtIndex:j];
                dateCompare = [dateCompare stringByReplacingOccurrencesOfString:@" " withString:@""];
                NSLog(@"%@",dateString);
                NSLog(@"%@",dateCompare);
                if ([dateString isEqualToString:dateCompare]) {
                    diaNoLaboral = YES;
                    break;
                }
            }
        if (diaNoLaboral == NO) {
            [dates addObject:nextDay];
        }
    }
    return dates;
}

+(NSString*)cardText:(OLCreditCardType)cardType
{
    NSString *name = nil;
    if (OLCreditCardTypeAmex == cardType) {
        name = @"AMEX";
    }
    else if (OLCreditCardTypeVisa == cardType) {
        name = @"VISA";
    }
    else if (OLCreditCardTypeMastercard == cardType) {
        name = @"MASTERCARD";
    }
    else if (OLCreditCardTypeDinersClub == cardType) {
        name = @"DINERS";
    }
    //    ,
    //    OLCreditCardTypeVisa,
    //    OLCreditCardTypeMastercard,
    //    OLCreditCardTypeDiscover,
    //    OLCreditCardTypeDinersClub,
    //    OLCreditCardTypeJCB,
    //    OLCreditCardTypeUnsupported,
    //    OLCreditCardTypeInvalid
    
    return name;
}

+(NSString *)formatTimeFromSeconds:(int)numberOfSeconds
{
    
    int seconds = numberOfSeconds % 60;
    int minutes = (numberOfSeconds / 60) % 60;
    int hours = numberOfSeconds / 3600;
    
    //we have >=1 hour => example : 3h:25m
    if (hours) {
        return [NSString stringWithFormat:@"%dh:%02dm", hours, minutes];
    }
    //we have 0 hours and >=1 minutes => example : 3m:25s
    if (minutes) {
        return [NSString stringWithFormat:@"%dm:%02ds", minutes, seconds];
    }
    //we have only seconds example : 25s
    return [NSString stringWithFormat:@"%ds", seconds];
}

@end
