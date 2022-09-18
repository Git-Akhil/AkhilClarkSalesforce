import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LEAD_OBJECT from '@salesforce/schema/Lead';
import getLeadstatusValues from '@salesforce/apex/leadInsertTableclass.getLeadstatusValues';
import saveLeadInserttable from '@salesforce/apex/leadInsertTableclass.saveLeadInserttable';
import createLeadRecord from '@salesforce/apex/leadInsertTableclass.createLeadRecord'
import getLeadList from '@salesforce/apex/leadInsertTableclass.getLeadList'
import FIRST_NAME from '@salesforce/schema/Lead.FirstName';
import LAST_NAME from '@salesforce/schema/Lead.LastName';
import COMPANY from '@salesforce/schema/Lead.Company';
import EMAIL from '@salesforce/schema/Lead.Email';
import STATUS from '@salesforce/schema/Lead.Status';
import Date_Record_Insert from '@salesforce/schema/Lead.Date_Record_Insert__c';

const column = [
    { label: "FirstName", fieldName: "FirstName" },
    { label: "LastName", fieldName: "LastName" },
    { label: "Company", fieldName: "Company" },
    { label: "Email", fieldName: "Email", type: "email" },
    { label: "Lead Status", fieldName: "Status" },
    { label: "Date Record Insert", fieldName: "Date_Record_Insert__c", type: "Date" }
];
export default class LeadInsertTableBundle extends LightningElement {
    //@api recordId;
    //@api objectApiName;
    @track columns = column;

    @track getleadStatusOptions = [];
    @track leadArray = [];
    @track index = 0;
    @track LeadDataInsertList = [];
    @track isLoaded = false;

    @track firstName = FIRST_NAME;
    @track lastName = LAST_NAME;
    @track company = COMPANY;
    @track email = EMAIL;
    @track status = STATUS;
    @track dateRecordInsert = Date_Record_Insert;

    record = {
        FirstName: this.firstName,
        LastName: this.lastName,
        Company: this.company,
        Email: this.email,
        Status: this.status,
        Date_Record_Insert__c: this.dateRecordInsert,
        num: ''
    }

    addRow() {
        console.log('---- add row clicked-----');
        this.index++;
        let pass = this.index;
        this.record.num = pass;
        console.log('----this.record.num------', this.record.num);
        this.LeadDataInsertList.push(JSON.parse(JSON.stringify(this.record)));
        console.log('---this.LeadDataInsertList enter -----', this.LeadDataInsertList);
    }

    connectedCallback() {
        //console.log('----recordId------',recordId);
        //console.log('----objectApiName------',objectApiName);


        getLeadstatusValues()
            .then(data => {
                console.log('---inside then ----', data);
                this.getleadStatusOptions = [];
                for (let i = 0; i < data.length; i++) {
                    console.log('-----inside for i------', i)
                    this.getleadStatusOptions.push({ label: data[i], value: data[i] });
                    console.log('---this.getleadStatusOptions---', this.getleadStatusOptions[i].label);
                }
                console.log('----getleadStatusOptions----', this.getleadStatusOptions);
            }).catch(error => {
                console.log('---error----', error);
            })

        this.loadData();
    }



    loadData() {
        console.log('---- loadData called ----');
        getLeadList()
            .then(result => {
                console.log('----getleadlist result----', result);
                this.leadArray = [];
                for (var i = 0; i < result.length; i++) {
                    this.leadArray.push({ "FirstName": result[i].FirstName, "LastName": result[i].LastName, "Company": result[i].Company, "Email": result[i].Email, "Status": result[i].Status, "Date_Record_Insert__c": result[i].Date_Record_Insert__c });
                }
                console.log('-------this.leadArray-----', this.leadArray);
            })
            .catch(err => {
                console.log('----getleadlist err----', err);
            })

    }




