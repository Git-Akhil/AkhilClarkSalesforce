import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getLeadData from '@salesforce/apex/akhilLwcInterviewcallClass.getLeadData';
import updateDoNotCall from '@salesforce/apex/akhilLwcInterviewcallClass.updateDoNotCall';
import reScheduleCall from '@salesforce/apex/akhilLwcInterviewcallClass.reScheduleCall';
import sendInfoMail from '@salesforce/apex/akhilLwcInterviewcallClass.sendInfoMail';
import sendEmailVerification from '@salesforce/apex/akhilLwcInterviewcallClass.sendEmailVerification'
import sendApprovalToManager from '@salesforce/apex/akhilLwcInterviewcallClass.sendApprovalToManager'
import checkApproval from '@salesforce/apex/akhilLwcInterviewcallClass.checkApproval'
import mypickList from '@salesforce/apex/getpicklistClass.mypickList';

export default class AkhilLwcInterviewcallBundle extends LightningElement {
    _title = '';
    message = '';
    variant = 'error';

    @track value = '';

    @api recordId;
    @api Source;

    @track pickListYearWrapper = [];

    @track isSpinner = true;
    @track selectedStep = 'step1';
    @track isintroStep1 = true;
    @track isintroStep2 = false;
    @track isintroStep3 = false;
    @track isintroStep4Success = false;
    @track isAlternativeVerification = false;
    @track isintroStep4Invalid = false;

    @track leadName = '';
    @track ownerName = '';
    @track phoneno = '';
    @track phonenoFirst6 = '';
    @track phonenoLast4 = '';
    @track last4input = '';
    @track clientEmail = '';
    @track leadData;

    @track isNostep1 = false;
    @track wantToschedule = false;
    @track noToschedule = false;
    @track doneReschedule = false;

    @track isNeedHelp = false;
    @track iSNoNeedHelp = false;
    @track isNeedEmail = false;
    @track isSMS = false;
    @track isEmail = false;
    @track isManager = false;
    @track isSendSMS = false;
    @track clientSMSCode = '';
    @track clientEmailcode = '';
    @track smsVerificationcode = '';
    @track emailverificationcode = '';
    @track startStep5Process = false;



    scheduleCallDate;

    get options() {
        return [
            { label: 'Send Link', value: 'link' },
            { label: 'Manually Rescheduale', value: 'manual' },
        ];
    }
    get isSendEmail() {
        console.log('----inside is sent email------');
        return this.value == 'link' ? true : false;
    }
    get isManualSchedule() {
        console.log('----inside manual sent email------');
        return this.value == 'manual' ? true : false;
    }
    handleChange(event) {
        this.value = event.detail.value;
        console.log('===this.value====', this.value);
    }

    changeScheduleDate(event) {
        this.scheduleCallDate = event.detail.value;
        console.log('-----this.scheduleCallDate-----', this.scheduleCallDate);
    }

    handleReschedule() {
        console.log('-----inside handleReschedule() -> this.scheduleCallDate ---------', this.scheduleCallDate);
        if (this.scheduleCallDate == '' || typeof this.scheduleCallDate === 'undefined') {
            console.log('-----inside handleReschedule() -> if -> this.scheduleCallDate ---------', this.scheduleCallDate);
            this._title = 'Error';
            this.message = 'please select date and time';
            this.variant = 'error';
            this.showNotification();
            return;
        }
        this.isSpinner = true;
        reScheduleCall({
            recId: this.recordId,
            dateTm: this.scheduleCallDate
        }).then(data => {
            console.log('-----inside handleReschedule() -> reScheduleCall() -> data ---------', data);
            if (data != 'error') {
                console.log('-----inside handleReschedule() -> reScheduleCall() -> if -> data ---------', data);
                this.isSpinner = false;
                this.doneReschedule = true;
                this.value = '';
                this.wantToschedule = false;
            } else {
                console.log('-----inside handleReschedule() -> reScheduleCall() -> else -> data ---------', data);
                this._title = 'Error';
                this.message = 'Error While Rescheduling call!';
                this.variant = 'error';
                this.showNotification();
            }
        })
    }

    backTowantToschedule() {
        this.wantToschedule = true;
        //this.value = '';
        this.doneReschedule = false;
    }

