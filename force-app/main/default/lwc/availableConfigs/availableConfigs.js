import { LightningElement, api, track } from 'lwc';
import getAllConfigData from '@salesforce/apex/availableConfigController.getAllConfigData'; 
import backendCall from '@salesforce/apex/availableConfigController.backendCall'; 
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const column = [
    { label: 'Label', fieldName: 'Label' },
    { label: 'Type', fieldName: 'Type' },
    { label: 'Amount', fieldName: 'Amount', type: 'currency',cellAttributes: { alignment: 'left' }  }
];

export default class AvailableConfigs extends LightningElement {
    @api recordId;
    @track showSpinner = false;

    @track allConfigs = [];
    @track column = column;
    @track tabledata;
    
    // for pagination
    @track page = 1;
    @track pagesize = '5';
    @track totalPage = 0;
    @track startingRec = 1;
    @track endingRec = 0;
    @track listOfRecord = [];
    @track CountRecConfigs;
    @track updatedItemsSet = new Set();

    //Selected config Rows
    @track selectedConfigRecID = [];

    connectedCallback() {
        this.handleSpinner(true);
        //console.log('--connectedCallback4--recordId-->',this.recordId);
        this.initData();
        this.showSpinner = true;
    }

    initData(){ 
        this.handleSpinner(true);
        getAllConfigData()
            .then(result => {
                 this.allConfigs = [];
                for (let configRec of result){
                    this.allConfigs.push({ "id": configRec.Id, "Label": configRec.Label__c, "Type": configRec.Type__c, "Amount": configRec.Amount__c});
                }
                this.sortRec();
                this.handleSpinner(false);
                this.showSpinner = false;
            })
            .catch(error => {
                this.handleSpinner(false);
            });
    }

    sortRec(){
        this.tabledata = this.allConfigs;
        this.CountRecConfigs = this.tabledata.length;
        this.tabledata = this.allConfigs.slice(0, this.pagesize);
        this.totalPage = Math.ceil(this.CountRecConfigs / this.pagesize);
        if(this.page > this.totalPage){
            console.log('this.page--before--inside if--->'+this.page);
            this.page = this.totalPage;
        }
        console.log('this.totalPage--before-->'+this.totalPage);
        console.log('this.page--before-->'+this.page);
    }

    selectedConfigIdSet = new Set();
    get selectedConfigIds(){
        return Array.from(this.selectedConfigIdSet);
    }

    handleSelectionRow(event){
        try{
            console.log('JSON.parse(JSON.stringify(event.detail.selectedRows))::',JSON.parse(JSON.stringify(event.detail.selectedRows)));
            if(event?.detail?.selectedRows){
                for(let tableObj of this.tabledata){
                    this.selectedConfigIdSet.delete(tableObj.id);
                }
                for(let objSelected of JSON.parse(JSON.stringify(event.detail.selectedRows))){
                    this.selectedConfigIdSet.add(objSelected.id);
                }
            }
        }catch(error){
            console.error('Exception:',error);
        }
    }

    handleRecordSizeChange(event) {
        this.pagesize = event.detail.value;
        console.log('-----recordSize-----',this.pagesize);
        this.sortRec();
    }

    get getRecordSizeList(){
        let recordSizeList = [];
        recordSizeList.push({'label':'5', 'value':'5'});
        recordSizeList.push({'label':'10', 'value':'10'});
        recordSizeList.push({'label':'15', 'value':'15'});
        recordSizeList.push({'label':'20', 'value':'20'});
        return recordSizeList;
    }

    handleSpinner(showSpinner) {
        this.showSpinner = showSpinner;
    }

    previousHandler() {
        if (this.page > 1) {
            this.page = this.page - 1;
            console.log('Previous clicked this.page', this.page);
            this.displayrecordPageWise(this.page);
        }
    }

    nextHandler() {
        if (this.page < this.totalPage && this.page !== this.totalPage) {
            this.page = this.page + 1;
            console.log('next clicked this.page', this.page);
            this.displayrecordPageWise(this.page);
        }
    }

    displayrecordPageWise(page) {
        this.startingRec = ((page - 1) * this.pagesize);
        this.endingRec = (this.pagesize * page);
        this.tabledata = this.allConfigs.slice(this.startingRec, this.endingRec);
    }

    processSelected(){
        if(this.selectedConfigIdSet.size){
            this.showSpinner = true;
            console.log('selectedConfigIdSet::',this.selectedConfigIdSet);
            let configRec = [];
            for(let configObj of this.allConfigs){
                if(this.selectedConfigIdSet.has(configObj.id)){
                    configRec.push(configObj);
                }
            }
            console.log('configRec::',configRec);
            console.log('configRec::type::',JSON.stringify(configRec));

            backendCall({
                caseId: this.recordId, 
                selectedConfigIdsString: JSON.stringify(Array.from(this.selectedConfigIdSet))
            })
            .then(result=>{
                console.log('backendCall--result-->',result);
                if(result == 200){
                    
                    this.selectedConfigIdSet = new Set();
                    this.initData();
                    this.dispatchEvent(new CustomEvent('btnNextButtonclick', { bubbles: true , composed : true }));
                    this.showSuccessToast('Selected configuration records has been added under this case successfully');
                }
                else{
                    this.showErrorToast("Bad API request call out");
                }
            }).catch(error=>{
                console.log('Exception: ',error);
                this.showErrorToast(error?.body?.message);
            });
        }else{
            this.showInfoToast('Please select at least single record to proceed.');
        }
    }

    showInfoToast(msg) {
        const evt = new ShowToastEvent({
            title: 'Info',
            message: msg,
            variant: 'info',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }

    showSuccessToast(msg) {
        const evt = new ShowToastEvent({
            title: 'Success',
            message: msg,
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }

    showErrorToast(msg) {
        const evt = new ShowToastEvent({
            title: 'Error',
            message: msg,
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }
}