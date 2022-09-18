import { LightningElement, track, wire, api } from 'lwc';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import getYearValues from '@salesforce/apex/getpicklistClass.getYearValues';
import mypickList from '@salesforce/apex/getpicklistClass.mypickList';

// const column = [
//     {label:"Year" , fieldName: "Year__c"},
//     {label:"Unfield state" , fieldName: "Year__c",type:"checkBox"},
//     {label:"unfield IRS" , fieldName: "Year__c" ,type:"checkBox"}
// ];
export default class GetPickList extends LightningElement {
    @api recordId;
    @track column;

    @track pickListYearWrapper = [];

    // @wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
    // accountMetadata;

    // @wire(getPicklistValues,

    //     {

    //         recordTypeId: '$accountMetadata.data.defaultRecordTypeId', 

    //         fieldApiName: INDUSTRY_FIELD

    //     }

    // )

    // industryPicklist({data , error}){
    //     console.log('----industrypicklist-----',data.values);
    // }

    // @wire(getPicklistValues, { recordTypeId: this.recId , fieldApiName: Year__c })
    // propertyOrFunction;

    connectedCallback() {
        console.log('-------getpicklist recordId-----', this.recordId);
        this.pickListYearWrapper = [];

        // getYearValues({ recId: this.recordId })
        //     .then(data => {
        //         console.log('-----getpicklist year values -----', data[0]);
        //     }).catch(error => {
        //         console('-----found an error in getpicklist error ----', error);
        //     })


        mypickList({ recId: this.recordId })
            .then(data => {
                console.log('-----list<string> mypick-----', data);
                console.log('-----list<string> mypick length-----', data.length);
                this.pickListYearWrapper = data;

               
                console.log('-----list<string> this.pickListYearWrapper-----', this.pickListYearWrapper);

            }).catch(err => {
                console.log('------error found-----', err);
            })
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

    
}