    connectedCallback() {
        console.log('----recorId--', this.recordId);
        console.log('====source===', this.Source);

        //----------------------------------checkbox Table start----------------------------------------------------- 
        this.pickListYearWrapper = [];

        mypickList({ recId: this.recordId })
            .then(data => {
                console.log('-----list<string> mypick-----', data);
                console.log('-----list<string> mypick length-----', data.length);
                this.pickListYearWrapper = data;


                console.log('-----list<string> this.pickListYearWrapper-----', this.pickListYearWrapper);

            }).catch(err => {
                console.log('------error found-----', err);
            })
        //----------------------------------checkbox Table End----------------------------------------------------- 

        if (this.Source == 'Lead') {
            this.isSpinner = false;
            getLeadData({
                recId: this.recordId
            }).then(data => {
                this.leadData = data;
                this.leadName = this.leadData.leadname;
                console.log('====this.leadname====', this.leadName);
                this.ownerName = this.leadData.OwnerName;
                console.log('====this.ownerName====', this.ownerName);
                this.phoneno = this.leadData.phoneNumber;
                console.log('----phoneno----', this.phoneno);
                if (typeof this.leadData.phoneNumber !== 'undefined' && this.leadData.phoneNumber.length > 6) {
                    this.phonenoFirst6 = this.leadData.phoneNumber.substring(0, this.leadData.phoneNumber.length - 4);
                    console.log('----phonenoFirst6----', this.phonenoFirst6);
                    this.phonenoLast4 = this.leadData.phoneNumber.substring(this.leadData.phoneNumber.length - 4, this.leadData.phoneNumber.length);
                    console.log('----phonenoLast4----', this.phonenoLast4);
                }
                this.clientEmail = this.leadData.emailId;
                console.log('----clientEmail----', this.clientEmail);
            }).catch(error => {
                this.isSpinner = false;
                console.log('=====getLeadData Error=====', error)
            })
        }
    }

    handleHeadYearCheckbox(event){
        console.log('-----headYearCheckbox Clicked -----');
        for(var i = 0; i <this.pickListYearWrapper.length ; i++){
            console.log('------inside checkbox loop --------',this.pickListYearWrapper[i].yIndex);
            this.template.querySelector('.'+this.pickListYearWrapper[i].yIndex).checked = event.target.checked;
            console.log('------inside checkbox loop --------',this.pickListYearWrapper[i].stateIndex);
            this.template.querySelector('.'+this.pickListYearWrapper[i].stateIndex ).checked = event.target.checked;
            console.log('------inside checkbox loop --------',this.pickListYearWrapper[i].IRSIndex);
            this.template.querySelector('.'+this.pickListYearWrapper[i].IRSIndex).checked = event.target.checked;
        }
        //this.template.querySelector('.'+this.pickListYearWrapper[i].yIndex).checked = event.target.checked;
    }
    handleHeadStatusCheckbox(event){
        console.log('-----handleHeadStatusCheckbox Clicked -----');
        for(var i = 0; i <this.pickListYearWrapper.length ; i++){
            console.log('------inside checkbox loop --------',this.pickListYearWrapper[i].stateIndex);
            this.template.querySelector('.'+this.pickListYearWrapper[i].stateIndex).checked = event.target.checked;
        }
    }
    handleHeadIRSCheckbox(event){
        console.log('-----handleHeadIRSCheckbox Clicked -----');    
        for(var i = 0; i <this.pickListYearWrapper.length ; i++){
            console.log('------inside checkbox loop --------',this.pickListYearWrapper[i].IRSIndex);
            this.template.querySelector('.'+this.pickListYearWrapper[i].IRSIndex).checked = event.target.checked;
        }
    }

    handleRowYearCheckbox(event){
        console.log('------row Check box clicked-------',event.target.name);
        let rowYear = event.target.name;
        console.log('----- rowYear -----',rowYear);
        this.template.querySelector('.state'+rowYear).checked = event.target.checked;
        this.template.querySelector('.IRS'+rowYear).checked = event.target.checked;
    }

    handaleRowSingleCheckBocState(event){
        console.log('-----handaleRowSingleCheckBoc clicked ------',event.target.name);
        let singlerowCheckbox = event.target.name;
        console.log('--- if condition state ---',this.template.querySelector('.state'+singlerowCheckbox).checked);
        console.log('--- if condition IRS ---',this.template.querySelector('.IRS'+singlerowCheckbox).checked);
        console.log('--- if condition2 ---',event.target.checked);

        if(this.template.querySelector('.state'+singlerowCheckbox).checked && this.template.querySelector('.IRS'+singlerowCheckbox).checked){
            console.log('--- inside if enter -----');
            this.template.querySelector('.Year'+singlerowCheckbox).checked = true;
        }
        
        else{
            console.log('--- inside else enter state-----');
            this.template.querySelector('.Year'+singlerowCheckbox).checked = false;
            // this.template.querySelector('.Year'+singlerowCheckbox).checked = event.target.checked;
        }
        
    }

