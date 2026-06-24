# AI Coding Assistants

Install the html-to-markdown plugin from the [`xberg-io/plugins`](https://github.com/xberg-io/plugins) marketplace. It ships the html-to-markdown agent skills and works with every major coding agent — expand your harness below.

## Installing

<details open>
<summary><strong>Claude Code</strong></summary>

```text
/plugin marketplace add xberg-io/plugins
/plugin install html-to-markdown@kreuzberg
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
droid plugin install html-to-markdown@kreuzberg
```

</details>

<details>
<summary><strong>GitHub Copilot CLI</strong></summary>

```text
copilot plugin marketplace add https://github.com/xberg-io/plugins
copilot plugin install html-to-markdown@kreuzberg
```

</details>

<details>
<summary><strong>opencode</strong></summary>

Add the package to `opencode.json`:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "plugin": ["@kreuzberg/opencode-html-to-markdown"]
}
```

</details>