    handaleFirstNameChange(event) {
        console.log('first name changed');
        //rownum = event.target.name;
        var selectedRow = event.currentTarget;
        console.log('----selected row class-----', selectedRow);
        var key = selectedRow.dataset.id;
        console.log('---rownum name----', key);
        this.LeadDataInsertList[key].FirstName = event.target.value;
        console.log('----this.leaddataInsert----', this.LeadDataInsertList);

    }
    handaleLastNameChange(event) {
        //     this.record.LastName = event.target.value;
        //     console.log('---LastName----', this.record.LastName);
        console.log('last name changed');
        //rownum = event.target.name;
        var selectedRow = event.currentTarget;
        //console.log('----selected row class-----',selectedRow);
        var key = selectedRow.dataset.id;
        console.log('---rownum name----', key);
        this.LeadDataInsertList[key].LastName = event.target.value;
        console.log('----this.leaddataInsert----', this.LeadDataInsertList);

    }
    handaleCompanyChange(event) {
        //     this.record.Company = event.target.value;
        //     console.log('---LastName----', this.record.Company);
        //Company field changed 
        console.log('Company field changed');
        //rownum = event.target.name;
        var selectedRow = event.currentTarget;
        console.log('----selected row class-----', selectedRow);
        var key = selectedRow.dataset.id;
        console.log('---rownum name----', key);
        this.LeadDataInsertList[key].Company = event.target.value;
        console.log('----this.leaddataInsert----', this.LeadDataInsertList);

    }
    handaleEmailChange(event) {
        //     this.record.Email = event.target.value;
        //     console.log('---email----', this.record.Email);
        //email field changed
        console.log('email field changed');
        //rownum = event.target.name;
        var selectedRow = event.currentTarget;
        console.log('----selected row class-----', selectedRow);
        var key = selectedRow.dataset.id;
        console.log('---rownum name----', key);
        this.LeadDataInsertList[key].Email = event.target.value;
        console.log('----this.leaddataInsert----', this.LeadDataInsertList);

    }
    handleStatusChange(event) {
        //     this.record.Status = event.target.value;
        //     console.log('---Status----', this.record.Status);
        //status field changed
        console.log('status field changed');
        //rownum = event.target.name;
        var selectedRow = event.currentTarget;
        console.log('----selected row class-----', selectedRow);
        var key = selectedRow.dataset.id;
        console.log('---rownum name----', key);
        this.LeadDataInsertList[key].Status = event.target.value;
        console.log('----this.leaddataInsert----', this.LeadDataInsertList);

    }
    handaleDateRecordChange(event) {
        //     this.record.Date_Record_Insert__c = event.target.value;
        //     console.log('---Date_Record_Insert__c----', this.record.Date_Record_Insert__c);
        //Date record field changed
        console.log('Date record field changed');
        //rownum = event.target.name;
        var selectedRow = event.currentTarget;
        console.log('----selected row class-----', selectedRow);
        var key = selectedRow.dataset.id;
        console.log('---rownum name----', key);
        this.LeadDataInsertList[key].Date_Record_Insert__c = event.target.value;
        console.log('----this.leaddataInsert----', this.LeadDataInsertList);

    }

    handleSaveClick() {
        console.log('-----save button clicked this.LeadDataInserted -----',this.LeadDataInsertList);
        saveLeadInserttable({ leadlst : this.LeadDataInsertList })
            .then(result => {
               
                this.message = result;
                console.log('---- inside save lead insert table this.message -----', this.message);
                this.error = undefined;
                if (this.message !== undefined) {
                    this.LeadDataInsertList = [];
                    this.index = 0;
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'data inserted suceessfully',
                            variant: 'success',
                        })
                    );
                }
                this.loadData();
            })
            .catch(err => {
                this.message = undefined;
                this.error = err;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: err.body.message,
                        variant: 'error'
                    })
                );
                console.log("error", JSON.stringify(this.err));
            })
            

        // createLeadRecord({ l: this.record })
        //     .then(data => {

        //         console.log('----JSON.stringify(data)----', JSON.stringify(data));

        //         this.message = data;

        //         console.log('----- this.meaasge-----', this.message);

        //         this.record.FirstName = '';
        //         this.record.LastName = '';
        //         this.record.Company = '';
        //         this.record.Email = '';
        //         this.record.Status = '';
        //         this.record.Date_Record_Insert__c = '';

        //         this.error = undefined;
        //         if (this.message !== undefined) {
        //             this.dispatchEvent(
        //                 new ShowToastEvent({
        //                     title: 'Success',
        //                     message: 'Lead Inseted Successfully',
        //                     variant: 'success',
        //                 }),
        //             );
        //         }
        //         this.loadData();

        //     })
        //     .catch(error => {
        //         this.message = undefined;
        //         this.error = error;
        //         console.log('----erroe while create error----', this.error)
        //         this.dispatchEvent(
        //             new ShowToastEvent({
        //                 title: 'Error Creating Record',
        //                 message: error.body.message,
        //                 variant: 'error',
        //             }),
        //         );
        //     })
    }

    removeRow(event){
        this.isLoaded = true;
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        console.log('-----delete row num-----',key);
        if(this.LeadDataInsertList.length > 1){
            this.LeadDataInsertList.splice(key,1);
            this.index--;
            this.isLoaded = false;
        }
        else if(this.LeadDataInsertList.length == 1 ){
            this.LeadDataInsertList = [];
            this.index = 0;
            this.isLoaded = false;

        }
    }

    handleCancelClick() {
        this.template.querySelectorAll('lightning-input').forEach(element => {
            console.log('------element clear ------');
            element.value = null;

        });
        this.template.querySelector('lightning-combobox').value = null;
        this.LeadDataInsertList = [];
        this.index = 0;
    }
}