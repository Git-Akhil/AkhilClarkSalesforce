import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { updateRecord } from 'lightning/uiRecordApi';

import getContactList from '@salesforce/apex/LwcInterviewCallClass.getContactList';
import getAccountName from '@salesforce/apex/LwcInterviewCallClass.getAccountName';
import getFieldNameAndRecord from '@salesforce/apex/LwcInterviewCallClass.getFieldNameAndRecord';
//import CONTACT_OBJECT from '@salesforce/schema/Contact';
//import updateContact from '@salesforce/apex/LwcInterviewCallClass.updateContact';


const column = [
    { label: "Name", fieldName: "Name" },
    { label: "Title", fieldName: "Title" },
    { label: "Phone", fieldName: "Phone", type: "phone" },
    { label: "Email", fieldName: "Email", type: "email" },
    { label: "Action", fieldName: "Action", type: "action" }
];

export default class LwcInterviewCallBundle extends LightningElement {
    @api recordId;


    @track contactArray = [];
    @track column = column;
    @track statusLoadingTable = true;
    @track Accountname;
    @track Accountdata;

    //-------------------------------------------------
    // using field set
    //--------------------------------------------------

    @track tabledata;
    @track columns2;
    @track labelContact;
    @track CountRecContact;
    @track listOffields = [];

    // for pagination

    @track page = 1;
    @track pagesize = 3;
    @track totalPage = 0;
    @track startingRec = 1;
    @track endingRec = 0;
    @track listOfRecord = [];

    //for popup
    @track isPopupOpen = false;
    @track ApifieldNamelist;
    @track conId='';
    @track contactRecord={};

    // @wire(getContactList, {accountId: "$recordId" })
    // WiredRecordMethod({ error , data }){
    //     if(data){

    //     }
    // }

    connectedCallback() {
        console.log('--recordID---', this.recordId);
        console.log('--column---', this.column);
        this.statusLoadingTable = false;
        
        this.loaddata();

    }


    loaddata(){
        if (this.recordId) {
            console.log('---- after Function ----', this.recordId);

            getContactList({
                "idRec": this.recordId
            }).then(data => {
                console.log('--data--', data);
                console.log('--type of data--', typeof (data));

                this.contactArray = [];

                for (var i = 0; i < data.length; i++) {
                    console.log('--inside for data--', data[i]);
                    this.contactArray.push({ "id": data[i].id, "Name": data[i].Name, "Email": data[i].Email, "Phone": data[i].Phone, "Title": data[i].Title });
                };
                console.log('---for loop over contactArray ----' + this.contactArray[0].Name);

            }).
                catch(error => {
                    console.log('error==', error);
                })

            getAccountName({
                rId: this.recordId
            })
                .then(result => {
                    this.Accountdata = result;
                    this.Accountname = this.Accountdata.Name;
                })
                .catch(error => {
                    console.log('Error Occured:- ' + error.body.message);
                });


            //------------------------------------------------------------- using field set ---------------------------------------------------------

            getFieldNameAndRecord({
                "idRecord": this.recordId
            })
                .then(result => {
                    console.log('----- inside getFieldNameAndRecord ----- ')

                    let objStr = JSON.parse(result);
                    console.log('objStr =====>', objStr);

                    this.listOffields = JSON.parse(Object.values(objStr)[1]);
                    console.log('this.listOffields =====>', this.listOffields);
                    let items = [];
                    // for(let i=0 ; i<this.listOffields.length ; i++){
                    //     items.push({label: this.listOffields[i].label,fieldName: this.listOffields[i].fieldPath ,type: this.listOffields[i].type});
                    // }
                    this.listOffields.map(element => {
                        //it will enter this if-block just once
                        items = [...items, { label: element.label, fieldName: element.fieldPath, type: element.type }];
                    });
                    console.log('items =====>', items);

                    const actionEvent = [
                        //{ label: 'View', name: 'View' },
                        { label: 'Edit', name: 'Edit' }
                    ];

                    this.columns2 = [...items,
                        { label: 'Action', type: 'action', typeAttributes: { rowActions: actionEvent } }
                        // {
                        //     type: 'button-icon', typeAttributes: {
                        //         iconName: 'utility:edit',
                        //         title: 'Edit',
                        //         variant: 'border-filled',
                        //         // alternativeText: 'Edit',
                        //         // disabled: false,
                        //         //label: { fieldName: 'Pnr__c' },
                        //         //name: { fieldName: 'Pnr__c' },
                        //     }
                        // },
                    ];

                    this.listOfRecord = JSON.parse(Object.values(objStr)[0]);
                    console.log('this.listOfRecord =====>', this.listOfRecord);
                    this.tabledata = this.listOfRecord;

                    this.labelContact = "Contact";
                    this.CountRecContact = this.tabledata.length;

                    this.tabledata = this.listOfRecord.slice(0, this.pagesize);

                    this.totalPage = Math.ceil(this.CountRecContact / this.pagesize);
                    console.log('------this.totalPage--------', this.totalPage);
                    
                    //api Names list for edit record pop up
                    this.ApifieldNamelist = JSON.parse(Object.values(objStr)[2]);
                    console.log('------this.ApifieldNamelist--------', this.ApifieldNamelist);
                    
                })
                .catch(error => {
                    console.log('Error Occured:- ' + error.body.message);
                });
        }
    }

    

