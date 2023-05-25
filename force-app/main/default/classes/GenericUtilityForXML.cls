/**
 * @File Name          : GenericUtilityForXML.cls
 * @Description        : 
 * @Author             : Nikhil Arpally
 * @Group              : 
 * @Last Modified By   : Nikhil Arpally
 * @Last Modified On   : 3/6/2020, 9:13:07 pm
 * @Modification Log   : 
 * Ver       Date            Author                 Modification
 * 1.0    3/6/2020   Nikhil Arpally     Initial Version
**/
public class GenericUtilityForXML {
    // public GenericUtilityForXML(String prodCode,id recId) {
    //     recordId=recId;
    //     pdCode=prodCode;
    // }
    // public id recordId{set;get;}
    // public string pdCode{set;get;}
    // public result resEngineeringPartsXML {set;get;}
    // public result resInventoryPartXML {set;get;}
    // public result resSalesPartsXML {set;get;}
    // public result resPurchasePartSuppliersXML {set;get;}
    // public result resStructureXML {set;get;}
    // public result resRoutingXML {set;get;}
    // public result resControlPlanXML {set;get;}
    // public result resProductCatalogXML {set;get;}
    // public result getGetXMLData() {
    //     result populateXML=new result();
    //     try {
    //         if(pdCode=='BGR') {
    //             BGROutputUtility bgrIns=new BGROutputUtility(recordId);
    //             resEngineeringPartsXML=bgrIns.getEngineeringParts();
    //             resInventoryPartXML=bgrIns.getInventoryPartDetails();
    //             resPurchasePartSuppliersXML=bgrIns.getPurchasePartSuppliers();
    //             resSalesPartsXML=bgrIns.getSalesParts();
    //             resStructureXML=bgrIns.getStructureXML();
    //             resRoutingXML=bgrIns.GetRoutingDetails();
    //             resControlPlanXML=bgrIns.GetControlPlanDetails();
    //             resProductCatalogXML=bgrIns.getProductCatalog();
    //         } else if (pdCode=='WGB') {
    //             WGBOutputUtility wbc=new WGBOutputUtility(recordId);
    //             resEngineeringPartsXML=wbc.getEngineeringParts();
    //             resInventoryPartXML=wbc.getInventoryPartDetails();
    //             resPurchasePartSuppliersXML=wbc.getPurchasePartSuppliers();
    //             resSalesPartsXML=wbc.getSalesParts();
    //             resStructureXML=wbc.getStructureXML();
    //             resRoutingXML=wbc.GetRoutingDetails();
    //             resControlPlanXML=wbc.GetControlPlanDetails();
    //             resProductCatalogXML=wbc.getProductCatalog();
    //         }
    //         System.debug('Generic Class Result resEngineeringPartsXML: ' + resEngineeringPartsXML);
    //        // System.debug('Generic Class Result resEngineeringPartsXML: ' + resEngineeringPartsXML);
    //         System.debug('Generic Class Result strInventoryPartXML: ' + resInventoryPartXML);
    //         System.debug('Generic Class Result strPurchasePartSuppliersXML: ' + resPurchasePartSuppliersXML);
    //         System.debug('Generic Class Result strSalesPartsXML: ' + resSalesPartsXML);
    //         System.debug('Generic Class Result strStructureXML: ' + resStructureXML);
    //         System.debug('Generic Class Result strRoutingXML: ' + resRoutingXML);
    //         System.debug('Generic Class Result strControlPlanXML: ' + resControlPlanXML);
    //         System.debug('Generic Class Result strProductCatalogXML: ' + resProductCatalogXML);
    //     } catch (Exception e) {
            
    //     }
    //     return populateXML;
    // }
    public HandlerInterface getUtilityInstance(String shapeType,id recordId) { 
        if(shapeType=='BGR') {
            return new BGROutputUtility(recordId);
        } else if (shapeType=='WGB') {
            return new WGBOutputUtility(recordId);
        }else if (shapeType=='RLFVLV') {
            return new RVOutputUtilityXML(recordId);
        }
        else if (shapeType=='RD') {
            return new RDOutputUtilityXML(recordId);
        }else if (shapeType=='HLD') {
            return new HLDOutputUtilityXML(recordId);
        }else if (shapeType=='PS') {
            return new PSOutputUtilityXML(recordId);
        }else if (shapeType=='FlameProducts') {
            return new FAOutputUtilityXML(recordId);
        } else {
            return null;
        }
    }
}