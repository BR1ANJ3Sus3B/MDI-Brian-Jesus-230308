# Comprobante de entrega

- diagram_type: architecture
- output: docs/arquitectura-practica03.html
- specification_sha256: 1ba1f01022e3feb1a012acc45e0865b3deb890fea60af0b60c86b9b62af74c1b
- specification_bytes: 10937
- artifact_sha256: 309640868f940ec31543b5334d8a34724605be35728bd3f3eb6c05ad1a8a2a4b
- artifact_bytes: 809824
- validation: 9/9 showcase, 0 errors, 0 warnings
- browser_evidence: passed
- visual_review: passed
- correction_rounds: 1

Validación determinista mediante `validate` y `deliver`. Evidencia automatizada con Edge/Chromium mediante `visual-check`: sin desbordamiento en 1440×900, 1600×1000, 1920×1080 y 2048×1320. El recibo detallado está en `arquitectura-practica03.visual-check.json`.

Revisión perceptual de las capturas del artefacto identificado por el SHA-256 anterior: tema claro a 1440×900 y oscuro a 2048×1320. Bloques, etiquetas, conexiones y tarjetas visibles sin cruces que oculten información. La revisión de imágenes no comprueba interactivamente las funciones de búsqueda o exportación.
