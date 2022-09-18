import { api, LightningElement, track } from 'lwc';
import doSumFromApex from '@salesforce/apex/HelloWorldClass.doSum';

export default class HelloWorld extends LightningElement {

    @track number1;
    @track number2;
    @track result;

    number1Change(event){
        this.number1 = event.target.value;
        console.log('-----number 1 -----',this.number1);
    }
    number2Change(event){ 
        this.number2 = event.target.value;
        console.log('-----number 2 -----',this.number2);
    }
    handleSumClick(){
        this.isresult = true;
        //this.result = parseInt(this.number1) + parseInt(this.number2);
           

        doSumFromApex({ d1: parseInt(this.number1) , d2: parseInt(this.number2)})
        .then((data) => {
            this.result = data;
        })
        .catch((error) => {
            
        });
    }

    handleBack(){
        this.result = undefined;
    }

    get isResultAvilable(){
        return this.result != undefined && this.result > 0 ? true : false;
    }

}