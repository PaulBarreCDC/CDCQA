public with sharing class ApprovalsUtil {
 
  
  public static DiscThresholds getThresholds(String brand, String repCode) {
    if(brandRepCodeDiscThresholds.containsKey(brand + repCode)) {
      return brandRepCodeDiscThresholds.get(brand + repCode);
    } else if(brandRepCodeDiscThresholds.containsKey(brand)) {
      return brandRepCodeDiscThresholds.get(brand);
    } else {
      return brandRepCodeDiscThresholds.get('DEFAULT');
    }
  }

  //  Selects Based Off Of Brand + RepCode
  public static Map<String, DiscThresholds> brandRepCodeDiscThresholds = new Map<String, DiscThresholds> {
    'DEFAULT' => new DiscThresholds(15,40,50),// Default value
    'CDCD01' => new DiscThresholds(15,40,50), // Example value of brand + repCode as key
    'CDC' => new DiscThresholds(15,40,50)     // Example value of brand as key
  };

  public class DiscThresholds {
    public Decimal insideSales {get;set;}
    public Decimal director {get;set;}
    public Decimal salesExec {get;set;}

    public DiscThresholds(
      Decimal insideSales,  
      Decimal director,
      Decimal salesExec) {
        this.insideSales = insideSales;
        this.director = director;
        this.salesExec = salesExec;
    }
  }
}