export function CreateCustomEvent(eventName, data) {
    if (data === undefined) {
        data = null;
    }

    return new CustomEvent(eventName, {
        bubbles: true,
        detail: data
    });
}

export function CreateBaseConfiguratorTabConnectedEvent(data) {
    return new CustomEvent('baseconfiguratortabconnected', {
        composed: true,
        bubbles: true,
        detail: data
    });
}

export function CreateNotificationMessageSubscriberEvent(data) {
    return new CustomEvent('notificationmessagehandlerregister', {
        composed: true,
        bubbles: true,
        detail: data
    });
}

export function CreateFieldActionEvent(data) {
    return new CustomEvent('fieldaction', {
        bubbles: true,
        detail: data
    });
}

export function CreateNotificationEvent(message) {
    return new CustomEvent('notification', {
        bubbles: true,
        detail: message
    });
}

export function CreateErrorNotificationEvent(error, stack) {
    return new CustomEvent('error', {
        bubbles: true,
        detail: {
            error,
            stack
        }
    });
}