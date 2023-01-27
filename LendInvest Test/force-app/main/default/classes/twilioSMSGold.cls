//Created 25/01/2023 by Kush Saparia
//Sends SMS notification using Twilio Rest API to set Users (CEO) when an Account reaches GOLD Status
public class twilioSMSGold {

    private static final String toNumber = TwilioSMS__c.getOrgDefaults().GoldAlertNumber__c; //Number to send SMS to is stored in this label

    //Sends an SMS for the accounts that hit the GOLD status
    @InvocableMethod(label='Send SMS Gold' description='sends SMS message when Gold status is reached')
    public static void sendSMS(List<Account> accs) {
        for (Account acc:accs){
            String smsBody = 'Great News! A customer has hit Gold. '+ acc.Name +' will get VIP treatment.'; 
            TwilioUtils.SendFutureSMS(toNumber, smsbody);
        }    
    }

}