    previousHandler() {
        //console.log('Previous clicked this.page',this.page);
        if (this.page > 1) {
            this.page = this.page - 1;
            console.log('Previous clicked this.page', this.page);
            this.displayrecordPageWise(this.page);
        }
    }

    nextHandler() {
        //console.log('next clicked this.page',this.page);
        if (this.page < this.totalPage && this.page !== this.totalPage) {
            this.page = this.page + 1;
            console.log('next clicked this.page', this.page);
            this.displayrecordPageWise(this.page);
        }
    }

    displayrecordPageWise(page) {
        this.startingRec = ((page - 1) * this.pagesize);
        this.endingRec = (this.pagesize * page);
        console.log('-----startingRec------- ', this.startingRec);
        console.log('-----endingRec------- ', this.endingRec);

        this.tabledata = this.listOfRecord.slice(this.startingRec, this.endingRec);
    }

    // pop up for edit

    handleRowAction(event){
        console.log('================ event ======>',event);
        const actionName = event.detail.action.name;
        console.log('================ actionName ======>',actionName);
        const row = event.detail.row ;
        console.log('================ row ======>',row);
        
        switch(actionName){
            case 'Edit':
                console.log('inside case edit=======>');
                this.isPopupOpen = true;
                this.conId = row.Id;
                console.log('--------------Row ID----------------',this.conId);
                break;
                default:
                    console.log('-------------default-------------');
                }
                
    }
   

    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isPopupOpen = false;
    }

    handleSubmit(event){
        event.preventDefault();       // stop the form from submitting
        const fields = event.detail.fields;
        
        console.log('---fields--',JSON.stringify(fields));  
        this.template.querySelector('lightning-record-edit-form').submit(fields);
     }


     handleSucess(event){
        const updatedRecord = event.detail.id;
        console.log('onsuccess: ', updatedRecord);
        this.saveForm();
        this.loaddata();
     }

     

    saveForm() {
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
        this.isPopupOpen = false; 
        //console.log('onsuccess event recordEditForm =====>', event.detail.row.id);
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Contact updated',
                variant: 'success'
            })
        );

        
    }
    
    get getRecordSizeList(){
        let recordSizeList = [];
        recordSizeList.push({'label':'1', 'value':'1'});
        recordSizeList.push({'label':'2', 'value':'2'});
        recordSizeList.push({'label':'3', 'value':'3'});
        recordSizeList.push({'label':'4', 'value':'4'});
        return recordSizeList;
    }

    handleRecordSizeChange(event) {
        this.pagesize = event.detail.value;
        console.log('-----recordSize-----',this.pagesize);
        this.loaddata();
        // this.pageNumber = 1;
        // this.totalPages = Math.ceil(this.totalRecords / Number(this.recordSize));
        // this.processRecords();
    }
    
    
}







// this[NavigationMixin.Navigate]({
            // updateRecord({ fields: this.contactRecord})
            //     .then(() => {
            //         this.dispatchEvent(
            //             new ShowToastEvent({
            //                 title: 'Success',
            //                 message: 'Contact updated',
            //                 variant: 'success'
            //             })
            //         );
            //     })
            //     .catch((error) => {
            //         this.dispatchEvent(
            //             new ShowToastEvent({
            //                 title: 'Error creating record',
            //                 message: error.body.message,
            //                 variant: 'error'
            //             })
            //         );
            //     });
            
            // handleFieldChange(e) {
            //     this.contactRecord[e.currentTarget.fieldName] = e.target.value;
            //     console.log('-------this.contactRecord-------',this.contactRecord);
            // }
            
            // // updateCon(){
            // //     updateContact({ con : {...this.contactRecord, sobjectType: 'Contact' }})
            // //         .then((contact) =>{
            // //             this.dispatchEvent(
            // //                 new ShowToastEvent({
            // //                     title: 'Success',
            // //                     message: 'Contact created from saveForm => ' + contact.id,
            // //                     variant: 'success'
            // //                 })
            // //             );
            // //         })
            // //         .catch((err) => console.error(err));
            // // }
            
            // handleLoad(event) {
            //     if (!this.loadedForm) {
            //         let fields = Object.values(event.detail.records)[0].fields;
            //         const recordId = Object.keys(event.detail.records)[0];
            //         this.contactRecord = {
            //             Id: recordId,
            //             ...Object.keys(fields)
            //                 .filter((field) => !!this.template.querySelector(`[field-name=${field}]`))
            //                 .reduce((total, field) => {
            //                     total[field] = fields[field].value;
            //                     return total;
            //                 }, {})
            //         };
            //         this.loadedForm = true;
            //     }
            // }
        //     type: 'standard__recordPage',
        //     attributes: {
        //         recordId: row.Id,
        //         actionName: 'edit'
        //     }
        // });