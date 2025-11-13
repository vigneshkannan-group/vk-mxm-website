// scripts/bold-author.js
document.addEventListener("DOMContentLoaded", function () {
  // === Configure the name(s) you want to bold ===
  const namePatterns = [
    /\bKannan,\s*Vignesh\b/gi,
    /\bVignesh\s+Kannan\b/gi
  ];

  // Selectors for citation and bibliography areas
  const selectors = [
    ".csl-entry",        // bibliography entries
    ".csl-bib-body",     // bibliography container
    ".citation",         // inline citations
    ".csl-bibliography"  // fallback
  ];

  // Function to walk text nodes and bold matching text
  function boldAuthorText(root) {
    const walker = document.createTreeWalker(root, NodeFilter.SHOW_TEXT, null, false);
    const textNodes = [];
    let node;

    // Collect text nodes first
    while ((node = walker.nextNode())) textNodes.push(node);

    // Replace matches in each text node
    textNodes.forEach(textNode => {
      let text = textNode.nodeValue;
      let replaced = false;

      namePatterns.forEach(pattern => {
        text = text.replace(pattern, match => {
          replaced = true;
          return `<strong>${match}</strong>`;
        });
      });

      if (replaced) {
        // Replace the text node with HTML
        const span = document.createElement("span");
        span.innerHTML = text;
        textNode.parentNode.replaceChild(span, textNode);
      }
    });
  }

  // Apply to all relevant parts of the document
  selectors.forEach(selector => {
    document.querySelectorAll(selector).forEach(el => boldAuthorText(el));
  });
});
