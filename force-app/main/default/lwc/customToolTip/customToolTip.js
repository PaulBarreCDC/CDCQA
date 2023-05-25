import { LightningElement, track, api} from 'lwc';

export default class CustomToolTip extends LightningElement {

    @api helpText;

    buttonClicked; //defaulted to false

    @track cssClass = 'hideToolTip';

    showHideHelpText() {

        this.buttonClicked = !this.buttonClicked; //set to true if false, false if true.
        this.cssClass = this.buttonClicked ? 'showToolTip' : 'hideToolTip';
    }

    disableClick() {

        return false;
    }
}