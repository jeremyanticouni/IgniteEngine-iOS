//
//  IXMessageControl.m
//  Ignite iOS Engine (IX)
//
//  Created by Jeremy Anticouni on 11/16/13.
//  Copyright (c) 2013 Apigee, Inc. All rights reserved.
//

/*
 
 CONTROL
 
 - TYPE : "Message"
 
 - PROPERTIES
 
 * name="message.type"          default=""               type="text, email"
 * name="message.to"            default=""               type="String"
 * name="message.cc"            default=""               type="String"
 * name="message.bcc"           default=""               type="String"
 * name="message.subject"       default=""               type="String"
 * name="message.body"          default=""               type="String"
 
 - EVENTS
 
 * name="message_cancelled"
 * name="message_failed"
 * name="message_sent"
 
 
 {
    "type": "Message",
    "properties": {
        "id": "myEmail",
        "width": "100%",
        "height": "50",
        "message": {
            "type": "email",
            "to": "jeremy@anticouni.net",
            "subject": "this is a subject",
            "body": "Uhh nice man I don't know how that works but awesome"
        },
        "color": {
            "background": "#00FFFF"
        }
    }
}
 
 */

#import "IXMessage.h"
#import "IXAppManager.h"
#import "IXNavigationViewController.h"
#import "IXViewController.h"
#import <MessageUI/MessageUI.h>

@interface  IXMessage() <MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>

@property (nonatomic,strong) NSString *messageSubject;
@property (nonatomic,strong) NSString *messageBody;
@property (nonatomic,strong) NSArray *messageToRecipients;
@property (nonatomic,strong) NSArray *messageCCRecipients;
@property (nonatomic,strong) NSArray *messageBCCRecipients;

@property (nonatomic,strong) MFMessageComposeViewController *textMessage;
@property (nonatomic,strong) MFMailComposeViewController *emailMessage;

@end

@implementation IXMessage

-(void)dealloc
{
    [_textMessage setMessageComposeDelegate:nil];
    if( [_textMessage presentingViewController] && ![_textMessage isBeingDismissed] )
       [_textMessage dismissViewControllerAnimated:NO completion:nil];
    
    [_emailMessage setMailComposeDelegate:nil];
    if( [_emailMessage presentingViewController] && ![_emailMessage isBeingDismissed] )
        [_emailMessage dismissViewControllerAnimated:NO completion:nil];
}

-(void)applySettings
{
    [super applySettings];
    
    [self setMessageSubject:[[self propertyContainer] getStringPropertyValue:@"message.subject" defaultValue:nil]];
    [self setMessageBody:[[self propertyContainer] getStringPropertyValue:@"message.body" defaultValue:nil]];
    [self setMessageToRecipients:[[self propertyContainer] getCommaSeperatedArrayListValue:@"message.to" defaultValue:nil]];
    [self setMessageCCRecipients:[[self propertyContainer] getCommaSeperatedArrayListValue:@"message.cc" defaultValue:nil]];
    [self setMessageBCCRecipients:[[self propertyContainer] getCommaSeperatedArrayListValue:@"message.bcc" defaultValue:nil]];
}

-(void)applyFunction:(NSString*)functionName withParameters:(IXPropertyContainer*)parameterContainer
{
    if( [functionName isEqualToString:@"present_text_message_controller"] )
    {
        if( [MFMessageComposeViewController canSendText] )
        {
            if( [self textMessage] == nil || ![[self textMessage] isBeingPresented] )
            {
                [[self textMessage] setMessageComposeDelegate:nil];
                [self setTextMessage:nil];
                
                MFMessageComposeViewController* messageComposeViewController = [[MFMessageComposeViewController alloc] init];
                [messageComposeViewController setMessageComposeDelegate:self];
                [messageComposeViewController setSubject:[self messageSubject]];
                [messageComposeViewController setRecipients:[self messageToRecipients]];
                [messageComposeViewController setBody:[self messageBody]];
                [self setTextMessage:messageComposeViewController];
                
                [[[IXAppManager sharedInstance] rootViewController] presentViewController:[self textMessage] animated:YES completion:nil];
            }
        }
    }
    else if( [functionName isEqualToString:@"present_email_controller"] )
    {
        if( [MFMailComposeViewController canSendMail] )
        {
            if( [self emailMessage] == nil || ![[self emailMessage] isBeingPresented] )
            {
                [[self emailMessage] setMailComposeDelegate:nil];
                [self setEmailMessage:nil];
                
                MFMailComposeViewController* mailComposeViewController = [[MFMailComposeViewController alloc] init];
                [mailComposeViewController setMailComposeDelegate:self];
                [mailComposeViewController setSubject:[self messageSubject]];
                [mailComposeViewController setToRecipients:[self messageToRecipients]];
                [mailComposeViewController setCcRecipients:[self messageCCRecipients]];
                [mailComposeViewController setBccRecipients:[self messageBCCRecipients]];
                [mailComposeViewController setMessageBody:[self messageBody] isHTML:YES];
                [self setEmailMessage:mailComposeViewController];
                
                [[[IXAppManager sharedInstance] rootViewController] presentViewController:[self emailMessage] animated:YES completion:nil];
            }
        }
    }
    else
    {
        [super applyFunction:functionName withParameters:parameterContainer];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
        case MessageComposeResultCancelled:
            [[self actionContainer] executeActionsForEventNamed:@"message_cancelled"];
            break;
        case MessageComposeResultFailed:
            [[self actionContainer] executeActionsForEventNamed:@"message_failed"];
            break;
        case MessageComposeResultSent:
            [[self actionContainer] executeActionsForEventNamed:@"message_sent"];
            break;
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            [[self actionContainer] executeActionsForEventNamed:@"message_cancelled"];
            break;
        case MFMailComposeResultFailed:
            [[self actionContainer] executeActionsForEventNamed:@"message_failed"];
            break;
        case MFMailComposeResultSent:
            [[self actionContainer] executeActionsForEventNamed:@"message_sent"];
            break;
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