    sendApprovalTomanager() {
        this.isSpinner = true;
        sendApprovalToManager({ recId: this.recordId })
            .then(data => {
                this.isSpinner = false;
                if (data != 'error') {
                    console.log('----inside sendApprovalTomanager data -----', data);
                    this.taskid = data;
                    this._title = 'Success';
                    this.message = 'Approval sent ,Please wait until manager approve request.';
                    this.variant = 'Success';
                    this.template.querySelector('.managerButton').label = 'Re-Send Approval';
                    this.showNotification();
                } else {
                    this._title = 'Error';
                    this.message = 'Error while sending approval';
                    this.variant = 'error';
                    this.showNotification();
                    return;
                }
            })
            .catch(error => {
                this.isSpinner = false;
                console.log('--inside sendApprovalTomanager => ', error);
            })
    }

    managerSuccess() {
        console.log('----inside managerSuccess  this.taskid ---', this.taskid);
        if (this.taskid == '' || this.taskid == 'error') {
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
            console.log('----inside managerSuccess => checkApproval data -----', data);
            if (data) {
                this.isintroStep4Success = true;
                this.isintroStep4Invalid = false;
                this.varificationSuccess();
            } else {
                this._title = 'Warning';
                this.message = 'manager has not approved your reques yet, Please wait.';
                this.variant = 'warning';
                this.showNotification();
                return;
            }
        })
    }


    sendEnailCode() {
        this.isSpinner = true;
        sendEmailVerification({ recId: this.recordId })
            .then(data => {
                console.log('-----inside sendEnailCode sendEmailVerification data random code ----', data);
                this.isSpinner = false;
                this.emailverificationcode = data;
                this.template.querySelector('.emailButton').label = 'Re-Send Code';
            }).catch(error => {
                this.isSpinner = false;
                console.log('--- inside sendEnailCode catch error===', error);
            })
    }

    emailcode = (event) => {
        this.clientEmailcode = event.target.value;
        console.log('----this.clientEmailcode -----', this.clientEmailcode);
    }

    verifyEmailCode() {
        if (this.clientEmailcode.length == 0) {
            this._title = 'Error';
            this.message = 'Please Enter Code!';
            this.variant = 'error';
            this.showNotification();
        }
        if (this.clientEmailcode == this.emailverificationcode) {
            this.isintroStep4Success = true;
            this.isintroStep4Invalid = false;
            this.isSMS = false;
            this.isEmail = false;
            this.isManager = false;
            this.varificationSuccess();
        } else {
            this._title = 'Error';
            this.message = 'Invalid Email verification Code!, Try Re-Send Code Or Other Method.';
            this.variant = 'error';
            this.showNotification();
        }
    }

    handleSendEnailInfo() {
        this.isSpinner = true;
        sendInfoMail({
            recId: this.recordId
        }).then(data => {

            console.log('----- inside handleSendEmailInfo-> then -> ----');
            this.closeAction();
            this.isSpinner = false;
        }).catch(error => {
            this.isSpinner = false;
            console.log('----- inside handleSendEmailInfo-> catch error -> ----', error);
        })
        //Remain 
    }



    // changeLast4(event){
    // this.last4input = event.target.value;
    // console.log('---last4input---',this.last4input);
    //   }

    changeLast4(event) {
        this.last4input = event.target.value;
        console.log('---last4input---', this.last4input);
    }
    handle4DigitClick() {
        console.log('----this.last4input----', this.last4input.length);
        if (this.last4input.length == 0) {
            this._title = 'Error';
            this.message = 'please Enter Code!';
            this.variant = 'error';
            this.showNotification();
            return;
        }
        if (this.phonenoLast4 == this.last4input) {
            this.isintroStep4Success = true;
            this.isintroStep4Invalid = false;
            this.selectedStep = 'step2';
            this.isintroStep3 = false;
            //this.varificationSuccess();
        } else {
            console.log('----inside handle4digitclick------');
            this.isintroStep4Success = false;
            this.isintroStep4Invalid = true;
            this.isAlternativeVerification = false;
            //remain try catch part
            try {

                console.log('querySelector==', this.template.querySelector(".inputlast4"));
                if (this.template.querySelector(".inputlast4")) {
                    this.template.querySelector(".inputlast4").setCustomValidity("No Match!");
                    this.template.querySelector(".inputlast4").reportValidity();
                    console.log('--- inside if querySelector==', this.template.querySelector(".inputlast4"));
                }
                var eventchange = new Event('change');
                this.template.querySelector(".inputlast4").dispatchEvent(eventchange);
            }
            catch (e) {
                console.log('e==', e);
            }
        }

    }

    handleStep5StartClick() {
        this.isintroStep4Success = false;
        this.startStep5Process = true;
    }

    backToisintroStep4Success() {
        this.isintroStep4Success = true;
        this.startStep5Process = false;
    }

    backToisIntroStep3() {
        this.isintroStep4Success = false;
        this.isintroStep4Invalid = false;
        this.selectedStep = 'step1';
        this.isintroStep3 = true;
        this.last4input = '';
    }

    selectMethod = (event) => {
        if (event.target.value == 'SMS') {
            this.isSMS = true;
            this.isEmail = false;
            this.isManager = false;
        }
        if (event.target.value == 'Email') {
            this.isSMS = false;
            this.isEmail = true;
            this.isManager = false;
        }
        if (event.target.value == 'Manager') {
            this.isSMS = false;
            this.isEmail = false;
            this.isManager = true;
        }
    }

    sendSMSCode() {
        this.isSendSMS = true;
        this.isSpinner = true;
        //remain window.addEventListner
        this.template.querySelector('.smsButton').label = 'Re-Send Code';
    }
    get fullUrlsendSMS() {
        //remain
    }

    smsCode = (event) => {
        this.clientSMSCode = event.target.value;
        console.log('----this.clientSMSCode-----', this.clientSMSCode);
    }

    verifySMSCode() {
        if (this.clientSMSCode == '') {
            console.log('--- inside verifySMSCode 1-if ---')
            this._title = 'Error';
            this.message = 'Please Enter code.';
            this.variant = 'error';
            this.showNotification();
            return;
        }
        if (this.clientSMSCode == this.smsVerificationcode) {
            this.isintroStep4Success = true;
            this.isintroStep4Invalid = false;
            this.isSMS = false;
            this.isEmail = false;
            this.isManager = false;
            this.varificationSuccess();
        } else {
            this._title = 'Error';
            this.message = 'Invalid SMS verification Code!, Try Re-Send Code Or Other Method.';
            this.variant = 'error';
            this.showNotification();
        }
    }

    handleupdateDoNotCall() {
        //not working
        this.isSpinner = true;

        updateDoNotCall({
            recId: this.recordId
        }).then(data => {
            console.log('-----handleupdateDoNotCall/updateDoNotCall/data----', data);
            if (data != 'error') {
                console.log('----handleupdateDoNotCall/updateDoNotCall/data inside if-----');
                this.isSpinner = false;
                this.closeAction();
            } else {
                console.log('----handleupdateDoNotCall/updateDoNotCall/data inside else-----');
                this._title = 'Error';
                this.message = 'Error while updating do not call!';
                this.variant = 'error';
                this.showNotification();
            }
        }).catch(error => {
            this.isSpinner = false;
            console.log('error==', error);
        })


    }

    varificationSuccess() {
        console.log('-----add varification success event-----');
        this.isSpinner = true;
        window.addEventListener("message", (event) => {
            console.log('----status----', event.data.flowStatus);
            //remain if item
        });
        //remain two lines 
    }

    get fullUrl() {
        //remain
    }

    showNotification() {
        const evt = new ShowToastEvent({
            title: this._title,
            message: this.message,
            variant: this.variant,

        });
        this.dispatchEvent(evt);
    }
    closeAction() {
        const closeQA = new CustomEvent('close');
        this.dispatchEvent(closeQA);
    }



    handleYesClick() {
        this.isintroStep1 = false;
        this.isintroStep2 = true;
    }
    backTostep1Handle() {
        this.isintroStep2 = false;
        this.isintroStep1 = true;
    }
    handleVerifiedClick() {
        this.isintroStep2 = false;
        this.isintroStep3 = true;
    }
    backTostep2Handle() {
        this.isintroStep2 = true;
        this.isintroStep3 = false;
        this.isintroStep4Invalid = false;
    }

    useAlternateMethod() {
        this.isAlternativeVerification = true;
    }

    handleNoClick() {
        this.isNostep1 = true;
        this.isintroStep1 = false;
    }
    backToStep1() {
        this.isNostep1 = false;
        this.isintroStep1 = true;
    }
    handleWantToschedule() {
        this.isNostep1 = false;
        this.wantToschedule = true;
    }
    backToIsSchedule() {
        this.isNostep1 = true;
        this.wantToschedule = false;
        this.noToschedule = false;
    }
    handleNoToschedule() {
        this.noToschedule = true;
        this.isNostep1 = false;
    }
    handleNeedHelp() {
        this.isNeedHelp = true;
        this.noToschedule = false;
    }
    backToIsNeedHelp() {
        this.noToschedule = true;
        this.isNeedHelp = false;
        this.iSNoNeedHelp = false;
    }
    handleNeedEmail() {
        this.isNeedEmail = true;
        this.isNeedHelp = false;
    }
    backToIsInfoNeed() {
        this.isNeedEmail = false;
        this.isNeedHelp = true;
    }
    handleNoNeedHelp() {
        this.iSNoNeedHelp = true;
        this.noToschedule = false;
    }
    handleOnOwn() {
        this.isNoOnOwn = true;
        this.iSNoNeedHelp = false;
    }
    backToIsOnOwn() {
        this.isNoOnOwn = false;
        this.iSNoNeedHelp = true;
    }

}