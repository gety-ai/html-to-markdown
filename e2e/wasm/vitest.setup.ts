import { initWasm } from "@kreuzberg/html-to-markdown-wasm";

try {
  await initWasm();
  console.log("WASM initialization successful");
} catch (e) {
  console.error("WASM initialization failed:", e);
  throw e;
}
