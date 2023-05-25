const DebugHandler = (function () {
    let debugVariables = [];

    function addVariable(name, value, asJson) {
        const item = { name: name, value: value, asJson: asJson };

        if (asJson) {
            item.value = JSON.stringify(value, null, '  ');
        }

        const currentPosition = debugVariables[name];
        if (currentPosition != null) {
            debugVariables[currentPosition] = item;
        } else {
            const newLength = debugVariables.push(item);

            debugVariables[name] = newLength - 1;
        }
    }

    function clearAll() {
        debugVariables = [];
    }

    function getDebugVariables() {
        return debugVariables;
    }

    return {
        clearAll: clearAll,
        addVariable: addVariable,
        getDebugVariables: getDebugVariables
    };
})();

export { DebugHandler };

let _privateLog = [];

const Logger = function (source, message, o1, o2, o3, o4, o5) {
    const additional = [];

    if (o1) {
        additional.push(o1);
    }
    if (o2) {
        additional.push(o2);
    }
    if (o3) {
        additional.push(o3);
    }
    if (o4) {
        additional.push(o4);
    }
    if (o5) {
        additional.push(o5);
    }

    const logMessage = `%cCDCPC: ${source} ${message}`;
    const logStyle = 'color:green;font-size:16px;';

    const privateLogItem = {
        number: _privateLog.length,
        source: source,
        message: message
    };

    if (additional.length === 0) {
        console.log(logMessage, logStyle);
    } else {
        console.log(logMessage, logStyle, additional);

        privateLogItem.additional = additional;
    }
    _privateLog = [privateLogItem, ..._privateLog];
};

const getPrivateLog = () => {
    return JSON.stringify(_privateLog, null, 2);
};

export { Logger, getPrivateLog };