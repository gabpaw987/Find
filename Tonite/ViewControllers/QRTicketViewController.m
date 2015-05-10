//
//  QRTicketViewController.m
//  Tonite
//
//  Created by Sean on 4/9/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import "QRTicketViewController.h"
#import "NSDate+Helper.h"

@interface QRTicketViewController ()

@end

@implementation QRTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    //[self.view setBackgroundColor:[UIColor grayColor]];
    [self.navigationController setNavigationBarHidden:NO];
    
    self.ticketType = [CoreDataController getTicketTypeByEventId:self.event.event_id];
    
    //random string to translate to QR code
    NSString * inputString = self.event.event_name;
    
    //function which generates QR code
    self.imgView.image = [self generateQRCodeFromString:inputString];
    
    //do background image stuff
    UIImageView* ticketbgrd = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TicketBG-short.png"]];
    [ticketbgrd setFrame: CGRectMake(0, 0/*self.view.frame.size.height*1/10*/, self.view.frame.size.width,self.view.frame.size.height/**9/10*/)];
    [ticketbgrd setContentMode:UIViewContentModeScaleAspectFill];
    self.ticketPic = ticketbgrd;
    
    UIImageView* back = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TicketBG-grey.png"]];
    [back setFrame: CGRectMake(0, 0.0, self.view.frame.size.width,self.view.frame.size.height)];
    [back setContentMode:UIViewContentModeScaleAspectFill];
    self.ticketPic = ticketbgrd;
    self.backgroundPic = back;
    
    
    //   UIImage * ticketbgrd = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TicketBG-short" ofType:@"png"]];
    //   UIImage * back = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TicketBG-grey" ofType:@"png"]];
    //[self.view bringSubviewToFront:self.ticketPic];
    //[self.view insertSubview:self.backgroundPic atIndex:2];
    // [self.view insertSubview:self.ticketPic atIndex:3];
    
    
    [self.view addSubview:self.ticketPic];
    [self.view addSubview:self.backgroundPic];
    
    [self.view sendSubviewToBack:self.ticketPic];
    [self.view sendSubviewToBack:self.backgroundPic];
    
    
    
    
    
    
    // self.backgroundPic.image = back;
    
    
    //do date/time from database
    NSDate * myDate = [NSDate dateFromString:self.event.event_date_starttime withFormat:[NSDate dbFormatString]];
    
    
    
    //event name
    
    //auto-format code
    UILabel *eventNameString = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/10, 1*self.view.bounds.size.height/10, self.view.bounds.size.width*8/10, self.view.bounds.size.height/10)];
    // eventNameString.backgroundColor = [UIColor redColor];
    eventNameString.text = self.event.event_name;
    eventNameString.textAlignment = NSTextAlignmentLeft;
    [eventNameString setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:32.0]];
    eventNameString.textColor = [UIColor blackColor];
    
    
    //eventNameString.font = [UIFont systemFontOfSize:40];
    //eventNameString.textAlignment = NSTextAlignmentCenter;
    [self.view bringSubviewToFront:eventNameString];
    [self.view addSubview:eventNameString];
    
    //[UIFont fontNamesForFamilyName:@"Helvetica Neue"];
    
    //NSLog(@" %@", [UIFont fontNamesForFamilyName:@"Helvetica Neue"]);
    
    
    // self.eventNameString.text = self.event.event_name;
    
    
    //take care of date
    //  self.dateString.text = [NSDate stringForDisplayFromFutureDate:myDate prefixed:NO alwaysDisplayTime:NO ]; //need database update to test this
    self.dateString.text = [NSDate stringForDisplayFromDate:myDate];
    
    
    
    
    
    
    
    //take care of time
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *formattedDate = [dateFormatter stringFromDate:myDate];
    
    if ([formattedDate characterAtIndex:3] == '0' && [formattedDate characterAtIndex:4] == '0') {
        NSLog(@"boring time");
        
        const char * cString = [formattedDate UTF8String];
        char newTime[6];
        
        newTime[0] = cString[0];
        newTime[1] = cString[1];
        newTime[2] = ' ';
        newTime[3] = cString[6];
        newTime[4] = cString[7];
        newTime[5] = '\0';
        
        const char * finalTime = newTime;
        NSString * finalString = [[NSString alloc] initWithUTF8String: finalTime];
        self.timeString.text = [@"DOORS OPEN @" stringByAppendingString: finalString];
        
    }
    else
        self.timeString.text = [@"DOORS OPEN @" stringByAppendingString: formattedDate];
    
    //take care of location
    NSArray *substrings = [self.event.event_address1 componentsSeparatedByString:@","];
    self.venueString.text = [[substrings objectAtIndex:0] uppercaseString];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//Core Images will natively create a CIImage, given a string
- (CIImage *)createQRForString:(NSString *)qrString
{
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    // Send the image back
    return qrFilter.outputImage;
}

//Translate the CIImage returned by CoreImages, into a more usable UIImage
- (UIImage *)createNonInterpolatedUIImageFromCIImage:(CIImage *)image withScale:(CGFloat)scale
{
    // Render the CIImage into a CGImage
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:image fromRect:image.extent];
    
    // Now we'll rescale using CoreGraphics
    UIGraphicsBeginImageContext(CGSizeMake(image.extent.size.width * scale, image.extent.size.width * scale));
    CGContextRef context = UIGraphicsGetCurrentContext();
    // We don't want to interpolate (since we've got a pixel-correct image)
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    // Get the image out
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // Tidy up
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    return scaledImage;
}

- (UIImage *)generateQRCodeFromString:(NSString *)inputString
{
    CIImage * qrCode = [self createQRForString:inputString];
    UIImage * qrCodeImg = [self createNonInterpolatedUIImageFromCIImage:qrCode withScale:2*[[UIScreen mainScreen] scale]];
    return qrCodeImg;
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
