Helm chart to install Llama-stack and an MCP server on OpenShift

## Pre-requsuites

* OpenShift cluster 
* Helm CLI
* OpenShift CLI
* Access to a running LLM e.g. Llama-3.1-8B-Instruct
* llama-stack-client CLI (optional)

## Installation

Login to your OpenShift cluster with the OpenShift CLI

Create a new project e.g. `llama-stack`

```
oc new-project llama-stack
```

Set environment variables for LLM connection

```
export LLM_URL=???
export LLM_TOKEN=???
```

Run the helm chart with the helm CLI

```
helm install llama-stack ./llama-stack --set "vllm.url=$LLM_URL/v1,vllm.apiKey=$LLM_$TOKEN"
```

## Llama-stack configuration

Watch the status of the pods with

```
oc get pods -w
```

Once the Llama-stack pod is running successfully, you will need to register the MCP server.  To do this, first find the route of your llama-stack server

```
export LLAMA_STACK_URL=$(oc get route llama-stack -o jsonpath='{.spec.host}')
```

```
 curl -X POST -H "Content-Type: application/json" \
--data \
'{ "provider_id" : "model-context-protocol", "toolgroup_id" : "mcp::orders-service", "mcp_endpoint" : { "uri" : "http://llama-stack-mcp:8000/sse"}}' \
 https://$LLAMA_STACK_URL/v1/toolgroups 
 ```

Check the status of the toolgroup:

`llama-stack-client configure --endpoint  https://$LLAMA_STACK_URL --api-key none`

`llama-stack-client toolgroups get mcp::orders-service`

You should see:

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━┳━━━━━━┓
┃ description               ┃ identifier  ┃ metadata                  ┃ parameters                 ┃ provider_id            ┃ provider_resource_id ┃ tool_host              ┃ toolgroup_id        ┃ type ┃
┡━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━╇━━━━━━┩
│ Find a customers orders   │ findorder   │ {'endpoint':              │ [Parameter(description='T… │ model-context-protocol │ findorder            │ model_context_protocol │ mcp::orders-service │ tool │
│ details                   │             │ 'http://llama-stack-mcp:… │ id of the order',          │                        │                      │                        │                     │      │
│                           │             │                           │ name='orderid',            │                        │                      │                        │                     │      │
│                           │             │                           │ parameter_type='string',   │                        │                      │                        │                     │      │
│                           │             │                           │ required=True,             │                        │                      │                        │                     │      │
│                           │             │                           │ default=None)]             │                        │                      │                        │                     │      │
│ Update an order status    │ updateorder │ {'endpoint':              │ [Parameter(description='T… │ model-context-protocol │ updateorder          │ model_context_protocol │ mcp::orders-service │ tool │
│                           │             │ 'http://llama-stack-mcp:… │ id of the order',          │                        │                      │                        │                     │      │
│                           │             │                           │ name='orderid',            │                        │                      │                        │                     │      │
│                           │             │                           │ parameter_type='string',   │                        │                      │                        │                     │      │
│                           │             │                           │ required=True,             │                        │                      │                        │                     │      │
│                           │             │                           │ default=None),             │                        │                      │                        │                     │      │
│                           │             │                           │ Parameter(description='The │                        │                      │                        │                     │      │
│                           │             │                           │ status of the order',      │                        │                      │                        │                     │      │
│                           │             │                           │ name='status',             │                        │                      │                        │                     │      │
│                           │             │                           │ parameter_type='string',   │                        │                      │                        │                     │      │
│                           │             │                           │ required=True,             │                        │                      │                        │                     │      │
│                           │             │                           │ default=None)]             │                        │                      │                        │                     │      │
└───────────────────────────┴─────────────┴───────────────────────────┴────────────────────────────┴────────────────────────┴──────────────────────┴────────────────────────┴─────────────────────┴──────┘
```

## Clean up

To uninstall the helm chart, run:

```
helm uninstall llama-stack
```

