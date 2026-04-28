```javascript
import init, { convert } from '@kreuzberg/html-to-markdown-wasm';

await init();

const visitor = {
  visit_link(ctx, href, text, title) {
    return { type: 'continue' };
  },
  visit_image(ctx, src, alt, title) {
    return { type: 'continue' };
  },
};

const result = convert('<h1>Hello</h1><a href="https://example.com">link</a>', undefined, visitor);
console.log(result.content);
```
