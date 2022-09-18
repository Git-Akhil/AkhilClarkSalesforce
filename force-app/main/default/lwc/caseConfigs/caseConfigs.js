import { LightningElement, api, track } from 'lwc';
import getAllCaseConfigData from '@salesforce/apex/availableConfigController.getAllCaseConfigData'; 

const column = [
    { label: 'Label', fieldName: 'Label' },
    { label: 'Type', fieldName: 'Type' },
    { label: 'Amount', fieldName: 'Amount', type: 'currency',cellAttributes: { alignment: 'left' }   }
];

export default class CaseConfigs extends LightningElement {
    constructor(){
        super();
        window.addEventListener('btnNextButtonclick', this.handleAddNewCaseConfig.bind(this));
    }

    @api recordId;
    @track showSpinner = false;

    @track allCaseConfigs = [];
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

    connectedCallback() {
        this.handleSpinner(true);
        console.log('CaseConfig--connectedCallback--recordId-->',this.recordId);
        this.initData();
    }

    initData(){ 
        console.log('---initData--called---');
        this.handleSpinner(true);
        getAllCaseConfigData({recordId: this.recordId})
            .then(result => {
                console.log('CaseConfig--getAllCaseConfigData--result-->',result);
                this.allCaseConfigs = [];
                for (let caseConfig of result){
                    this.allCaseConfigs.push({ "id": caseConfig.Id, "Label": caseConfig.Label__c, "Type": caseConfig.Type__c, "Amount": caseConfig.Amount__c});
                }
                console.log('CaseConfig--this.allCaseConfigs---->',this.allCaseConfigs);
                this.sortRec();
                this.handleSpinner(false);
            })
            .catch(error => {
                this.handleSpinner(false);
            });
    }

    handleAddNewCaseConfig(event){
        console.log('handleAddNewCaseConfig--event called---->');
        this.initData();
    }

    sortRec(){
        this.tabledata = this.allCaseConfigs;
        this.CountRecConfigs = this.tabledata.length;
        this.tabledata = this.allCaseConfigs.slice(0, this.pagesize);
        this.totalPage = Math.ceil(this.CountRecConfigs / this.pagesize);
        if(this.page > this.totalPage){
            console.log('this.page--before--inside if--->'+this.page);
            this.page = this.totalPage;
        }
        console.log('this.totalPage--before-->'+this.totalPage);
        console.log('this.page--before-->'+this.page);
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

    // invoked for all the async operations
    handleSpinner(showSpinner) {
        this.showSpinner = showSpinner;
    }

    // for pagination
    previousHandler() {

        if (this.page > 1) {
            this.page = this.page - 1;
            console.log('Previous clicked this.page', this.page);
            this.displayrecordPageWise(this.page);
        }
    }

    // for pagination
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
        console.log('-----startingRec------- ', this.startingRec);
        console.log('-----endingRec------- ', this.endingRec);

        this.tabledata = this.allCaseConfigs.slice(this.startingRec, this.endingRec);
    }
}