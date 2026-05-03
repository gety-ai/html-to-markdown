```typescript
import { convert } from "@kreuzberg/html-to-markdown";

const result = convert("<h1>Hello World</h1>");
const markdown: string = result.content;
console.log(markdown); // # Hello World
```
