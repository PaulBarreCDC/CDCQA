/**
 * Reduces one or more LDS errors into a string[] of error messages.
 * @param {FetchResponse|FetchResponse[]} errors
 * @return {String[]} Error messages
 */
export function reduceErrors(errors) {
    if (!Array.isArray(errors)) {
        errors = [errors];
    }

    return (
        errors
            // Remove null/undefined items
            .filter((error) => !!error)
            // Extract an error message
            .map((error) => {
                // UI API read errors
                if (Array.isArray(error.body)) {
                    return error.body.map((e) => e.message);
                }
                // UI API DML, Apex and network errors
                else if (error.body && typeof error.body.message === 'string') {
                    return error.body.message;
                }
                // JS errors
                else if (typeof error.message === 'string') {
                    return error.message;
                }
                // Unknown error shape so try HTTP status text
                return error.statusText;
            })
            // Flatten
            .reduce((prev, curr, index) => {
                const message = `${curr}`;
                // filter any empty messages out
                if (message) {
                    return prev.concat({ message, index });
                }
                return prev;
            }, [])
    );
}

export function ensureError(errorObject, stack) {
    if (errorObject?.isLoggable === true) {
        return errorObject;
    }

    let error = {
        message: '',
        errorType: undefined,
        stack: stack,
        isLoggable: true
    };

    if (typeof errorObject === 'string' || errorObject instanceof String) {
        error.message = errorObject;
    } else if (errorObject?.message) {
        error.message = errorObject.message;
    } else if (errorObject?.error?.message) {
        error.message = errorObject.error.message;
    }
    if (errorObject?.error?.name) {
        error.errorType = errorObject.error.name;
    }
    if (stack) {
        error.stack = stack;
    }

    if (errorObject?.body?.message) {
        error.message = errorObject.body.message;
    }

    return error;
}