# Setting Up the Environment

## Run the Database

Start a PostgreSQL database using Podman:

```sh
podman run --name postgres \
  -e POSTGRES_USER=claimdb \
  -e POSTGRES_PASSWORD=claimdb \
  -v ./local/import.sql:/docker-entrypoint-initdb.d/import.sql:ro \
  -p 5432:5432 \
  -v /var/lib/data \
  -d postgres
```

## Run the MCP Server

Navigate to the `mcp-server` directory and install dependencies:

```sh
cd mcp-server
npm install
```

Set the required database environment variables:

```sh
export DB_USER=claimdb
export DB_HOST=localhost
export DB_NAME=claimdb
export DB_PASSWORD=claimdb
```

Run the MCP server using `npx`:

```sh
npx -y supergateway --stdio "node app/index.js"
```

## Run the Model in Ollama

Execute the following command to start the Ollama model:

```sh
ollama run llama3.1:8b-instruct-fp16
```

## Run Llama-Stack

Set up the environment variables:

```sh
export LLAMA_STACK_PORT=5001
export INFERENCE_MODEL="llama3.1:8b-instruct-fp16"
```

Run Llama-Stack using Podman:

```sh
podman run \
  -it \
  -v ./llama-stack/files/run-ollama.yaml:/root/my-run.yaml \
  -p $LLAMA_STACK_PORT:$LLAMA_STACK_PORT \
  -v ~/.llama:/root/.llama \
  llamastack/distribution-ollama:0.1.8 \
  --port $LLAMA_STACK_PORT \
  --yaml-config /root/my-run.yaml \
  --env INFERENCE_MODEL=$INFERENCE_MODEL \
  --env OLLAMA_URL=http://host.docker.internal:11434
```

### Running with vLLM

To run with vLLM, first set the required environment variable:

```sh
export VLLM_URL=
```

Then execute the following command:

```sh
podman run -it -p 8321:8321 \
  -v /Users/phayes/projects/mcp-on-llama-stack/run-vllm.yaml:/root/my-run.yaml \
  llamastack/distribution-remote-vllm:latest \
  --yaml-config /root/my-run.yaml \
  --port 8321 \
  --env INFERENCE_MODEL=$INFERENCE_MODEL \
  --env VLLM_API_TOKEN=$VLLM_API_TOKEN \
  --env VLLM_URL=$VLLM_URL
```

## Register the Tool

Export the required port:

```sh
export LLAMA_STACK_PORT=5001
```

Register the tool using `curl`:

```sh
curl -X POST -H "Content-Type: application/json" \
  --data '{ "provider_id" : "model-context-protocol", "toolgroup_id" : "mcp::orders-service", "mcp_endpoint" :{ "uri" : "http://host.containers.internal:8000/sse"}}' \
  http://localhost:$LLAMA_STACK_PORT/v1/toolgroups
```

## Run the Chat App

Navigate to the `chat-app` directory:

```sh
cd chat-app
```

Set the environment variables:

```sh
export INFERENCE_MODEL="llama3.1:8b-instruct-fp16"
export BASE_URL=http://localhost:5001
```

### **(Optional) Set Up a Python Virtual Environment**
To keep dependencies isolated, it's recommended to use a virtual environment.

1. Create a virtual environment:
   ```sh
   python -m venv venv
   ```
2. Activate the virtual environment:
     ```sh
     source venv/bin/activate
     ```


3. Install Streamlit inside the virtual environment:
   ```sh
   pip install streamlit
   ```

### **Run the Chat Application Using Streamlit**
Once Streamlit is installed, you can start the application by running:
```sh
streamlit run app.py
```
