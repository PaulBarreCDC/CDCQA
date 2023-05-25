/**
 *
 * @author Kevin Fleck - Coastal Cloud
 * kevin.fleck@coastalcloud.us
 *
 */
@IsTest
public without sharing class CCTestUtils {

    public static Account createAccount(String name, Boolean doInsert) {
        Account obj = new Account();
        obj.Name = name;

        if(doInsert) {
            insert obj;
        }

        return obj;
    }

    public static Opportunity createOpportunity(Account testAccount, Boolean doInsert){
        Opportunity obj = new Opportunity();
        obj.Name = testAccount.Name + ' test opportunity';
        obj.StageName = 'Discovery/Identified';
        obj.AccountId = testAccount.Id;
        obj.Amount = 0;
        obj.Brand__c = 'CDC';
        obj.CloseDate = Date.Today().addDays(30);
        // Customer_Contact__c = sizingRequest.cdcpc__ContactId__c,
        obj.Customer_Currency__c = 'USD';
        obj.EPC_Firm_Involved__c = 'No';
        obj.End_Use_Application__c = 'Test';
        obj.End_User__c = testAccount.Id;
        obj.Is_it_a_project__c = 'No';
        // PartnerAccountId = sizingRequestToContactMap.get(sizingRequest.cdcpc__ContactId__c).Account.Rep_Code_Account__c,
        obj.Shipping_Account__c = testAccount.Id;
        obj.Type = 'Test';

        if(doInsert){
            insert obj;
        }
        return obj;
    }

    public static Contact createContact(Account acc, Boolean doInsert) {

        Contact testContact = new Contact(
            FirstName = 'test',
            LastName = 'contact',
            AccountId = acc != null ? acc.Id : null,
            Email = 'fullname@domain.com'
        );

        if(doInsert) {
            insert testContact;
        }
        return testContact;
    }

    public static Product2 createProduct(String name, String productCode, Boolean doInsert) {
        Product2 obj = (Product2)Product2.sObjectType.newSObject(
            null, // null will make it the default record type for the user
            true // loadDefaultValues
        );
        obj.Name = name;
        obj.IsActive = true;
        obj.ProductCode = productCode;
        obj.IsActive = true;



        if(doInsert) {
            insert obj;
        }

        return obj;
    }

    public static SBQQ__Quote__c createQuote(Account acct, Opportunity opp, Boolean isPrimary, Boolean populateDefaultValues, Boolean doInsert) {
        SBQQ__Quote__c obj = (SBQQ__Quote__c)SBQQ__Quote__c.sObjectType.newSObject(
            null, // null will make it the default record type for the user
            true // loadDefaultValues
        );
        obj.SBQQ__Primary__c = isPrimary;
        obj.SBQQ__StartDate__c = Date.today();
        //obj.SBQQ__EndDate__c = Date.today().addMonths(1);
        obj.SBQQ__Opportunity2__c = opp == null ? null : opp.Id;
        obj.SBQQ__SubscriptionTerm__c = 12;
        obj.SBQQ__ExpirationDate__c = Date.today() + 30;
        obj.SBQQ__Account__c = acct == null ? null : acct.Id;
        obj.SBQQ__Type__c = 'Quote';

        if(doInsert) {
            insert obj;
        }
        return obj;
    }

    public static SBQQ__QuoteLine__c createQuoteLine(Product2 product, PriceBookEntry pbe, SBQQ__Quote__c quote, Boolean populateDefaultValues, Boolean doInsert) {
        SBQQ__QuoteLine__c obj = (SBQQ__QuoteLine__c)SBQQ__QuoteLine__c.sObjectType.newSObject(
            null, // null will make it the default record type for the user
            populateDefaultValues // loadDefaultValues
        );
        obj.SBQQ__Product__c = product.Id;
        obj.SBQQ__Quote__c = quote.Id;
        obj.SBQQ__PricebookEntryId__c = pbe == null ? null : pbe.Id;
        obj.SBQQ__PricingMethod__c = 'List';
        obj.SBQQ__StartDate__c = Date.today();
        obj.SBQQ__ListPrice__c = 100;
        obj.SBQQ__Quantity__c = 1;
        obj.SBQQ__PriorQuantity__c = 0;
        obj.SBQQ__RegularPrice__c = 100;
        obj.SBQQ__NetPrice__c = 100;
        obj.SBQQ__Number__c = 1;
        obj.SBQQ__ProrateMultiplier__c = 1;
        obj.SBQQ__SubscriptionPricing__c = 'Fixed Price';
        obj.SBQQ__SubscriptionScope__c = 'Quote';
        obj.SBQQ__DefaultSubscriptionTerm__c = 1;
        obj.SBQQ__ChargeType__c = product.SBQQ__ChargeType__c;
        obj.SBQQ__BillingType__c = product.SBQQ__BillingType__c;
        obj.SBQQ__BillingFrequency__c = product.SBQQ__BillingFrequency__c;

        if(doInsert) {
            insert obj;
        }
        return obj;
    }

    public static User createTestUser(Contact contact, Boolean doInsert){
        Profile communityProfile = [SELECT Id FROM Profile WHERE Name = 'CDC Public Community User' LIMIT 1];
        User obj = new User();
        obj.FirstName = contact.firstName;
        obj.LastName = contact.lastName;
        obj.Email = contact.email;
        obj.UserName = contact.email;
        obj.ContactId = contact.Id;
        obj.ProfileId = communityProfile.Id;
        obj.TimeZoneSidKey = 'America/Chicago'; 
        obj.LocaleSidKey = 'en_US'; 
        obj.EmailEncodingKey = 'ISO-8859-1'; 
        obj.LanguageLocaleKey = 'en_US';
        obj.Alias ='tstUsr';

        if(doInsert) {
            insert obj;
        }

        return obj;

    }

    public static User createAdminUser(Boolean doInsert){ // created to run certain tests as admin, where needed.
        Profile communityProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        UserRole testRole = [SELECT Id FROM UserRole WHERE Name = 'Application Engineer' LIMIT 1];
        User obj = new User();
        obj.FirstName = 'admin';
        obj.LastName = 'user';
        obj.Email = 'admin@user.com';
        obj.UserName = 'admin@cdcusertest147.com';
        obj.UserRoleId = testRole.Id;
        obj.ProfileId = communityProfile.Id;
        obj.TimeZoneSidKey = 'America/Chicago'; 
        obj.LocaleSidKey = 'en_US'; 
        obj.EmailEncodingKey = 'ISO-8859-1'; 
        obj.LanguageLocaleKey = 'en_US';
        obj.Alias ='tstUsr';

        if(doInsert) {
            insert obj;
        }

        return obj;

    }
    
    // public static Order createOrder(Account account, Pricebook2 pricebook, Boolean doInsert) {
    //         Order obj = new Order();
    //         obj.AccountId = account.Id;
    //         obj.BillingCity = 'Gainesville';
    //         obj.BillingCountry = 'United States';
    //         obj.BillingPostalCode = '32107';
    //         obj.BillingState = 'Florida';
    //         obj.BillingStreet = '4600 E University Avenue';
    //         obj.EffectiveDate = Date.today();
    //         obj.Pricebook2Id = priceBook == null ? Test.getStandardPricebookId() : priceBook.Id;
    //         obj.ShippingCity = 'Gainesville';
    //         obj.ShippingCountry = 'United States';
    //         obj.ShippingPostalCode = '32107';
    //         obj.ShippingState = 'Florida';
    //         obj.ShippingStreet = '1000 Archer Road';
    //         obj.Status = 'Draft';
    //         obj.Type = 'OR';
        
    //         if(doInsert){ 
    //             insert obj;
    //         }

    //         return obj;
    // }

    // public static OrderItem createOrderItem(Order order, Product2 product, PricebookEntry pricebookEntry, Boolean doInsert){
    //     OrderItem obj = new OrderItem();
    //     obj.OrderId = order.Id;
    //     obj.Product2Id = product.Id;
    //     obj.PricebookEntryId = pricebookEntry.Id;
    //     obj.ListPrice = pricebookEntry.UnitPrice;
    //     obj.UnitPrice = 123;
    //     obj.Quantity = 3;
    //     obj.Type = 'Order Product';

    //     if(doInsert){ 
    //         insert obj;
    //     }

    //     return obj;
    // }
    
}