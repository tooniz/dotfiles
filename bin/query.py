
#!/usr/bin/env python3

import argparse
import os

from groq import Groq


def query(client, model, prompt, streaming):
    result = client.chat.completions.create(
        messages=[
            {
                "role": "system",
                "content": prompt[0]
            },
            {
                "role": "user",
                "content": prompt[1],
            }
        ],
        model=model,
        stream=streaming,
    )
    return result


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Fast Inference Example')
    parser.add_argument('-m', '--model', default='llama3-70b-8192',
                        help='Model to use for inference')
    parser.add_argument('-s', '--system', default='you are a helpful assistant.',
                        help='System prompt for the query')
    parser.add_argument('--streaming', default=False, action='store_true',
                        help="Output streaming mode")
    parser.add_argument('prompt', nargs='+', help='User prompt to process')

    args = parser.parse_args()

    user = ' '.join(args.prompt)

    # print(f"Querying '{args.model}' with query '{user}'")

    result = query(Groq(api_key=os.environ.get(
        "GROQ_API_KEY")), args.model, [args.system, user], args.streaming)

    if args.streaming:
        for chunk in result:
            print(chunk.choices[0].delta.content, end="")

            if chunk.choices[0].finish_reason:
                # Usage information is available on the final chunk
                assert chunk.x_groq is not None
                assert chunk.x_groq.usage is not None
                print(f"\n\nUsage stats: {chunk.x_groq.usage}")
    else:
        print(result.choices[0].message.content)