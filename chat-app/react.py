# Copyright (c) Meta Platforms, Inc. and affiliates.
# All rights reserved.
#
# This source code is licensed under the terms described in the LICENSE file in
# the root directory of this source tree.
import os
import uuid

import fire
from llama_stack_client import LlamaStackClient
from llama_stack_client.lib.agents.event_logger import EventLogger
from llama_stack_client.lib.agents.react.agent import ReActAgent
from llama_stack_client.lib.agents.react.tool_parser import ReActOutput
from termcolor import colored

from utils import check_model_is_available, get_any_available_model


def main(model_id: str | None = None):
    client = LlamaStackClient(
        base_url=f"http://localhost:5001",
    )

    if model_id is None:
        model_id = get_any_available_model(client)
        if model_id is None:
            return
    else:
        if not check_model_is_available(client, model_id):
            return

    print(colored(f"Using model: {model_id}", "green"))
    agent = ReActAgent(
        client=client,
        model=model_id,
        tools=["mcp::orders-service"]
    )

    session_id = agent.create_session(f"test-sessionxxx-{uuid.uuid4().hex}")
    user_prompt = "Check the status of order ORD1001"
    print(colored(f"User> {user_prompt}", "blue"))
    response = agent.create_turn(
        messages=[{"role": "user", "content": user_prompt}],
        session_id=session_id,
        stream=True,
    )
    for log in EventLogger().log(response):
        log.print()

    # user_prompt2 = "Retrieve order details for order ORD1001"
    # print(colored(f"User> {user_prompt2}", "blue"))
    # response2 = agent.create_turn(
    #     messages=[{"role": "user", "content": user_prompt2}],
    #     session_id=session_id,
    #     stream=True,
    # )
    # for log in EventLogger().log(response2):
    #     log.print()


if __name__ == "__main__":
    fire.Fire(main)