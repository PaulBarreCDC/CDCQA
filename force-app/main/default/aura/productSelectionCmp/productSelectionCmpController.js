({
    init: function(cmp, evt, helper) {
         
        console.log('inside init== ');
       var myPageRef = cmp.get("v.pageReference");
        console.log('===> ' + JSON.stringify(myPageRef));

        if(myPageRef != null || myPageRef != undefined){
            if(myPageRef && myPageRef.state){
                cmp.set("v.recordId", myPageRef.state.c__quoteId);
            }
        }else{
        var url_string = window.location.href;
        var url = new URL(url_string);
        var quoteId = url.searchParams.get("quoteId");
        console.log('---->' + quoteId);
        if(quoteId != undefined){
         cmp.set("v.recordId",quoteId); 
        }
    }
        
    },

    reInit : function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    }
})