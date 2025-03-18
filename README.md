Helm chart to install Llama-stack and an MCP server on OpenShift

## Pre-requsuites

* OpenShift cluster 
* Helm CLI
* OpenShift CLI
* Access to a running LLM e.g. Llama-3.1-8B-Instruct

## Installation

Login to your OpenShift cluster with the OpenShift CLI

Create a new project e.g. `llama-stack`

```
oc new-project llama-stack
```

Run the helm chart with the helm CLI

```
helm install llama-stack ./llama-stack --set "vllm.urlhttps://vllm.url.com/v1,vllm.apiKey=vllm-token"
```


```
 curl -X POST -H "Content-Type: application/json" \
--data \
'{ "provider_id" : "model-context-protocol", "toolgroup_id" : "mcp::orders-service", "mcp_endpoint" : { "uri" : "http://llama-stack-mcp:8000/sse"}}' \
 https://llama-stack-llama-stack.apps.cluster-vqz87.vqz87.sandbox1919.opentlc.com/v1/toolgroups ```
 

` llama-stack-client toolgroups get mcp::orders-service `

