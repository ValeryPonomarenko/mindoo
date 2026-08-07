# Mindoo desktop text embeddings

This package is the desktop implementation of the `text_embedding` contracts.
It downloads the pinned, ARM64 INT8
`paraphrase-multilingual-MiniLM-L12-v2` ONNX model on demand, verifies its
SHA-256 checksum, tokenizes text with Hugging Face's native tokenizer, and
returns normalized 384-dimensional vectors.

```dart
final modelManager = DesktopModelManager();
final embedder = await DesktopMiniLmEmbedder.create(modelManager);
final tokenizer = HuggingFaceTextTokenizer(modelManager);
final chunker = TokenTextChunker(tokenizer);

final chunks = await chunker.chunk(
  EmbeddingDocument(id: note.id, text: note.plainText),
);
final vectors = await embedder.encode(chunks.map((chunk) => chunk.text));
```

`DesktopMiniLmEmbedder.create` installs the model when it is missing. For a
download screen, call `modelManager.install()` yourself and observe
`modelManager.watch()` to observe the installation state and progress.

The current model artifact targets Apple Silicon macOS. The same desktop
implementation will select a Windows artifact when Windows support is added.
`text_embedding` remains platform-independent, so mobile adapters can be
added later without changing the API used by `core`.
