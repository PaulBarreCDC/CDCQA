function makeElementsReadOnly() {
	
	let read_only_profile = j$('#read_only_profile').val();
	read_only_profile = read_only_profile.split(',');
    if(read_only_profile.includes(j$('#user_profile').val())) {
    	
        j$('input[type="text"]').attr('disabled', 'disabled');
        j$('input[type="radio"]').attr('disabled', 'disabled');
        j$('input[type="checkbox"]').attr('disabled', 'disabled');
        j$('select').attr('disabled', 'disabled');
        j$('input[type="button"]').hide();
		j$('input[type="submit"]').hide();
        j$('input[value="Back"]').show();
        j$('input[value="Back"]').removeAttr('disabled');
    }
}