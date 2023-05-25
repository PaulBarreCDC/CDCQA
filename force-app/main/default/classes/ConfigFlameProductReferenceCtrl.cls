/**
* @File Name          : ConfigFlameProductReferenceCtrl.cls
* @Description        :
* @Author             : Vikram Natikar
* @Group              :
* @Last Modified By   : Vikram Natikar
* @Last Modified On   : 04/11/2020
* @Modification Log   :
* Ver       Date            Author      		    Modification
* 1.0    06/09/2020      Vikram Natikar     	  Initial Version
**/

public class ConfigFlameProductReferenceCtrl {
    public Flame_Product__c oFA{get;set;}
    public User oUser {get;set;}
    public string getUserTimeZone(){
        return userinfo.getTimeZone().toString();
    }
    
    public ConfigFlameProductReferenceCtrl(ApexPages.StandardController controller){
        if(!Test.isRunningTest())
        {
        controller.addFields(new String[]{'Drilling__c','Body_Material__c','Housing_Material__c','Element_Material__c','Pallet_Material__c','Diaphragm_Material__c','Pressure_Setting__c','Spring_Range__c','Painting_Coating_Option__c','Inlet_Option_A__c','Inlet_Option_B__c','Inlet_Option_C__c','Outlet_Option_A__c','Outlet_Option_B__c','Outlet_Option_C__c','Radiography__c','Liquid_Dye_Penetrant__c','Positive_Material_Identification__c','Final_Assembly_Location_Requirements__c','Material_Sourcing_Requirements__c','PTC__c','Constrain_Product_Selection_by_Flow__c','Mounting__c','Arrester_for_Detonation_or_Deflagration__c'});
        }
            oFA = (Flame_Product__c)controller.getRecord();    
        	for(User u : [Select Id,Name From User Where Id =: userinfo.getUserId()]){
            	oUser = u;
        }
   }

