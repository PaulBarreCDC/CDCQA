import { Logger } from './_debug';

export { Logger } from './_debug';

const InstanceInfoType = {
    PageReference: 'Page Reference',
    Instance: 'Configurator Instance Record',
    Header: 'Part Configurator Header Result'
};

const NavigationSources = {
    DirectNavigation: {
        Abbreviation: 'd',
        Name: 'Direct Navigation'
    },
    Quote: {
        Abbreviation: 'q',
        Name: 'Quote',
        ReturnUrlFormat: {
            Internal:
                '/apex/sbqq__sb?scontrolCaching=1&id={id}#quote/le?qId={id}',
            Partner: '/community?scontrolCaching=1&id={id}#quote/le?qId={id}'
        }
    },
    SizingRequest: {
        Abbreviation: 's',
        Name: 'Sizing Request',
        ReturnUrlFormat:
            '/community?scontrolCaching=1&id={id}#quote/le?qId={id}'
    },
    Instance: {
        Abbreviation: 'i',
        Name: 'Configuator Instance'
    },
    ConfiguredPart: {
        Abbreviation: 'p',
        Name: 'Configured Part'
    }
};
const NavigationSourceMap = {
    d: NavigationSources.DirectNavigation,
    q: NavigationSources.Quote,
    s: NavigationSources.SizingRequest,
    i: NavigationSources.Instance,
    p: NavigationSources.ConfiguredPart
};
const UrlParamOptions = {
    EnableURLParameters: 'c__d',
    SourceId: 'c__i',
    Source: 'c__s'
};

class NavigationSettings {
    InstanceInfoType = InstanceInfoType;

    initialized = false;

    initializedOn = null;
    namespacePrefix = '';

    currentSource = {
        pageReference: null,
        source: NavigationSources.DirectNavigation.Name,
        id: null
    };

    currentPageReference = null;

    instanceInfo = {
        id: null,
        brand: null,
        reference: {
            id: null,
            sObjectName: null
        }
    };

    configuratorInfo = {
        recordId: null,
        recordType: null,
        configurator: null
    };

    get returnButtonLabel() {
        if (this.instanceInfo?.reference?.sObjectName) {
            return `Return to ${this.instanceInfo.reference.sObjectName}`;
        }

        return null;
    }

    get getReturnPageReference() {
        const pageReference = {
            type: 'standard__webPage',
            attributes: {
                url:
                    window.location.origin +
                    NavigationSources.Quote.ReturnUrlFormat.Internal.replaceAll(
                        '{id}',
                        this.instanceInfo.reference.id
                    )
            }
        };

        return pageReference;
    }

    get isSizingRequest() {
        return (
            this.currentSource?.source === NavigationSources.SizingRequest.Name
        );
    }

    get instanceId() {
        return this.instanceInfo?.id;
    }

    get instanceSourceName() {
        return this.instanceInfo?.reference?.sObjectName;
    }

    get instanceSourceId() {
        return this.instanceInfo?.reference?.id;
    }

    get status() {
        return this.initialized ? 'Initialized' : 'Not Initialized';
    }

    setConfiguratorHeader(headerInfo) {
        this.setInstanceInfo(InstanceInfoType.Header, headerInfo);

        this.configuratorInfo = {
            recordId: headerInfo.configuratorRecordId,
            recordType: headerInfo.configuratorRecordRecordTypeName,
            configurator: headerInfo.configuratorRecordObjectType
        };
    }

    setPageReference(currentPageReference) {
        this.currentPageReference = currentPageReference;

        this.handlePageReference(currentPageReference);

        if (!this.initialized) {
            //Handle Page Change
            Logger(
                NavigationSettings.name,
                'Changed Page Reference',
                currentPageReference
            );
        }

        return this.initialized;
    }

