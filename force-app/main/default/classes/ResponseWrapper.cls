/**
 * Purpose: This class is for sending responses to Lightning(Aura) Components
 */
public class ResponseWrapper {
    @AuraEnabled
    public String status {get;set;}
    @AuraEnabled
    public String message {get;set;}
    @AuraEnabled
    public Object value {get;set;}

    public ResponseWrapper() {
      this('','',null);
    }
    public ResponseWrapper(String status, String message, Object value) {
      this.status = status;
      this.message = message;
      this.value = value;
    }
  }