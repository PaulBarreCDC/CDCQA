({
	showToast : function(component, event, TostVariant,Message) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
        "title": TostVariant,
        "message": Message,
        "type" : TostVariant
    
    });
    toastEvent.fire();
}
})