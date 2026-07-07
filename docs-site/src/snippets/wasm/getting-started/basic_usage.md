```javascript
import init, { convert } from "@xberg-io/html-to-markdown-wasm";

await init();

const html = "<h1>Hello</h1><p>This is <strong>fast</strong>!</p>";
const result = convert(html);
const markdown = result.content;
console.log(markdown);
```
