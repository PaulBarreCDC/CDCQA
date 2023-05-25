export function normalizeString(value, config = {}) {
    const { fallbackValue = '', validValues, toLowerCase = true } = config;

    let normalized = (typeof value === 'string' && value.trim()) || '';
    normalized = toLowerCase ? normalized.toLowerCase() : normalized;
    if (validValues && validValues.indexOf(normalized) === -1) {
        normalized = fallbackValue;
    }

    return normalized;
}