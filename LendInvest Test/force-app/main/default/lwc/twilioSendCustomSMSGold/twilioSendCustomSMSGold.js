//Created 25/01/2023 by Kush Saparia
//Allows users to send Custom SMS messages to Accounts
import { LightningElement, track, wire, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import sendSMS from '@salesforce/apex/twilioSendCustomSMSGoldController.sendSMS';
import { getFieldValue, getRecord } from 'lightning/uiRecordApi';
import ACCOUNT_PHONE_FIELD from '@salesforce/schema/Account.Phone'


export default class TwilioSendCustomSMSGold extends LightningElement {
    @track SMSBody="";
    @api recordId;
    resp;
    //wire to grab Account's phone number
    @wire (getRecord, {recordId: '$recordId', fields: [ACCOUNT_PHONE_FIELD]})
    account;

    
    get phone(){
        return getFieldValue(this.account.data, ACCOUNT_PHONE_FIELD);
    }
   
    //Stores the user's inputted text as SMSBody
    handleSMSBodyChange(event) {
      this.SMSBody=event.detail.value;
    }

    //disables Send button when there is no SMS body or "To" phone number
    get disableButton(){
      return (!this.SMSBody  || !this.phone);
    }

    //success Toast
    showSuccessToast() {
        const evt = new ShowToastEvent({
            title: 'SMS Success',
            message: 'SMS Sent',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }

    //failed Toast
    showFailedToast() {
        const evt = new ShowToastEvent({
            title: 'SMS Failed',
            message: 'Error Code: '+ this.error,
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }
  
    //Sends request to server-side to send SMS message via Twilio API
    send(){
        //wrapper for necessary variables
        var SMSWrap ={
            ToNumber:this.phone,
            SMSBody:this.SMSBody
        };
        sendSMS({SMSWrap: SMSWrap}).then(
            value => {
                this.resp=value;
                if (this.resp == 201){
                    this.showSuccessToast(); 
                    this.SMSBody="" //clears text area after message is sent;
                } else{
                    this.showFailedToast();
                }
            }
            ).catch(error => {
            console.log(error);
            this.resp = error;
            this.showFailedToast();
            })
        
        
             
    }
  }