    setInstanceInfo(instanceInfoType, instanceInfo) {
        //instanceInfo = could be
        //1. initial PageReference
        //2. getBlankConfiguratorInstance result
        //3. configurationHeader result

        if (instanceInfoType === InstanceInfoType.PageReference) {
            //Other Sources will be set later
            if (
                instanceInfo.source.Abbreviation ===
                    NavigationSources.Quote.Abbreviation ||
                instanceInfo.source.Abbreviation ===
                    NavigationSources.SizingRequest.Abbreviation
            ) {
                this.instanceInfo = {
                    id: null,
                    brand: null,
                    reference: {
                        id: instanceInfo.id,
                        sObjectName: instanceInfo.source.Name
                    }
                };
            }
        } else if (instanceInfoType === InstanceInfoType.Header) {
            this.instanceInfo = {
                id: instanceInfo.configuratorConfiguratorInstanceId,
                brand: instanceInfo.configuratorConfiguratorInstanceBrand,
                reference: {
                    id: instanceInfo.configuratorConfiguratorInstanceReferenceId,
                    sObjectName:
                        instanceInfo.configuratorConfiguratorInstanceReferenceSObject
                }
            };
        } else if (instanceInfoType === InstanceInfoType.Instance) {
            this.instanceInfo = {
                id: instanceInfo.instanceId,
                brand: instanceInfo.brand,
                reference: {
                    id: instanceInfo.referenceId,
                    sObjectName: instanceInfo.referenceSObject
                }
            };
        }
    }

    handlePageReference(currentPageReference) {
        const padStr = (i) => {
            return i < 10 ? '0' + i : '' + i;
        };

        const setPageSource = (pageReference) => {
            const navigationSource =
                NavigationSourceMap[
                    currentPageReference.state[UrlParamOptions.Source]
                ];

            return {
                pageReference: pageReference,
                source:
                    navigationSource ?? NavigationSources.DirectNavigation.Name,
                id: pageReference.state[UrlParamOptions.SourceId]
            };
        };

        if (!this.initialized) {
            Logger(
                NavigationSettings.name,
                'Initializing Page Reference',
                currentPageReference
            );

            this.initialized = true;

            const now = new Date();

            this.initializedOn = `${padStr(now.getHours())}:${padStr(
                now.getMinutes()
            )}:${padStr(now.getSeconds())}`;

            this.namespacePrefix = (
                currentPageReference.attributes.apiName ??
                currentPageReference.attributes.objectApiName
            )
                .toLowerCase()
                .startsWith('cdcpc__')
                ? 'cdcpc__'
                : '';
        }

        if (
            currentPageReference.state[UrlParamOptions.EnableURLParameters] ===
            '1'
        ) {
            this.currentSource = setPageSource(currentPageReference);

            this.setInstanceInfo(
                InstanceInfoType.PageReference,
                this.currentSource
            );
        } else if (currentPageReference.type === 'standard__recordPage') {
            //Direct navigation
            this.currentSource = {
                pageReference: currentPageReference,
                source: NavigationSources.DirectNavigation.Name,
                id: currentPageReference.attributes.recordId
            };
        }
        //  else if (currentPageReference.type === 'standard__navItemPage') {
        //     // cdcpc__ and c__ handles both namespace and non
        //     let recordId = currentPageReference?.state?.cdcpc__recordId;

        //     if (!recordId) {
        //         recordId = currentPageReference?.state?.c__recordId;
        //     }

        //     // TODO this won't work because the new configured part isn't linked to an instance
        //     //Direct navigation
        //     this.currentSource = {
        //         pageReference: currentPageReference,
        //         source: NavigationSources.DirectNavigation.Name,
        //         id: recordId
        //     };
        // }

        //First Page, set initial referral source information
        if (!this.initialized) {
            this.referralSource = this.currentSource;
        }

        return false;
    }

    getConfiguratorPageReference(requestedConfiguratorKey, instanceId) {
        const navigationMap = {
            BGR: `${this.namespacePrefix}BlanketGasRegulator_PartConfigurator`,
            RD: `${this.namespacePrefix}RuptureDisc_PartConfigurator`
        };

        const nav = {
            type: 'standard__navItemPage',
            attributes: {
                apiName: navigationMap[requestedConfiguratorKey]
            },
            state: {
                c__d: '1',
                c__s: NavigationSourceMap.i.Abbreviation,
                c__i: instanceId
            }
        };

        return nav;
    }
}

const Navigation = new NavigationSettings();

export { Navigation };