    Public boolean Radiography{ 
        get{
            Map<String, Object> parameters = new Map<String, Object>();

        List<FA_EXMOPTC_Cons__c> pmiList = [Select Radiography__c from FA_EXMOPTC_Cons__c where Radiography__c = 'Y' AND (PTC__c =:oFA.PTC__c)];
        system.debug('pmiList**'+pmiList );
        if(pmiList.size() > 0){
            parameters.put('sObjects',(new List<String>{'FA_Input_Attr_Value_Desc__c'}));
            parameters.put('FA_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
            parameters.put('FA_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'XRAY\'');
            parameters.put('FA_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');

            Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
            List<FA_Input_Attr_Value_Desc__c> inputAttrValue = (List<FA_Input_Attr_Value_Desc__c>)processedData.get('FA_Input_Attr_Value_Desc__c');
            //System.debug('&&& inputAttrValue = '+inputAttrValue);
            if(inputAttrValue != null && inputAttrValue.size() > 0)           
                return true;    
            else
                return false;
                }
            else 
                return false;            
        }
        set{
            this.Radiography=value;
        }
    }
 
    	
    public string SZC{
        get{
				string labelval='';
            	labelval=fetchInputAttributeDesc('SZC',oFA.Size__c);
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.SZC=value;
        }
    }
	
    public string ESZC{
        get{
				string labelval='';
            	labelval=fetchInputAttributeDesc('ESZC',oFA.Element_Size__c);
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.ESZC=value;
        }
    }
        
	public string ReqdGasGroupLevel{
        get{
				//string labelval='';
            	string labelval=fetchInputAttributeDesc('ReqdGasGroupLevel',oFA.Gas_Group__c);
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.ReqdGasGroupLevel=value;
        }
    }
        
	public string HCLASS{
        get{
				string labelval='';
            	labelval=fetchInputAttributeDesc('HCLASS',oFA.Drilling__c);
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.HCLASS=value;
        }
    }
        
	public string MCBODY{
        get{
				string labelval='';
            	labelval=fetchInputAttributeDesc('MCBODY',oFA.Body_Material__c);
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.MCBODY=value;
        }
    }
        
	public string MCHOUS{
        get{
				string labelval='';
            	labelval=fetchInputAttributeDesc('MCHOUS',oFA.Housing_Material__c);
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.MCHOUS=value;
        }
    }
        
	public string MCELMT{	
        get{
				string labelval='';
            	labelval=fetchInputAttributeDesc('MCELMT',oFA.Element_Material__c);
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.MCELMT=value;
        }
    }
        
	public string MCPALL{
        get{
				string labelval='';
            	if(oFA.PTC__c=='8400A'){
                    labelval=fetchInputAttributeDesc('MCPALL',oFA.Pallet_Material__c);
                }            	
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.MCPALL=value;
        }
    }
        
	public string MCDPHM{
        get{
				string labelval='';
            	if(oFA.PTC__c=='8400A'){
            		labelval=fetchInputAttributeDesc('MCDPHM',oFA.Diaphragm_Material__c);
            	}
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.MCDPHM=value;
        }
    }
        
	public string SETTING{
        get{
				string labelval='';
            	if(oFA.PTC__c=='8400A'){
            		labelval=fetchInputAttributeDesc('SETTING',oFA.Pressure_Setting__c);
                }
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.SETTING=value;
        }
    }
        
	public string SPRING{
        get{
				string labelval='';
            	if(oFA.PTC__c=='8400A'){
            		labelval=fetchInputAttributeDesc('SPRING',oFA.Spring_Range__c);
                }
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.SPRING=value;
        }
    }
        
	public string GPAINT{
        get{
				string labelval='';
            	labelval=fetchInputAttributeDesc('GPAINT',oFA.Painting_Coating_Option__c);
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.GPAINT=value;
        }
    }
        
	public string InletA{
        get{
				string labelval='';
            	labelval=fetchInputAttributeDesc('PORTOPTIONCODE',oFA.Inlet_Option_A__c);
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.InletA=value;
        }
    }
        
	public string InletB{
        get{
				string labelval='';
            	labelval=fetchInputAttributeDesc('PORTOPTIONCODE',oFA.Inlet_Option_B__c);
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.InletB=value;
        }
    }
        
	public string InletC{
        get{
				string labelval='';
            	labelval=fetchInputAttributeDesc('PORTOPTIONCODE',oFA.Inlet_Option_C__c);
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.InletC=value;
        }
    }
        
	public string OutletA{
        get{
				string labelval='';
            	labelval=fetchInputAttributeDesc('PORTOPTIONCODE',oFA.Outlet_Option_A__c);
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.OutletA=value;
        }
    }
        
	public string OutletB{
        get{
				string labelval='';
            	labelval=fetchInputAttributeDesc('PORTOPTIONCODE',oFA.Outlet_Option_B__c);
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.OutletB=value;
        }
    }
        
	public string OutletC{
        get{
				string labelval='';
            	labelval=fetchInputAttributeDesc('PORTOPTIONCODE',oFA.Outlet_Option_C__c);
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.OutletC=value;
        }
    }
        
	public string XRAY{
        get{
				string labelval='';
            	labelval=fetchInputAttributeDesc('XRAY',oFA.Radiography__c);
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.XRAY=value;
        }
    }
        
	public string LDP{
        get{
				string labelval='';
            	labelval=fetchInputAttributeDesc('LDP',oFA.Liquid_Dye_Penetrant__c);
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.LDP=value;
        }
    }
        
	public string PMI{
        get{
				string labelval='';
            	labelval=fetchInputAttributeDesc('PMI',oFA.Positive_Material_Identification__c);
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.PMI=value;
        }
    }
        
	public string ASSYLOCATION{
        get{
				string labelval='';
            	labelval=fetchInputAttributeDesc('ASSYLOCATION',oFA.Final_Assembly_Location_Requirements__c);
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.ASSYLOCATION=value;
        }
    }
        
	public string MATLSOURCE{
        get{
				string labelval='';
            	labelval=fetchInputAttributeDesc('MATLSOURCE',oFA.Material_Sourcing_Requirements__c);
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.MATLSOURCE=value;
        }
    }
   
     private string fetchInputAttributeDesc(string att, string sVal){

        List<FA_Input_Attr_Value_Desc__c > inputvaluesList=[select id,Text_Description_of_AttributeValue__c,Attribute__c,Value__c
                                                            from FA_Input_Attr_Value_Desc__c
                                                            where Attribute__c = : att 
                                                            and value__c = : sVal LIMIT 1
                                                            ];
        return  inputvaluesList[0].Text_Description_of_AttributeValue__c;

    }
    
}