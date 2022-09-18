import { LightningElement, track, api, wire  } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getLeadData from '@salesforce/apex/interviewCallCon.getLeadData';
import sendEmailVerification from '@salesforce/apex/interviewCallCon.sendEmailVerification';
import getConvertedOpp from '@salesforce/apex/interviewCallCon.getConvertedOpp';
import updateDoNotCall from '@salesforce/apex/interviewCallCon.updateDoNotCall';
import reScheduleCall from '@salesforce/apex/interviewCallCon.reScheduleCall';
import sendInfoMail from '@salesforce/apex/interviewCallCon.sendInfoMail';
import sendApproval from '@salesforce/apex/interviewCallCon.sendApprovalToManager';
import checkApproval from '@salesforce/apex/interviewCallCon.checkApproval';
export default class InterviewCall extends NavigationMixin(LightningElement) {
    _title = '';
    message = '';
    variant = 'error';
    @track value = '';
    @api recordId;
    @track leadData;
    @api source;
    @track isSpinner = true;
    @track selectedStep = 'step1';
    @track leadname = '';
    @track ownerName = '';
    @track phoneno = '';
    @track phonenoLast4 = '';
    @track phonenoFirst6 = '';
    @track last4input = '';
    @track clientEmail = '';
    @track emailverificationcode = '';
    @track smsVerificationcode = '';
    @track clientEmailcode = '';
    @track clientSMSCode = '';
    @track isintroStep1 = true;
    @track isintroStep2 = false;
    @track isintroStep3 = false;
    @track isintroStep4Invalid = false;
    @track isintroStep4Success = false;
    @track isAlternativeVerification = false;
    @track step2Stage1 = false;
    @track isSMS = false;
    @track isEmail = false;
    @track isManager = false;
    @track isSendSMS = false;
    @track taskid = '';
    @track isNeedHelp = false;
    @track iSNoNeedHelp = false;
    @track isNeedEmail = false;
    @track isNoOnOwn = false;
    @track doneReschedule = false;
    url;
    scheduleCallDate;

    @track isNostep1 = false;
    @track wantToschedule = false;
    @track noToschedule = false;

    @api flowParams;
    @api flowName='Convert';
    @api flowNameSMS='Send_Verification';

    
    get options() {
      return [
          { label: 'Send Link', value: 'link' },
          { label: 'Manually Reschedule', value: 'manual' },
      ];
    }
    get isSendEmail(){
      return this.value == 'link' ? true : false;
    }
    get isManualSchedule(){
      return this.value == 'manual' ? true : false;
    }
    handleChange(event) {
      this.value = event.detail.value;
    }
    changeScheduleDate(event){
      this.scheduleCallDate = event.detail.value;
      console.log('on change date===',event.detail.value);
    }

    // regiser(){
    //   window.console.log('event registered ');
    //   pubsub.register('selectedStep', this.handleEvent.bind(this));
    // }
    handleEvent(messageFromEvt){
      window.console.log('event handled ',messageFromEvt.message);
      this.selectedStep = messageFromEvt.message;
    }
    connectedCallback(){
        this.flowParams = 'recordId='+this.recordId;
        console.log('===',this.source);
        if(this.source == 'Lead'){
          this.isSpinner = false;
          getLeadData({
              recId: this.recordId 
            }).then(data => {
              this.leadData = data;
              this.leadname = this.leadData.leadname;
              this.ownerName = this.leadData.ownerName;
              this.phoneno = this.leadData.phoneNumber;
              if(typeof this.leadData.phoneNumber !== 'undefined' && this.leadData.phoneNumber.length > 6){
                this.phonenoLast4 = this.leadData.phoneNumber.substring(this.phoneno.length-4,this.phoneno.length);
                this.phonenoFirst6 = this.leadData.phoneNumber.substring(0,this.phoneno.length-4);
              }
              this.clientEmail = this.leadData.emailId;
            }).
            catch(error => {
              this.isSpinner = false;
              console.log('error==',error);
            })
        }else{
          this.isSpinner = false;
          this.step2Stage1 = true;
          this.isintroStep1 = false;
          this.selectedStep = 'step2'
        }
        
    }
    sendEnailCode(){
      this.isSpinner = true;
      sendEmailVerification({
        recId: this.recordId 
      }).then(data => {
        this.isSpinner = false;
        this.emailverificationcode = data;
        this.template.querySelector('.emailButton').label = 'Re-Send Code';
      }).
      catch(error => {
        this.isSpinner = false;
        console.log('error==',error);
      })
    }

