---
title: AI Coding Assistants
---

Give your coding agent working knowledge of html-to-markdown so it writes correct `convert()` calls, picks the right options, and reaches for the right binding — without you pasting docs into the chat.

## What this plugin does

The plugin packages html-to-markdown's usage patterns, options, and per-language APIs as agent skills. Once installed, your assistant can answer html-to-markdown questions and generate accurate code straight from your editor or terminal. It installs from the [`xberg-io/plugins`](https://github.com/xberg-io/plugins) marketplace and works with every major coding agent — pick yours below.

## Installing

<details open>
<summary><strong>Claude Code</strong></summary>

```text
/plugin marketplace add xberg-io/plugins
/plugin install html-to-markdown@xberg-io
```

</details>

<details>
<summary><strong>Codex CLI</strong></summary>

```text
/plugins add https://github.com/xberg-io/plugins
```

Then search for `html-to-markdown` and select **Install Plugin**.
</details>

<details>
<summary><strong>Cursor</strong></summary>

Settings → Plugins → Add from URL → `https://github.com/xberg-io/plugins`, then select **html-to-markdown**.
</details>

<details>
<summary><strong>Gemini CLI</strong></summary>

```text
gemini extensions install https://github.com/xberg-io/plugins
```

</details>

<details>
<summary><strong>Factory Droid</strong></summary>

```text
droid plugin marketplace add https://github.com/xberg-io/plugins
droid plugin install html-to-markdown@xberg-io
```

</details>

<details>
<summary><strong>GitHub Copilot CLI</strong></summary>

```text
copilot plugin marketplace add https://github.com/xberg-io/plugins
copilot plugin install html-to-markdown@xberg-io
```

</details>

<details>
<summary><strong>opencode</strong></summary>

Add the package to `opencode.json`:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "plugin": ["@xberg-io/opencode-html-to-markdown"]
}
```

</details>
