public class configRVReferenceCtrl 
{
    public Relief_Valve__c oRV{get;set;}
    public User oUser {get;set;}
    public string getUserTimeZone()
    {
        return userinfo.getTimeZone().toString();
    }
    
    public configRVReferenceCtrl(ApexPages.StandardController controller)
    {
        if (!Test.isRunningTest()) { 
        controller.addFields(new String[]{'Drilling__c','Body_Material__c','Facing__c','Seat_Material__c','Pressure_Pallet_Material__c','Pallet_Type__c','Diaphragm_Material__c','Vacuum_Pallet_Material__c',
            'Pilot_Soft_Goods_Material__c','Weight_Material__c','Spring_Material__c','Fastener_Material__c','Steam_Jacket_Material__c','Painting_Coating_Option__c',
            'Body_Coating_Material__c','Pallet_Fastener_Coating_Material__c','Element_Material__c','Flame_Arrester_Option__c','Vacuum_Port_Option__c','Pressure_Port_Proximity_Sensor__c',
            'Vacuum_Port_Proximity_Sensor__c','Pilot_Action__c','Manual_Blowdown__c','Remote_Sense__c',
            'Pilot_Exhaust_Piped_to_Discharge_Header__c','Field_Test_Connection__c','Pilot_Supply_Filter__c',
            'Method21_Leak_Detection__c','Radiography__c','Fillet_Weld_Liquid_Dye_Penetrant__c','Liquid_Dye_Penetrant__c',
            'Positive_Material_Identification__c','Ultrasonic_Examination__c','Magnetic_Particle_Examination__c',
            'Brinell_hardness_examination__c','Charpy_Impact_Testing__c','Visual_Casting_Examination__c','Intergranular_Corossion_Test__c',
            'Constraint_Product_Selection_By_Flow__c'});
        }
        oRV = (Relief_Valve__c)controller.getRecord();    
        for(User u : [Select Id,Name From User Where Id =: userinfo.getUserId()]){
            oUser = u;
        }
    }
    
     private string fetchInputAttributeDesc(string att, string sVal)
     {
         List<RV_Input_Attr_Value_Desc__c > inputvaluesList=[select id,Text_Description_of_AttributeValue__c,Attribute__c,Value__c
                                                             from RV_Input_Attr_Value_Desc__c
                                                             where Attribute__c = : att 
                                                             and value__c = : sVal LIMIT 1
                                                            ];
         if(inputvaluesList.size() > 0)
         {
             return  inputvaluesList[0].Text_Description_of_AttributeValue__c;
         }
         else
         {
             return null;
         }
     }
    
    public string HCLASS{
        get{
				string labelval='';
            	labelval=fetchInputAttributeDesc('HCLASS',oRV.Drilling__c);
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
            	labelval=fetchInputAttributeDesc('MCBODY',oRV.Body_Material__c);
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.MCBODY=value;
        }
    }
    
    public string GPFACE{
        get{
				string labelval='';
            	labelval=fetchInputAttributeDesc('GPFACE',oRV.Facing__c);
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.GPFACE=value;
        }
    }
    
    public string MCSEAT{
        get{
				string labelval='';
            	labelval=fetchInputAttributeDesc('MCSEAT',oRV.Seat_Material__c);
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.MCSEAT=value;
        }
    }
    
    public string MCPALL{
        get{
				string labelval='';
            	labelval=fetchInputAttributeDesc('MCPALL',oRV.Pressure_Pallet_Material__c);
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
            	labelval=fetchInputAttributeDesc('MCDPHM',oRV.Diaphragm_Material__c);
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.MCDPHM=value;
        }
    }
    
    public string MCVALL{
        get{
				string labelval='';
            	labelval=fetchInputAttributeDesc('MCPALL',oRV.Vacuum_Pallet_Material__c);
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.MCVALL=value;
        }
    }
    
    public string MCPSGD{
        get{
				string labelval='';
            	labelval=fetchInputAttributeDesc('MCPSGD',oRV.Pilot_Soft_Goods_Material__c);
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.MCPSGD=value;
        }
    }
    
    public string MCWGHT{
        get{
				string labelval='';
            	labelval=fetchInputAttributeDesc('MCWGHT',oRV.Weight_Material__c);
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.MCWGHT=value;
        }
    }
    
    public string MCSPRG{
        get{
				string labelval='';
            	labelval=fetchInputAttributeDesc('MCSPRG',oRV.Spring_Material__c);
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.MCSPRG=value;
        }
    }
    
    public string MCSTMJ{
        get{
				string labelval='';
            	labelval=fetchInputAttributeDesc('MCSTMJ',oRV.Steam_Jacket_Material__c);
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.MCSTMJ=value;
        }
    }
    
    public string MCCOTB{
        get{
				string labelval='';
            	labelval=fetchInputAttributeDesc('MCCOTB',oRV.Body_Coating_Material__c);
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.MCCOTB=value;
        }
    }
    
    public string MCCOTP{
        get{
				string labelval='';
            	labelval=fetchInputAttributeDesc('MCCOTP',oRV.Pallet_Fastener_Coating_Material__c);
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.MCCOTP=value;
        }
    }
    
    public string MCELMT{
        get{
				string labelval='';
            	labelval=fetchInputAttributeDesc('MCELMT',oRV.Element_Material__c);
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.MCELMT=value;
        }
    }
    
    public string VPRTOP{
        get{
				string labelval='';
            	labelval=fetchInputAttributeDesc('VPRTOP',oRV.Vacuum_Port_Option__c);
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.VPRTOP=value;
        }
    }
    
    public string PMI{
        get{
				string labelval='';
            	labelval=fetchInputAttributeDesc('PMI',oRV.Positive_Material_Identification__c);
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.PMI=value;
        }
    }
    
    public string LDP{
        get{
				string labelval='';
            	labelval=fetchInputAttributeDesc('LDP',oRV.Liquid_Dye_Penetrant__c);
            	if(labelval!=null)
					return labelval;
			    else
					return ' ';
        }
        set{
            this.LDP=value;
        }
    }
    
    
}