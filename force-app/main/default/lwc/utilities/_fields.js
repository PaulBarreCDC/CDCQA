const _fieldProperties = {
    label: '',
    options: [],
    required: true,
    fieldMode: 'Edit',
    fieldViewState: ''
};

/**
 * Field Event Types
 */
export const FieldEventTypes = {
    Change: 'Change',
    Blur: 'Blur',
    Click: 'Click'
};

/**
 * Get a new instance of the default set of field properties
 *
 * @returns {Object} Field Property Object
 */
export function getFieldProperties() {
    return { ..._fieldProperties };
}

/**
 * Get a new instance of the default set of field properties
 * @param {Object}
 *              {
 *                  fieldName, (required)
 *                  options (optional)
 *              }
 * @returns {Object} Field Property Object
 */
export function buildHiddenField({ fieldName, options }) {
    const fieldToReturn = {
        fieldName,
        fieldProperties: {
            fieldViewState: this.FieldViewStates.Hidden
        }
    };

    if (options) {
        fieldToReturn.fieldProperties.options = options;
    }

    return fieldToReturn;
}

/**
 * Get a new instance of the default set of field properties
 *
 * @returns {Object} Field Property Object
 */
export function buildVisibleField({ fieldName, options }) {
    const fieldToReturn = {
        fieldName,
        fieldProperties: {
            fieldViewState: this.FieldViewStates.Visible
        }
    };

    if (options) {
        fieldToReturn.fieldProperties.options = options;
    }

    return fieldToReturn;
}

/**
 * Field Modes
 */
export const FieldModes = {
    Review: 'Review',
    Edit: 'Edit'
};

/**
 * Field View States
 */
export const FieldViewStates = {
    Hidden: 'Hidden',
    Locked: 'Locked',
    Visible: 'Visible',
    Disable: 'Disable',
    Required: 'Required'
};

/**
 * Field Types
 */
export const FieldTypes = {
    NotSet: 'NotSet',
    Text: 'Text',
    ComboBox: 'ComboBox',
    Radio: 'Radio',
    CheckBox: 'CheckBox',
    ReadOnly: 'ReadOnly',
    TextArea: 'TextArea',
    Listbox: 'Listbox',
    Image: 'Image',
    ProductSelector: 'ProductSelector'
};