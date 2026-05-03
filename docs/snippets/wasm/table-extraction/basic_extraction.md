```javascript
import init, { convert } from "@kreuzberg/html-to-markdown-wasm";

await init();

const html = `
<table>
    <tr><th>Name</th><th>Age</th></tr>
    <tr><td>Alice</td><td>30</td></tr>
    <tr><td>Bob</td><td>25</td></tr>
</table>
`;

const result = convert(html, { extractTables: true });

for (const table of result.tables ?? []) {
  for (let i = 0; i < table.cells.length; i++) {
    const prefix = table.isHeaderRow[i] ? "Header" : "Row";
    console.log(`  ${prefix}: ${table.cells[i].join(", ")}`);
  }
}
```
