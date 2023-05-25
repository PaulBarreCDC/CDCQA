/*******************************************************
* Class Name: IFS_ConstructDocumentTag
* This class constructs Document Tag for IFS Integration
********************************************************/
public class IFS_ConstructDocumentTag{

    public void IFS_ConstructDocumentTag(){
    }
    
    public static XmlStreamWriter generateReq(XmlStreamWriter xmlStream,ContentVersion eachFile,String publicLink){
        
        Map<String,String> iFSFileTypes = new Map<String,String>();
        iFSFileTypes.put('accdb','ACCESS');
        iFSFileTypes.put('xls','EXCEL');
        iFSFileTypes.put('csv','EXCEL-C');
        iFSFileTypes.put('xlt','EXCEL-T');
        iFSFileTypes.put('xlsx','EXCEL-X');
        iFSFileTypes.put('tif','IMAGE');
        iFSFileTypes.put('jpg','JPG');
        iFSFileTypes.put('pdf','ACROBAT');
        iFSFileTypes.put('png','PNG');
        iFSFileTypes.put('ppt','POWERPOINT');
        iFSFileTypes.put('pptm','POWERPOINT-M');
        iFSFileTypes.put('pps','POWERPOINT-S');
        iFSFileTypes.put('pptx','POWERPOINT-X');
        iFSFileTypes.put('rtf','RTF');
        iFSFileTypes.put('txt','TEXTFILE');
        iFSFileTypes.put('vsd','VISIO');
        iFSFileTypes.put('doc','WORD');
        iFSFileTypes.put('docm','WORD-M');
        iFSFileTypes.put('docx','WORD-X');      
        
        xmlStream.writeStartElement(NULL, 'DOCUMENT', NULL);// begin of DOCUMENT

        xmlStream.writeStartElement(NULL, 'DOC_NO', NULL);          
        String docId=eachFile.Id;
        xmlStream.writeCharacters(docId.toUpperCase());              
        xmlStream.writeEndElement();
                
        xmlStream.writeStartElement(NULL, 'DOC_REV', NULL);       
        xmlStream.writeCharacters('A1');
        xmlStream.writeEndElement();
        
        xmlStream.writeStartElement(NULL, 'DOC_SHEET', NULL);       
        xmlStream.writeCharacters('ORIGINAL');
        xmlStream.writeEndElement();
        
        xmlStream.writeStartElement(NULL, 'DOC_TITLE', NULL);
        xmlStream.writeCharacters(eachFile.Title+'.'+eachFile.FileExtension);              
        xmlStream.writeEndElement();

        xmlStream.writeStartElement(NULL, 'DOC_CLASS', NULL);       
        //xmlStream.writeCharacters('FILE');
        if(eachFile.Document_Class__c != NULL){
            String dc = eachFile.Document_Class__c;
            xmlStream.writeCharacters(dc.left(9));
        }else{
            xmlStream.writeCharacters('MTR-100');
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement(NULL, 'FILE_TYPE', NULL);
        /*if(eachFile.FileType == 'PDF'){
            xmlStream.writeCharacters('ACROBAT');
        }else if(eachFile.FileType == 'WORD_X'){
            xmlStream.writeCharacters('WORD');
        }else if(eachFile.FileType == 'Excel_S'){
            xmlStream.writeCharacters('Excel-X');
        }else{
            xmlStream.writeCharacters(eachFile.FileType);
        }*/
        if(iFSFileTypes.get(eachFile.FileExtension)!=NULL){
            xmlStream.writeCharacters(iFSFileTypes.get(eachFile.FileExtension));
        }else{
            xmlStream.writeCharacters(eachFile.FileType);
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement(NULL, 'FILE_NAME', NULL);
        xmlStream.writeCharacters(eachFile.Title+'.'+eachFile.FileExtension); 
        xmlStream.writeEndElement(); 

        System.debug('Heap Size :----'+Limits.getHeapSize());
        System.debug('Limit Heap Size :----'+Limits.getLimitHeapSize());

        xmlStream.writeStartElement(NULL, 'FILE_DATA', NULL);
        xmlStream.writeCharacters('');
        //xmlStream.writeCharacters(EncodingUtil.base64Encode(eachFile.VersionData));              
        xmlStream.writeEndElement();

        xmlStream.writeStartElement(NULL, 'DOC_LINK', NULL);
        //String publicLinkNew=publicLink.replace('&','&amp;');
        //xmlStream.writeCharacters(publicLinkNew);
        xmlStream.writeCharacters(publicLink);  
        xmlStream.writeEndElement();    

        xmlStream.writeEndElement();// end of DOCUMENT
        
        return xmlStream;
    }
}