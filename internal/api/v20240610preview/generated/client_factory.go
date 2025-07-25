// Code generated by Microsoft (R) AutoRest Code Generator (autorest: 3.10.8, generator: @autorest/go@4.0.0-preview.72)
// Changes may cause incorrect behavior and will be lost if the code is regenerated.
// Code generated by @autorest/go. DO NOT EDIT.

package generated

import (
	"github.com/Azure/azure-sdk-for-go/sdk/azcore"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/arm"
)

// ClientFactory is a client factory used to create any client in this module.
// Don't use this type directly, use NewClientFactory instead.
type ClientFactory struct {
	subscriptionID string
	internal       *arm.Client
}

// NewClientFactory creates a new instance of ClientFactory with the specified values.
// The parameter values will be propagated to any client created from this factory.
//   - subscriptionID - The ID of the target subscription. The value must be an UUID.
//   - credential - used to authorize requests. Usually a credential from azidentity.
//   - options - pass nil to accept the default values.
func NewClientFactory(subscriptionID string, credential azcore.TokenCredential, options *arm.ClientOptions) (*ClientFactory, error) {
	internal, err := arm.NewClient(moduleName, moduleVersion, credential, options)
	if err != nil {
		return nil, err
	}
	return &ClientFactory{
		subscriptionID: subscriptionID,
		internal:       internal,
	}, nil
}

// NewExternalAuthsClient creates a new instance of ExternalAuthsClient.
func (c *ClientFactory) NewExternalAuthsClient() *ExternalAuthsClient {
	return &ExternalAuthsClient{
		subscriptionID: c.subscriptionID,
		internal:       c.internal,
	}
}

// NewHcpOpenShiftClustersClient creates a new instance of HcpOpenShiftClustersClient.
func (c *ClientFactory) NewHcpOpenShiftClustersClient() *HcpOpenShiftClustersClient {
	return &HcpOpenShiftClustersClient{
		subscriptionID: c.subscriptionID,
		internal:       c.internal,
	}
}

// NewHcpOpenShiftVersionsClient creates a new instance of HcpOpenShiftVersionsClient.
func (c *ClientFactory) NewHcpOpenShiftVersionsClient() *HcpOpenShiftVersionsClient {
	return &HcpOpenShiftVersionsClient{
		subscriptionID: c.subscriptionID,
		internal:       c.internal,
	}
}

// NewHcpOperatorIdentityRoleSetsClient creates a new instance of HcpOperatorIdentityRoleSetsClient.
func (c *ClientFactory) NewHcpOperatorIdentityRoleSetsClient() *HcpOperatorIdentityRoleSetsClient {
	return &HcpOperatorIdentityRoleSetsClient{
		subscriptionID: c.subscriptionID,
		internal:       c.internal,
	}
}

// NewNodePoolsClient creates a new instance of NodePoolsClient.
func (c *ClientFactory) NewNodePoolsClient() *NodePoolsClient {
	return &NodePoolsClient{
		subscriptionID: c.subscriptionID,
		internal:       c.internal,
	}
}

// NewOperationsClient creates a new instance of OperationsClient.
func (c *ClientFactory) NewOperationsClient() *OperationsClient {
	return &OperationsClient{
		internal: c.internal,
	}
}
