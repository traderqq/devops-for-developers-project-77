#!/usr/bin/env python3

import json
import sys
import urllib.request
import urllib.error


API_URL = "https://api.upmon.com/v3/checks/"


def fail(message):
    print(json.dumps({"error": message}), file=sys.stderr)
    sys.exit(1)


def main():
    query = json.load(sys.stdin)

    api_key = query["api_key"]
    name = query["name"]
    slug = query["slug"]

    payload = {
        "name": name,
        "slug": slug,
        "tags": query.get("tags", "wikijs terraform"),
        "desc": query.get("desc", ""),
        "timeout": int(query.get("timeout", "120")),
        "grace": int(query.get("grace", "120")),
        "channels": query.get("channels", "*"),
        "unique": ["slug"],
    }

    request = urllib.request.Request(
        API_URL,
        data=json.dumps(payload).encode("utf-8"),
        headers={
            "Content-Type": "application/json",
            "Accept": "application/json",
            "X-Api-Key": api_key,
            "User-Agent": "Mozilla/5.0 Terraform-Upmon/1.0",
        },
        method="POST",
    )

    try:
        with urllib.request.urlopen(request, timeout=30) as response:
            response_body = response.read().decode("utf-8")
            body = json.loads(response_body)
    except urllib.error.HTTPError as error:
        error_body = error.read().decode("utf-8", errors="replace")
        fail(f"Upmon API HTTP {error.code}: {error_body}")
    except urllib.error.URLError as error:
        fail(f"Upmon API connection error: {error}")
    except json.JSONDecodeError as error:
        fail(f"Invalid JSON response from Upmon: {error}")
    except Exception as error:
        fail(f"Unexpected error: {error}")

    required_fields = ["uuid", "ping_url", "name", "slug"]
    missing = [field for field in required_fields if field not in body]
    if missing:
        fail(f"Upmon response missing fields {missing}: {body}")

    print(json.dumps({
        "uuid": str(body["uuid"]),
        "ping_url": str(body["ping_url"]),
        "name": str(body["name"]),
        "slug": str(body["slug"]),
    }))


if __name__ == "__main__":
    main()
