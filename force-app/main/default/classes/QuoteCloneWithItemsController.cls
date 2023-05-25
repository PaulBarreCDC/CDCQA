/*********************************************************************************
* Class Name: QuoteCloneWithItemsController
* @Modification Log   :
* Ver       Date            Author      		    Modification
* 1.0        -               ApexIT                 Initial Version
* 1.1      11-03-2021      Drew/Rohini Hathi        Service Ticket# 200994 replace by Order_Priority2__c field
*********************************************************************************/
public class QuoteCloneWithItemsController {

    //added an instance varaible for the standard controller
    private ApexPages.StandardController controller {get; set;}
     // add the instance for the variables being passed by id on the url
    private SBQQ__Quote__c po {get;set;}
    // set the id of the record that is created -- ONLY USED BY THE TEST CLASS
    public ID newRecordId {get;set;}

    // initialize the controller
    public QuoteCloneWithItemsController(ApexPages.StandardController controller) {

        //initialize the stanrdard controller
        this.controller = controller;
        // load the current record
        po = (SBQQ__Quote__c)controller.getRecord();

    }

    // method called from the VF's action attribute to clone the po
    public PageReference cloneWithItems() {

         // setup the save point for rollback
         Savepoint sp = Database.setSavepoint();
         SBQQ__Quote__c newPO;

        try {

              //copy the Quote - ONLY INCLUDE THE FIELDS YOU WANT TO CLONE
              //Service Ticket# 200994 replaced by Order_Priority2__c field
             po = [SELECT  Id, SBQQ__Account__c,  SBQQ__BillingCity__c,  SBQQ__BillingCountry__c,  SBQQ__BillingFrequency__c,  SBQQ__BillingName__c,  SBQQ__BillingPostalCode__c,
                          SBQQ__BillingState__c,  SBQQ__BillingStreet__c,  SBQQ__ContractingMethod__c,  SBQQ__CustomerDiscount__c,  SBQQ__DefaultTemplate__c,
                          SBQQ__DeliveryMethod__c,  SBQQ__DistributorDiscount__c,  SBQQ__Distributor__c,  SBQQ__DocumentStatus__c,  SBQQ__EmailTemplateId__c,  SBQQ__EndDate__c,
                          SBQQ__ExpirationDate__c,  SBQQ__FirstSegmentTermEndDate__c,  SBQQ__GenerateContractedPrice__c,  SBQQ__Introduction__c,  SBQQ__LastCalculatedOn__c,
                          SBQQ__LastSavedOn__c,  SBQQ__LineItemsGrouped__c,  SBQQ__LineItemsPrinted__c,  SBQQ__MarkupRate__c,  SBQQ__MasterContract__c,
                          SBQQ__MasterEvergreenContract__c,  SBQQ__Notes__c,  SBQQ__Opportunity2__c,  SBQQ__OrderByQuoteLineGroup__c,  SBQQ__OrderBy__c,  SBQQ__OrderGroupID__c,
                          SBQQ__Ordered__c,  SBQQ__OriginalQuote__c,  SBQQ__PaperSize__c,  SBQQ__PartnerDiscount__c,  SBQQ__Partner__c,  SBQQ__PaymentTerms__c,  SBQQ__PriceBook__c,
                          SBQQ__PricebookId__c,  SBQQ__PrimaryContact__c,  SBQQ__Primary__c,  SBQQ__QuoteLanguage__c,  SBQQ__QuoteProcessId__c,  SBQQ__QuoteTemplateId__c,
                          SBQQ__RenewalTerm__c,  SBQQ__RenewalUpliftRate__c,  SBQQ__SalesRep__c,  SBQQ__ShippingCity__c,  SBQQ__ShippingCountry__c,  SBQQ__ShippingName__c,
                          SBQQ__ShippingPostalCode__c,  SBQQ__ShippingState__c,  SBQQ__ShippingStreet__c,  SBQQ__Source__c,  SBQQ__StartDate__c,  SBQQ__Status__c,
                          SBQQ__SubscriptionTerm__c,  SBQQ__TargetCustomerAmount__c,  SBQQ__Type__c,  SBQQ__Unopened__c,  SBQQ__WatermarkShown__c,
                          Quote_Status_Code__c,  Tax_Code__c,  Delivery_Terms__c,  Purchasing_Site__c,  Wanted_Delivery_Date__c,  Order_Priority2__c,
                          Order_Type__c,  Output_Language__c,  Customer_Stat_Group__c,  Rep_Code__c,  Customer_Type__c, Currency__c,  Payment_Method__c,  Credit_Limit__c,
                          Planned_Delivery_Date__c,  Reference_Number__c,  Customer_s_PO_Number__c,  Revision__c,  Revision_Reason__c,  CO_Clause__c,  Sold_by_Representative__c,
                          Engineering_Rep_1__c,  Shipping_Instructions__c,  Ordering_Region__c,  Ordering_District__c,  Sold_By_Commission_Percent__c,
                          Destination_Rep_Commission_Percent__c,  Eng_Rep_1_Commission_Percent__c,  Eng_Rep_2_Commission_Percent__c,  Sales_Group__c,  Price_Group__c,
                          Customer_Requirements__c,  Billing_Address_Id__c,  Default_Billing_Account__c,  Company__c,  Company_B__c,  Company_C__c,  Customer_Contact__c,
                          Customer_Group__c,  Ship_Via__c,  Shipment_Type__c,  Delivery_Region__c,  Delivery_District__c,  Delivery_Market__c,  Customer_Ship_Contact_Phone_Number__c,
                          Shipment_Creation__c,  Change_Order_Comments__c,  Change_Order_Log__c,  IFS_Order_Status__c,  Quote_Product_Group__c,  Engineering_Rep_2__c,  
                          Backorder_Option__c,  Denied_Party_Screening_User__c,  Document_Class__c,  Contract_Review_Date__c,  Contract_Reviewer__c,  Terms_and_Conditions_Review__c,
                          ApprovalStatus__c,  SubmittedDate__c,  SubmittedUser__c,  Project_Coordinator__c,  Denied_Party_Screening_Date__c,  Terms_and_Conditions_Reviewer__c, 
                          Terms_and_Conditions_Review_Date__c,  Finalized_Delivery_Date__c,  Custom_T_C_Attached__c,  Proposal_Sections__c,  Show_List_Price__c,
                          Eng_Review_status__c,  Prod_planning_Status__c, Sourcing_Entity__c, Sales_Division__c, Freight_Information__c,
                          SBQQ__AdditionalDiscountAmount__c, SBQQ__AverageCustomerDiscount__c, SBQQ__AveragePartnerDiscount__c, SBQQ__DaysQuoteOpen__c, SBQQ__LineItemCount__c,
                          SBQQ__ListAmount__c, SBQQ__NetAmount__c, SBQQ__RegularAmount__c,  SBQQ__TotalCustomerDiscountAmount__c, SBQQ__Uncalculated__c, Brand__c, External_Id__c,
                          Order_Number__c, Priority__c, Status_Code__c,Change_Order_No__c 
                   FROM SBQQ__Quote__c
                   WHERE id = :po.id];
             newPO = po.clone(false);
            if(newPO.Change_Order_No__c == null)
            {
                newPO.Change_Order_No__c = 1;
                newPO.Revision__c = 1;
            }
            else
            {
                newPO.Change_Order_No__c = newPO.Change_Order_No__c+1;
                newPO.Revision__c = newPO.Change_Order_No__c+1;
            }
             insert newPO;
                System.debug(newPO);
             // set the id of the new po created for testing
               newRecordId = newPO.id;

             // copy over the line items - ONLY INCLUDE THE FIELDS YOU WANT TO CLONE
             List<SBQQ__QuoteLine__c> items = new List<SBQQ__QuoteLine__c>();
             for (SBQQ__QuoteLine__c pi : [ SELECT  Id,  SBQQ__Quote__c,  SBQQ__AdditionalDiscountAmount__c,  
                                           SBQQ__AdditionalDiscount__c,  SBQQ__AdditionalQuantity__c,  
                                           SBQQ__AllowAssetRefund__c,  SBQQ__BatchQuantity__c,  SBQQ__BillingFrequency__c,
                                           SBQQ__BillingType__c,  SBQQ__BlockPrice__c,  SBQQ__Bundle__c,  SBQQ__BundledQuantity__c,  
                                           SBQQ__Bundled__c,  SBQQ__CarryoverLine__c,  SBQQ__ChargeType__c,  SBQQ__ComponentCost__c,  
                                           SBQQ__ComponentDiscountedByPackage__c,  SBQQ__ComponentListTotal__c,  SBQQ__ComponentSubscriptionScope__c, 
                                           SBQQ__ComponentTotal__c,  SBQQ__ComponentUpliftedByPackage__c,  SBQQ__ComponentVisibility__c,  
                                           SBQQ__CompoundDiscountRate__c,  SBQQ__ConfigurationRequired__c,  SBQQ__ContractedPrice__c,  SBQQ__CostEditable__c, 
                                           SBQQ__Cost__c,  SBQQ__CustomerPrice__c,  SBQQ__CustomerTotal__c,  SBQQ__DefaultSubscriptionTerm__c,  
                                           SBQQ__Description__c,  SBQQ__Dimension__c,  SBQQ__DiscountScheduleType__c,  SBQQ__DiscountSchedule__c, 
                                           SBQQ__DiscountTier__c,  SBQQ__Discount__c,  SBQQ__DistributorDiscount__c,  SBQQ__DynamicOptionId__c, 
                                           SBQQ__EffectiveEndDate__c,  SBQQ__EffectiveQuantity__c,  SBQQ__EffectiveStartDate__c,  SBQQ__EffectiveSubscriptionTerm__c,  
                                           SBQQ__EndDate__c,  SBQQ__Existing__c,  SBQQ__Favorite__c,  SBQQ__GenerateContractedPrice__c,  SBQQ__GrossProfit__c,  SBQQ__Group__c, 
                                           SBQQ__Guidance__c,  SBQQ__HasConsumptionSchedule__c,  SBQQ__Hidden__c,  SBQQ__Incomplete__c,  SBQQ__ListPrice__c,  SBQQ__ListTotal__c,  
                                           SBQQ__MarkupAmount__c,  SBQQ__MarkupRate__c,  SBQQ__Markup__c,  SBQQ__MaximumPrice__c,  SBQQ__MinimumPrice__c,  
                                           SBQQ__NetPrice__c,  SBQQ__NetTotal__c,  SBQQ__NonDiscountable__c,  SBQQ__NonPartnerDiscountable__c,  SBQQ__Number__c,  
                                           SBQQ__OptionDiscountAmount__c,  SBQQ__OptionDiscount__c,  SBQQ__OptionLevel__c,  SBQQ__OptionType__c,  SBQQ__Optional__c,
                                           SBQQ__OriginalPrice__c,  SBQQ__OriginalQuoteLineId__c,  SBQQ__OriginalUnitCost__c,  SBQQ__PackageCost__c,  SBQQ__PackageListTotal__c,  
                                           SBQQ__PackageProductCode__c,  SBQQ__PackageProductDescription__c,  SBQQ__PackageTotal__c,  SBQQ__PartnerDiscount__c,  SBQQ__PartnerPrice__c,  
                                           SBQQ__PartnerTotal__c,  SBQQ__PreviousSegmentPrice__c,  SBQQ__PreviousSegmentUplift__c,  SBQQ__PriceEditable__c,  SBQQ__PricebookEntryId__c,  
                                           SBQQ__PricingMethodEditable__c,  SBQQ__PricingMethod__c,  SBQQ__PriorQuantity__c,  SBQQ__ProductCode__c,  SBQQ__ProductFamily__c,  SBQQ__ProductName__c, 
                                           SBQQ__ProductOption__c,  SBQQ__ProductSubscriptionType__c,  SBQQ__Product__c,  SBQQ__ProrateMultiplier__c,  SBQQ__ProratedListPrice__c,  SBQQ__ProratedPrice__c, 
                                           SBQQ__Quantity__c,  SBQQ__RegularPrice__c,  SBQQ__RegularTotal__c,  SBQQ__Renewal__c,  SBQQ__RenewedAsset__c,  SBQQ__RenewedSubscription__c,  SBQQ__RequiredBy__c, 
                                           SBQQ__SegmentIndex__c,  SBQQ__SegmentKey__c,  SBQQ__SegmentLabel__c,  SBQQ__Source__c,  SBQQ__SpecialPriceDescription__c,  SBQQ__SpecialPriceType__c, 
                                           SBQQ__SpecialPrice__c,  SBQQ__StartDate__c,  SBQQ__SubscribedAssetIds__c,  SBQQ__SubscriptionBase__c,  SBQQ__SubscriptionCategory__c, 
                                           SBQQ__SubscriptionPercent__c,  SBQQ__SubscriptionPricing__c,  SBQQ__SubscriptionScope__c,  SBQQ__SubscriptionTargetPrice__c,  SBQQ__SubscriptionTerm__c, 
                                           SBQQ__SubscriptionType__c,  SBQQ__TaxCode__c,  SBQQ__Taxable__c,  SBQQ__TermDiscountSchedule__c,  SBQQ__TermDiscountTier__c,  SBQQ__TermDiscount__c, 
                                           SBQQ__TotalDiscountAmount__c,  SBQQ__TotalDiscountRate__c,  SBQQ__UnitCost__c,  SBQQ__UnproratedNetPrice__c,  SBQQ__UpgradedAsset__c,  SBQQ__UpgradedQuantity__c, 
                                           SBQQ__UpgradedSubscription__c,  SBQQ__UpliftAmount__c,  SBQQ__Uplift__c,  SBQQ__VolumeDiscount__c,  Pressure_Setting__c,  Converted_Pressure_Setting__c, 
                                           Engineering_Notes__c,  Priority__c,  /*QLDiscount__c,  */Approval_Status__c,  Submitted_Date__c,  Submitted_User__c,  Leadtime__c,  Planned_Delivery_Date__c, 
                                           Wanted_Delivery_Date__c,  Vendor__c,  Shipment_Creation__c,  Tag_Number__c,  Milestone_Template_Id__c,  Additional_Discount_Type__c, 
                                           Requires_Technical_Review__c, Technical_Review_Comments__c,  Sourcing_Restrictions__c,  Calculated_Delivery_Date__c,
                                           Discountable_List_Price__c,  Non_Discountable_List_Price__c, Current_Revision__c,  Lot_Tracking__c,  Provide_Code__c,  Inventory_Serial_Tracking__c,
                                           Document_Revision__c,  Part_Class__c, Responsible_User__c,  Parts_Managed_In__c,  Document_References__c,  Sourcing_Options__c,  HSN_SAC_Code__c,
                                           Primary_Vendor__c,  Part_Catalog_Group__c, QuoteLineNumber__c,  Tracking_No__c,  Ship_Via__c
                                           FROM SBQQ__QuoteLine__c where SBQQ__Quote__c = :po.id]) {
                  SBQQ__QuoteLine__c newPI = pi.clone(false);
                  items.add(newPI);
             }
             insert items;

         } catch (Exception e){
             // roll everything back in case of error
            Database.rollback(sp);
             System.debug('Error:'+e);
            ApexPages.addMessages(e);
            return null;
         }

        return new PageReference('/'+newPO.id);
    }

}