    handleSendEnailInfo(){
      this.isSpinner = true;
      sendInfoMail({
        recId: this.recordId 
      }).then(data => {
        this.closeAction();
        this.isSpinner = false;
      }).
      catch(error => {
        this.isSpinner = false;
        console.log('error==',error);
      })
    }

    handleupdateDoNotCall(){
      this.isSpinner = true;
      updateDoNotCall({
        recId: this.recordId 
      }).then(data => {
        if(data != 'error'){
          this.isSpinner = false;
          this.closeAction();
        }else{
          this._title = 'Error';
          this.message = 'Error while updating do not call!';
          this.variant = 'error';
          this.showNotification();
          return;
        }
      }).
      catch(error => {
        this.isSpinner = false;
        console.log('error==',error);
      })
    }
    reDirectToConvertedOpportunity(){
      this.isSpinner = true;
      getConvertedOpp({
        recId: this.recordId 
      }).then(data => {
        if(data != ''){
          this.isSpinner = false;
          console.log('opportuniy id===',data);
          this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: data,
                objectApiName: 'Opportunity',
                actionName: 'view'
            }
        });
        }else{
          this._title = 'Error';
          this.message = 'Lead is not converted';
          this.variant = 'error';
          this.showNotification();
          return;
        }
      }).
      catch(error => {
        this.isSpinner = false;
        console.log('error==',error);
      })
    }
    varificationSuccess(){
        this.isSpinner = true;
        window.addEventListener("message", (event) => {
          console.log('ststus=====',event.data.flowStatus);
          if(event.data.flowStatus == 'FINISHED_SCREEN'){
            this.selectedStep = 'step2';
            this.step2Stage1 = true;
            this.isSpinner = false;
            this.isintroStep4Success = false;
            this.isintroStep4Invalid = false;
            this.isintroStep3 = false;
            this.isintroStep1 = false;
            this.isintroStep2 = false;
            this.reDirectToConvertedOpportunity();
          }
          if(event.data.flowStatus == 'ERROR'){
            this.isSpinner = false;
          }
          if (event.data.flowOrigin !== this.url) {
              return;
          }
          const moveEvt = new CustomEvent('flowstatuschange', {
              detail: {
                  flowStatus: event.data.flowStatus,
                  flowParams: event.data.flowParams,
                  name: this.name,
                  flowName: this.flowName
              }
          });
          this.dispatchEvent(moveEvt);
      });
      let sfIdent = 'force.com';
      this.url = window.location.href.substring(0, window.location.href.indexOf(sfIdent) + sfIdent.length);
    }

    get fullUrlsendSMS() {
      var val = Math.floor(1000 + Math.random() * 9000);
      this.smsVerificationcode = val;
      let params = '&recordId='+this.recordId+'&smsText='+val; 
      let origin = (this.url ? '&origin=' + encodeURI(this.url) : '');
      return this.url + '/apex/screenFlow?flowname=' + this.flowNameSMS +  params + origin;
  }

    get fullUrl() {
        
        let params = '&recordId='+this.recordId; 
        let origin = (this.url ? '&origin=' + encodeURI(this.url) : '');
        return this.url + '/apex/screenFlow?flowname=' + this.flowName +  params + origin;
    }

    sendSMSCode(){
      this.isSendSMS = true;
      this.isSpinner = true;
        window.addEventListener("message", (event) => {
          console.log('ststus=====',event.data.flowStatus);
          if(event.data.flowStatus == 'FINISHED_SCREEN'){
            this.isSpinner = false;
            this.isSendSMS = false;
          }
          if(event.data.flowStatus == 'ERROR'){
            this.isSpinner = false;
          }
          if (event.data.flowOrigin !== this.url) {
              return;
          }
          const moveEvt = new CustomEvent('flowstatuschange', {
              detail: {
                  flowStatus: event.data.flowStatus,
                  flowParams: event.data.flowParams,
                  name: this.name,
                  flowName: this.flowName
              }
          });
          this.dispatchEvent(moveEvt);
      });
      let sfIdent = 'force.com';
      this.url = window.location.href.substring(0, window.location.href.indexOf(sfIdent) + sfIdent.length);
      this.template.querySelector('.smsButton').label = 'Re-Send Code';
    }

    sendApprovalTomanager(){
      this.isSpinner = true;
      sendApproval({
        recId: this.recordId 
      }).then(data => {
        this.isSpinner = false;
        if(data != 'error'){
          this.taskid = data;
          this._title = 'success';
          this.message = 'Approval sent, Please wait until manager approve request.';
          this.variant = 'success';
          this.template.querySelector('.managerButton').label = 'Re-Send Approval';
          this.showNotification();
        }else{
          this._title = 'Error';
          this.message = 'Error while sending approval';
          this.variant = 'error';
          this.showNotification();
          return;
        }
        
      }).
      catch(error => {
        this.isSpinner = false;
        console.log('error==',error);
      })
    }
    smsCode = (event) => {
      this.clientSMSCode = event.target.value;
    }
    emailcode = (event) => {
      this.clientEmailcode = event.target.value;
    }
    verifyEmailCode(){
      if(this.clientEmailcode.length == 0){
        this._title = 'Error';
        this.message = 'Please Enter Code!';
        this.variant = 'error';
        this.showNotification();
        return;
      }
      if(this.clientEmailcode == this.emailverificationcode){
        this.isintroStep4Success = true;
        this.isintroStep4Invalid = false;
        this.isSMS = false;
        this.isEmail = false;
        this.isManager = false;
        this.varificationSuccess();
      }else{
        this._title = 'Error';
        this.message = 'Invalid Email verification Code!, Try Re-Send Code Or Other Method.';
        this.variant = 'error';
        this.showNotification();
      }
    }
    handleYesClick() {
        this.isintroStep2 = true;
        this.isintroStep1 = false;
    }
    backTostep1Handle(){
        this.isintroStep2 = false;
        this.isintroStep1 = true;
    }
    handleVerifiedClick(){
        this.isintroStep2 = false;
        this.isintroStep3 = true;
    }
    backTostep2Handle(){
        this.isintroStep2 = true;
        this.isintroStep4Invalid = false;
        this.isintroStep4Invalid = false;
        this.isSMS = false;
        this.isEmail = false;
        this.isManager = false;
        this.isintroStep3 = false;
    }
    verifySMSCode(){
      if(this.clientSMSCode == ''){
        this._title = 'Error';
        this.message = 'Please Enter code.';
        this.variant = 'error';
        this.showNotification();
        return;
      }
      if(this.clientSMSCode == this.smsVerificationcode){
        this.isintroStep4Success = true;
        this.isintroStep4Invalid = false;
        this.isSMS = false;
        this.isEmail = false;
        this.isManager = false;
        this.varificationSuccess();
      }else{
        this._title = 'Error';
        this.message = 'Invalid SMS verification Code!, Try Re-Send Code Or Other Method.';
        this.variant = 'error';
        this.showNotification();
      }
      
    }
    managerSuccess(){
      if(this.taskid == '' || this.taskid =='error'){
        this._title = 'Error';
          this.message = 'Please ask for approval first!';
          this.variant = 'error';
          this.showNotification();
          return;
      }
      checkApproval({
        recId: this.recordId,
        taskId: this.taskid
      }).then(data => {
        if(data){
            this.isintroStep4Success = true;
            this.isintroStep4Invalid = false;
            this.varificationSuccess();
        }else{
          this._title = 'Warning';
          this.message = 'manager has not approved your reques yet, Please wait.';
          this.variant = 'warning';
          this.showNotification();
          return;
        }
      }).
      catch(error => {
        console.log('error==',error);
      })

     // this.isintroStep4Success = true;
      //    this.isintroStep4Invalid = false;
      //    this.isSMS = false;
       //   this.isEmail = false;
      //    this.isManager = false;
      
    }
    handle4DigitClick(){
        if(this.last4input.length == 0){
          this._title = 'Error';
          this.message = 'Please Enter Code!';
          this.variant = 'error';
          this.showNotification();
          return;
        }
        if(this.phonenoLast4 == this.last4input){
          this.isintroStep4Success = true;
          
          this.isintroStep3 = false;
          this.isAlternativeVerification = false;
          this.isintroStep4Invalid = false;
          this.varificationSuccess();
        }else{
          this.isintroStep4Success = false;
          this.isintroStep4Invalid = true;
          //this.isintroStep3 = false;
          this.isAlternativeVerification = false;
          try{
            if(this.template.querySelector(".inputlast4")){
              this.template.querySelector(".inputlast4").setCustomValidity("No Match!");
              this.template.querySelector(".inputlast4").reportValidity();
              
            }
            console.log('querySelector==',this.template.querySelector(".inputlast4"));

            var eventChange = new Event('change');
            this.template.querySelector(".inputlast4").dispatchEvent(eventChange);
            var eventfocus = new Event('focus');
            this.template.querySelector(".inputlast4").dispatchEvent(eventfocus);
            var eventblur = new Event('blur');
            this.template.querySelector(".inputlast4").dispatchEvent(eventblur);

          }catch(e){
            console.log('e==',e);
          }
          

        }
    }

    backTostepPhNumberHandle(){
        this.isintroStep4Invalid = false;
        this.isintroStep4Success = false;
        this.isAlternativeVerification = false;
        this.isintroStep3 = true;
    }
    useAlternateMethod(){
        this.isAlternativeVerification = true;
    }
    changeLast4 = (event) => {
      this.last4input = event.target.value;
    }
    selectMethod = (event) =>{
      if(event.target.value == 'SMS'){
        this.isSMS = true;
        this.isEmail = false;
        this.isManager = false;
      }
      if(event.target.value == 'Email'){
        this.isEmail = true;
        this.isSMS = false;
        this.isManager = false;
      }
      if(event.target.value == 'Manager'){
        this.isManager = true;
        this.isSMS = false;
        this.isEmail = false;
      }
    }

    handleNoClick(){
      this.isNostep1 = true;
      this.isintroStep1 = false;
    }

    handleWantToschedule(){
      this.wantToschedule = true;
      this.isNostep1 = false;
    }

    handleNoToschedule(){
      this.noToschedule = true;
      this.isNostep1 = false;
    }

    backToStep1(){
      this.isNostep1 = false;
      this.isintroStep1 = true;
    }

    backToIsSchedule(){
      this.noToschedule = false;
      this.wantToschedule = false;
      this.isNostep1 = true;
    }

    handleNeedHelp(){
      this.isNeedHelp = true;
      this.noToschedule = false;
    }

    handleNoNeedHelp(){
      this.iSNoNeedHelp = true;
      this.noToschedule = false;
    }

    backToIsNeedHelp(){
      this.noToschedule = true;
      this.isNeedHelp = false;
      this.iSNoNeedHelp = false;
    }

    handleNeedEmail(){
      this.isNeedEmail = true;
      this.isNeedHelp = false;
    }
    backToIsInfoNeed(){
      this.isNeedHelp = true;
      this.isNeedEmail = false;
    }

    handleNoOnOwn(){
      this.isNoOnOwn = true;
      this.iSNoNeedHelp = false;
    }

    handleOnOwn(){
      this.isNoOnOwn = true;
      this.iSNoNeedHelp = false;
    }
    backToIsOnOwn(){
      this.isNoOnOwn = false;
      this.iSNoNeedHelp = true;
    }
    handleReschedule(){
      if(this.scheduleCallDate == '' || typeof this.scheduleCallDate === 'undefined'){
        this._title = 'Error';
        this.message = 'Please select date and time!';
        this.variant = 'error';
        this.showNotification();
        return;
      }
      this.isSpinner = true;
      reScheduleCall({
        recId: this.recordId,
        dateTm : this.scheduleCallDate
      }).then(data => {
        if(data != 'error'){
          this.isSpinner = false;
          this.doneReschedule = true;
          this.value = '';
          this.wantToschedule = false;
        }else{
          this._title = 'Error';
          this.message = 'Error while rescheduling call!';
          this.variant = 'error';
          this.showNotification();
          return;
        }
      }).
      catch(error => {
        this.isSpinner = false;
        console.log('error==',error);
      })
      
    }
    backTowantToschedule(){
      this.doneReschedule = false;
      this.value = '';
      this.wantToschedule = true;
    }
    showNotification() {
        const evt = new ShowToastEvent({
            title: this._title,
            message: this.message,
            variant: this.variant,
        });
        this.dispatchEvent(evt);
    }
    closeAction(){
      const closeQA = new CustomEvent('close');
        // Dispatches the event.
        this.dispatchEvent(closeQA);
    }
}