```javascript
import init, { convert } from "@xberg-io/html-to-markdown-wasm";

await init();

const result = convert('<h1>Hello</h1><img src="pic.jpg">', {
  headingStyle: "atx",
  skipImages: true,
});
const markdown = result.content;
console.log(markdown);
```
