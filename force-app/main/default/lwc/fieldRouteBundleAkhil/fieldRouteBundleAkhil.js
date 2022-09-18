import { LightningElement , wire, track, api} from 'lwc';
import getOfficeLocations from '@salesforce/apex/fieldRouteclassAkhil.getOfficeLocations';


export default class FieldRouteBundleAkhil extends LightningElement {
    @api accountNameParam; 
    accountNameParam = 'Tavant';
    @track error;   //this holds errors

    @track mapMarkers = [];
    @track markersTitle = 'Tavant Technologies';
    @track zoomLevel = 4;
    /* Load address information based on accountNameParam from Controller */
    @wire(getOfficeLocations, { accountNameInitial: '$accountNameParam'})
    wiredOfficeLocations({ error, data }) {
        if (data) {            
            data.forEach(dataItem => {
                this.mapMarkers = [...this.mapMarkers ,
                    {
                        location: {
                            City: dataItem.BillingCity,
                            Country: dataItem.BillingCountry,
                        },
        
                        icon: 'custom:custom26',
                        title: dataItem.Name,
                    }                                    
                ];
              });            
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.contacts = undefined;
        }
    }
}