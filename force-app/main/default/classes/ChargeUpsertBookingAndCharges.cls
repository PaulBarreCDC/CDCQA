public class ChargeUpsertBookingAndCharges {
    public static void upsertCandB(List<Charge__c> chargeLst){
        List<Credits_and_Booking__c> candbList = new List<Credits_and_Booking__c>();
        
        Id gandpId = [select id from Goals_Performance__c limit 1].Id;
        
        list<Charge__c> lstChargeToUpdate = new list<Charge__c>();
        for(Charge__c c : chargeLst){
            //charge key fields are updated
            
            if(c.Update__c || c.Status_Updated__c || c.Quantity_Updated__c || c.Amount_Updated__c){
                Credits_and_Booking__c cb = new Credits_and_Booking__c();
                cb.Created_Date__c = system.now();
                cb.Type__c = 'Booking';
                cb.Quote__c = c.Parent_Quote__c;
                system.debug('Seq #: =>' + c.Sequence__c);
                cb.External_Id__c = c.Sequence__c;
                cb.Goals_Performance__c = gandpId;
                cb.Charge_Type__c = c.Type__c;
                
                if(c.Status_Updated__c ){
                    if(c.Status__c == 'Cancelled'){ //create new booking with -ve amount
                        cb.Amount__c = -1 * c.Amount__c * c.Quantity__c; //negative booking
                    }
                    else{ //create new booking with +ve amount
                        cb.Amount__c = c.Amount__c * c.Quantity__c; 
                    }
                    candbList.add(cb);
                }
                else if(c.Amount_Updated__c || c.Quantity_Updated__c ){
                    decimal previousCBAmount;
                    decimal currentCBAmount;
                    System.debug('@Developer --> c.Previous_Amount__c :' + c.Previous_Amount__c);
                    System.debug('@Developer --> c.Amount__c :' + c.Amount__c);
                    
                    System.debug('@Developer --> c.Previous_Quantity__c :' + c.Previous_Quantity__c);
                    System.debug('@Developer --> c.Amount__c :' + c.Amount__c);
                    
                    if(c.Amount_Updated__c && c.Quantity_Updated__c ){
                        previousCBAmount = c.Previous_Amount__c * c.Previous_Quantity__c;
                        currentCBAmount = c.Amount__c * c.Quantity__c;
                    }
                    else if(c.Amount_Updated__c && !c.Quantity_Updated__c ){
                        previousCBAmount = c.Previous_Amount__c * c.Quantity__c;
                        currentCBAmount = c.Amount__c * c.Quantity__c;
                    }
                    else if(!c.Amount_Updated__c && c.Quantity_Updated__c ){
                        previousCBAmount = c.Amount__c * c.Previous_Quantity__c;
                        currentCBAmount = c.Amount__c * c.Quantity__c;
                    }
                    System.debug('@Developer --> previousCBAmount :' + previousCBAmount);
                    System.debug('@Developer --> currentCBAmount :' + currentCBAmount);
                    
                    if(currentCBAmount != previousCBAmount){
                        if(currentCBAmount > previousCBAmount){
                            //incremental booking
                            cb.Amount__c = currentCBAmount - previousCBAmount;
                        }
                        else if(previousCBAmount > currentCBAmount ){
                            //negative booking
                            cb.Amount__c = -1 * (previousCBAmount - currentCBAmount);
                        }
                        candbList.add(cb);
                    }
                }
                c.Status_Updated__c = false;    
                c.Quantity_Updated__c = false;
                c.Amount_Updated__c = false;
                lstChargeToUpdate.add(c);
            }
            else { // new charge created
                if(c.Status__c != 'Cancelled'){ // it must not be cancelled
                    Credits_and_Booking__c cb = new Credits_and_Booking__c();
                    cb.Amount__c = c.Amount__c * c.Quantity__c;
                    cb.Created_Date__c = system.now();
                    cb.Type__c = 'Booking';
                    cb.Quote__c = c.Parent_Quote__c;
                    system.debug('Seq #: =>' + c.Sequence__c);
                    cb.External_Id__c = c.Sequence__c;
                    cb.Goals_Performance__c = gandpId;
                    cb.Charge_Type__c = c.Type__c;
                    candbList.add(cb);
                    c.Update__c = true;
                    lstChargeToUpdate.add(c);
                }
            }
        }
        
        if(!candbList.isEmpty()) {
            upsert candbList;
        }
        
        if(lstChargeToUpdate.size() > 0){
            update lstChargeToUpdate;
        }
    }
}